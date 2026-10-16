# Instala este perfil de Claude Code en ~/.claude en el dispositivo actual.
# Seguro de re-ejecutar: no duplica el bloque de CLAUDE.md, no borra contenido
# que el usuario tenga fuera de los marcadores config-claude, y en settings.json
# solo agrega claves (no quita las que ya tengas).
$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ClaudeDir = Join-Path $env:USERPROFILE ".claude"
$BeginMark = "<!-- BEGIN config-claude -->"
$EndMark = "<!-- END config-claude -->"
# Windows PowerShell 5.1 escribe BOM con -Encoding utf8, y JSON.parse no lo acepta.
$Utf8NoBom = New-Object System.Text.UTF8Encoding $false

function Write-Utf8NoBom($Path, $Text) {
    [System.IO.File]::WriteAllText($Path, $Text, $Utf8NoBom)
}

function Read-Utf8($Path) {
    # ReadAllText descarta el BOM si lo hay.
    return [System.IO.File]::ReadAllText($Path, [System.Text.Encoding]::UTF8)
}

foreach ($d in "skills", "agents", "commands") {
    New-Item -ItemType Directory -Force -Path (Join-Path $ClaudeDir $d) | Out-Null
}

Write-Host "Quitando lo que este repo ya no instala..."
foreach ($line in Get-Content -Path (Join-Path $ScriptDir "retirados.txt") -Encoding UTF8) {
    $rel = $line.Trim()
    if ($rel -eq "" -or $rel.StartsWith("#")) { continue }
    $target = Join-Path $ClaudeDir $rel
    if (Test-Path $target) {
        Remove-Item -Recurse -Force $target
        Write-Host "  - $rel"
    }
}

Write-Host "Copiando skills..."
# Cada skill se reemplaza completa para no dejar archivos que el repo ya quito.
foreach ($skill in Get-ChildItem -Directory -Path (Join-Path $ScriptDir "skills")) {
    $dest = Join-Path $ClaudeDir "skills\$($skill.Name)"
    if (Test-Path $dest) { Remove-Item -Recurse -Force $dest }
    Copy-Item -Path $skill.FullName -Destination $dest -Recurse
}

Write-Host "Copiando agentes y comandos..."
Copy-Item -Path (Join-Path $ScriptDir "agents\*") -Destination (Join-Path $ClaudeDir "agents") -Force
Copy-Item -Path (Join-Path $ScriptDir "commands\*") -Destination (Join-Path $ClaudeDir "commands") -Force

Write-Host "Actualizando CLAUDE.md..."
$Target = Join-Path $ClaudeDir "CLAUDE.md"
$existing = ""
if (Test-Path $Target) { $existing = Read-Utf8 $Target }

$kept = New-Object System.Collections.Generic.List[string]
$skip = $false
foreach ($line in ($existing -split "`r?`n")) {
    if ($line -eq $BeginMark) { $skip = $true; continue }
    if ($line -eq $EndMark) { $skip = $false; continue }
    if (-not $skip) { $kept.Add($line) }
}
# Trim evita que cada ejecucion acumule lineas en blanco.
$userPart = ($kept -join "`n").Trim()
$sourceContent = (Read-Utf8 (Join-Path $ScriptDir "CLAUDE.md")).Trim()
$block = "$BeginMark`n$sourceContent`n$EndMark`n"
if ($userPart -eq "") { $newContent = $block } else { $newContent = "$userPart`n`n$block" }
Write-Utf8NoBom $Target $newContent

Write-Host "Fusionando settings.json..."
$SettingsPath = Join-Path $ClaudeDir "settings.json"
$repoSettings = (Read-Utf8 (Join-Path $ScriptDir "settings.json")) | ConvertFrom-Json
if (Test-Path $SettingsPath) {
    $userSettings = (Read-Utf8 $SettingsPath) | ConvertFrom-Json
} else {
    $userSettings = New-Object PSObject
}
foreach ($prop in $repoSettings.PSObject.Properties) {
    $current = $userSettings.PSObject.Properties[$prop.Name]
    if ($null -eq $current) {
        $userSettings | Add-Member -NotePropertyName $prop.Name -NotePropertyValue $prop.Value
        continue
    }
    # Objetos (permissions, env): se agregan subclaves; las listas se unen sin duplicar.
    foreach ($sub in $prop.Value.PSObject.Properties) {
        $currentSub = $current.Value.PSObject.Properties[$sub.Name]
        if ($null -eq $currentSub) {
            $current.Value | Add-Member -NotePropertyName $sub.Name -NotePropertyValue $sub.Value
        } elseif ($sub.Value -is [System.Array]) {
            $current.Value.($sub.Name) = @(@($currentSub.Value) + @($sub.Value) | Select-Object -Unique)
        } else {
            $current.Value.($sub.Name) = $sub.Value
        }
    }
}
Write-Utf8NoBom $SettingsPath (($userSettings | ConvertTo-Json -Depth 20) + "`n")

Write-Host "Instalando plugins..."
# Un plugin que falla no debe cortar la instalacion de los demas.
$ErrorActionPreference = "Continue"
$plugins = (Read-Utf8 (Join-Path $ScriptDir "plugins.json")) | ConvertFrom-Json
$cli = $null
$cmd = Get-Command claude -ErrorAction SilentlyContinue
if ($null -ne $cmd) {
    $cli = $cmd.Source
} else {
    # La app de escritorio trae su propio CLI aunque no este en el PATH.
    $bundled = Get-ChildItem -Path (Join-Path $env:APPDATA "Claude\claude-code\*\*\claude.exe") -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($null -ne $bundled) { $cli = $bundled.FullName }
}

if ($null -eq $cli) {
    Write-Host "  No encontre el CLI de claude. Instala los plugins dentro de una sesion:"
    foreach ($m in $plugins.marketplaces) { Write-Host "    /plugin marketplace add $($m.source)" }
    foreach ($p in $plugins.plugins) { Write-Host "    /plugin install $p" }
} else {
    $known = (& $cli plugin marketplace list) -join "`n"
    foreach ($m in $plugins.marketplaces) {
        if ($known -match [regex]::Escape($m.name)) { continue }
        & $cli plugin marketplace add $m.source
        if ($LASTEXITCODE -ne 0) { Write-Warning "No se pudo agregar el marketplace $($m.source)" }
    }
    foreach ($p in $plugins.plugins) {
        & $cli plugin install $p --scope user
        if ($LASTEXITCODE -ne 0) { Write-Warning "No se pudo instalar $p" }
    }
}

Write-Host ""
Write-Host "Listo. Configuracion instalada en $ClaudeDir"
Write-Host "Abre una sesion nueva de Claude Code para que cargue los cambios."

# Instala este perfil de Claude Code en ~/.claude en el dispositivo actual.
# Seguro de re-ejecutar: no duplica el bloque de CLAUDE.md ni borra contenido
# que el usuario ya tenga fuera de los marcadores config-claude.
$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ClaudeDir = Join-Path $env:USERPROFILE ".claude"
$BeginMark = "<!-- BEGIN config-claude -->"
$EndMark = "<!-- END config-claude -->"

New-Item -ItemType Directory -Force -Path (Join-Path $ClaudeDir "skills") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $ClaudeDir "agents") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $ClaudeDir "commands") | Out-Null

Write-Host "Copiando skills..."
Copy-Item -Path (Join-Path $ScriptDir "skills\*") -Destination (Join-Path $ClaudeDir "skills") -Recurse -Force

Write-Host "Copiando agentes..."
Copy-Item -Path (Join-Path $ScriptDir "agents\*") -Destination (Join-Path $ClaudeDir "agents") -Recurse -Force

Write-Host "Copiando comandos..."
Copy-Item -Path (Join-Path $ScriptDir "commands\*") -Destination (Join-Path $ClaudeDir "commands") -Recurse -Force

Write-Host "Actualizando CLAUDE.md..."
$Target = Join-Path $ClaudeDir "CLAUDE.md"
$Source = Join-Path $ScriptDir "CLAUDE.md"

if (-not (Test-Path $Target)) {
    New-Item -ItemType File -Path $Target | Out-Null
}

$existing = Get-Content -Path $Target -Raw -Encoding UTF8 -ErrorAction SilentlyContinue
if ($null -eq $existing) { $existing = "" }

$lines = $existing -split "`r?`n"
$kept = New-Object System.Collections.Generic.List[string]
$skip = $false
foreach ($line in $lines) {
    if ($line -eq $BeginMark) { $skip = $true; continue }
    if ($line -eq $EndMark) { $skip = $false; continue }
    if (-not $skip) { $kept.Add($line) }
}

$sourceContent = Get-Content -Path $Source -Raw -Encoding UTF8
$newContent = ($kept -join "`n") + "`n`n$BeginMark`n$sourceContent`n$EndMark`n"
Set-Content -Path $Target -Value $newContent -Encoding utf8

Write-Host ""
Write-Host "Listo. Configuracion instalada en $ClaudeDir"
Write-Host ""
Write-Host "Opcional -- instala estos plugins oficiales dentro de una sesion de Claude Code:"
Write-Host "  /plugin marketplace add anthropics/skills"
Write-Host "  /plugin install document-skills@anthropic-agent-skills"
Write-Host ""
Write-Host "  /plugin marketplace add obra/superpowers"
Write-Host "  /plugin install superpowers@claude-plugins-official"

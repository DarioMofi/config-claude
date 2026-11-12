# Hook Stop: si hay archivos modificados después de la última actualización de Estado.md,
# le pide a Claude que lo actualice antes de terminar. Una sola vez por respuesta
# (stop_hook_active evita el ciclo). No modifica nada por su cuenta.
$ErrorActionPreference = "SilentlyContinue"
[Console]::OutputEncoding = New-Object System.Text.UTF8Encoding $false
[Console]::InputEncoding = New-Object System.Text.UTF8Encoding $false

$entrada = $null
try { $entrada = [Console]::In.ReadToEnd() | ConvertFrom-Json } catch {}
if ($entrada.stop_hook_active) { exit 0 }
$cwd = if ($entrada.cwd) { $entrada.cwd } else { (Get-Location).Path }

$root = git -C $cwd rev-parse --show-toplevel 2>$null
if (-not $root) { exit 0 }

# Archivos con cambios sin comitear, sin contar Estado.md ni los borrados.
$cambiados = @()
foreach ($l in (git -C $root -c core.quotepath=off status --porcelain --untracked-files=all)) {
    $ruta = $l.Substring(3) -replace '^.* -> ', '' -replace '^"|"$', ''
    if ($ruta -eq "Estado.md") { continue }
    $completa = Join-Path $root $ruta
    if (Test-Path $completa -PathType Leaf) { $cambiados += Get-Item $completa }
}
if ($cambiados.Count -eq 0) { exit 0 }

$estado = Join-Path $root "Estado.md"
$rama = git -C $root branch --show-current
if (Test-Path $estado) {
    $marca = (Get-Item $estado).LastWriteTime
    $nuevos = @($cambiados | Where-Object { $_.LastWriteTime -gt $marca })
    if ($nuevos.Count -eq 0) { exit 0 }
    $lista = ($nuevos | Select-Object -First 5 | ForEach-Object { $_.FullName.Substring($root.Length + 1) }) -join ", "
    $msg = "Hay archivos modificados después de la última actualización de Estado.md ($lista). Falta actualizar el bloque de la rama '$rama' en Estado.md según la regla de contexto compartido."
} else {
    # Repo propio: cuenta de GitHub en $Propios, o sin remoto. Debe coincidir con la regla de CLAUDE.md.
    $Propios = @("DarioMofi")
    $origin = git -C $root remote get-url origin 2>$null
    $propio = (-not $origin) -or ($origin -match 'github\.com[:/]+([^/]+)/' -and $Propios -contains $Matches[1])
    if ($propio) {
        $msg = "Hay cambios sin comitear en este repo propio y no existe Estado.md. Según la regla de contexto compartido, falta crearlo (con la línea 'Estado.md merge=union' en .gitattributes) y llenar el bloque de la rama '$rama'."
    } else {
        $msg = "Hay cambios sin comitear en este repo ajeno ($origin) y no existe Estado.md. Según la regla de contexto compartido, falta crearlo fuera de git (agregarlo a .git/info/exclude, sin tocar .gitattributes ni .gitignore) y llenar el bloque de la rama '$rama'."
    }
}

@{ hookSpecificOutput = @{ hookEventName = "Stop"; additionalContext = $msg } } | ConvertTo-Json -Compress
exit 0

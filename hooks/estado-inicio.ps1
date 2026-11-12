# Hook SessionStart: resume el estado del repo (Estado.md, worktrees, sincronización
# con origin) para que Claude arranque sabiendo qué falta. Solo informa; no modifica nada.
# Lo que imprime en stdout se agrega al contexto de la sesión.
$ErrorActionPreference = "SilentlyContinue"
[Console]::OutputEncoding = New-Object System.Text.UTF8Encoding $false
[Console]::InputEncoding = New-Object System.Text.UTF8Encoding $false
$env:GIT_TERMINAL_PROMPT = "0"

$cwd = (Get-Location).Path
try { $cwd = ([Console]::In.ReadToEnd() | ConvertFrom-Json).cwd } catch {}
if (-not $cwd) { $cwd = (Get-Location).Path }

$root = git -C $cwd rev-parse --show-toplevel 2>$null
if (-not $root) { exit 0 }

function Norm($p) { return ([System.IO.Path]::GetFullPath($p)).TrimEnd('\', '/').ToLower() }
function Existe($ref) { git -C $root show-ref --verify --quiet $ref; return ($LASTEXITCODE -eq 0) }

$equipo = $env:COMPUTERNAME
$rama = git -C $root branch --show-current
$avisos = New-Object System.Collections.Generic.List[string]

# Sincronizar referencias remotas, con tope de 8 s para no frenar el arranque sin red.
if (git -C $root remote) {
    $err = [System.IO.Path]::GetTempFileName()
    $p = Start-Process git -ArgumentList "-C", "`"$root`"", "fetch", "--quiet", "--prune" -NoNewWindow -PassThru -RedirectStandardError $err
    $null = $p.Handle  # sin esto, ExitCode queda vacío al terminar
    $ok = $p.WaitForExit(8000)
    if (-not $ok) { $p.Kill() }
    if (-not $ok -or $p.ExitCode -ne 0) { $avisos.Add("No se pudo consultar origin (sin red o sin acceso); el estado remoto puede estar desactualizado.") }
    Remove-Item $err -Force
}

# Worktrees locales: el primero de la lista es la carpeta principal.
$locales = @()
$actual = $null
foreach ($l in (git -C $root worktree list --porcelain)) {
    if ($l -like "worktree *") { $actual = @{ path = $l.Substring(9); branch = $null }; $locales += $actual }
    elseif ($l -like "branch refs/heads/*") { $actual.branch = $l.Substring(18) }
}
$principal = $locales[0].path
$ramaPrincipal = if (Existe "refs/heads/main") { "main" } else { "master" }

# Estado.md: el registro de worktrees se lee siempre de la carpeta principal.
$estadoAqui = Join-Path $root "Estado.md"
$estadoPrincipal = Join-Path $principal "Estado.md"
# Repo propio: cuenta de GitHub en $Propios, o sin remoto. Debe coincidir con la regla de CLAUDE.md.
$Propios = @("DarioMofi")
$origin = git -C $root remote get-url origin 2>$null
$propio = (-not $origin) -or ($origin -match 'github\.com[:/]+([^/]+)/' -and $Propios -contains $Matches[1])
if (-not $propio) {
    $avisos.Add("Repo ajeno ($origin): Estado.md no se versiona aquí; si se usa, va en .git/info/exclude.")
    git -C $root check-ignore -q Estado.md
    if ((Test-Path $estadoAqui) -and $LASTEXITCODE -ne 0) {
        $avisos.Add("Estado.md existe pero git no lo ignora en este repo ajeno: agregarlo a .git/info/exclude.")
    }
}
if (-not (Test-Path $estadoAqui)) {
    if ($propio) { $avisos.Add("No existe Estado.md en este repo.") }
} elseif ($rama -and -not (Select-String -Path $estadoAqui -SimpleMatch "### Rama: $rama" -Quiet)) {
    $avisos.Add("Estado.md no tiene bloque para la rama actual ($rama).")
}

$registro = @()
if (Test-Path $estadoPrincipal) {
    $enSeccion = $false
    foreach ($l in [System.IO.File]::ReadAllLines($estadoPrincipal)) {
        if ($l -match '^##\s+Worktrees') { $enSeccion = $true; continue }
        if ($enSeccion -and $l -match '^##\s') { break }
        if ($enSeccion -and $l -match '^\s*-\s*`([^`]+)`.*?`([^`]+)`.*?equipos:\s*(.+?)\s*$') {
            $registro += @{ rama = $Matches[1]; carpeta = $Matches[2]; equipos = @($Matches[3] -split '\s*,\s*' | Where-Object { $_ }) }
        }
    }
}

foreach ($r in $registro) {
    $destino = Norm (Join-Path $principal $r.carpeta)
    $local = $locales | Where-Object { (Norm $_.path) -eq $destino -or $_.branch -eq $r.rama } | Select-Object -First 1
    $existeRama = (Existe "refs/heads/$($r.rama)") -or (Existe "refs/remotes/origin/$($r.rama)")
    $aqui = $r.equipos -contains $equipo
    if (-not $existeRama) {
        $avisos.Add("La rama registrada '$($r.rama)' ya no existe (ni local ni en origin): cerrar su worktree aquí si existe y quitarla del registro.")
    } elseif (-not $local -and -not $aqui) {
        $avisos.Add("Worktree pendiente en este equipo: '$($r.rama)' se trabaja en paralelo en $($r.equipos -join ', '). Comando desde la carpeta principal: git worktree add $($r.carpeta) $($r.rama)")
    } elseif (-not $local -and $aqui) {
        $avisos.Add("El registro dice que este equipo tiene el worktree de '$($r.rama)', pero la carpeta no existe: git worktree prune y corregir el registro.")
    } elseif ($local -and -not $aqui) {
        $avisos.Add("El worktree de '$($r.rama)' existe aquí, pero este equipo ($equipo) no figura en el registro.")
    }
}
foreach ($w in ($locales | Select-Object -Skip 1)) {
    if ($w.branch -and -not ($registro | Where-Object { $_.rama -eq $w.branch })) {
        $avisos.Add("Worktree local sin registrar en Estado.md: '$($w.branch)' en $($w.path).")
    }
}

# Commits sin subir o sin bajar.
$ab = git -C $root rev-list --left-right --count "HEAD...@{u}" 2>$null
if ($ab -match '^(\d+)\s+(\d+)$') {
    if ([int]$Matches[1] -gt 0) { $avisos.Add("La rama $rama tiene $($Matches[1]) commit(s) sin subir a origin.") }
    if ([int]$Matches[2] -gt 0) { $avisos.Add("La rama $rama está $($Matches[2]) commit(s) detrás de origin: hacer git pull.") }
}
if ($rama -ne $ramaPrincipal) {
    $tras = git -C $root rev-list --count "$ramaPrincipal..origin/$ramaPrincipal" 2>$null
    if ($tras -and [int]$tras -gt 0) { $avisos.Add("$ramaPrincipal está $tras commit(s) detrás de origin: hacer git pull en la carpeta principal ($principal).") }
}

Write-Output "Estado del repo al iniciar (hook): rama '$rama', equipo $equipo."
if ($avisos.Count -eq 0) { Write-Output "- Sin pendientes de Estado.md, worktrees ni sincronización." }
foreach ($a in $avisos) { Write-Output "- $a" }
exit 0

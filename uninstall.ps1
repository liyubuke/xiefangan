# XieFangAn local bridge - uninstaller for Windows (Windows PowerShell 5.1 / PowerShell 7, no admin needed).
#   irm https://liyubuke.github.io/xiefangan/uninstall.ps1 | iex
# This file is pure ASCII on purpose: user-facing Chinese text is stored below as base64(UTF-8) and decoded at run time.

function Uninstall-XieFangAn {
    $ErrorActionPreference = 'Stop'

    $M = @{}
    foreach ($kv in @(
        'title=PT0g5YaZ5pa55qGIIMK3IOWNuOi9veacrOacuuacjeWKoe+8iFdpbmRvd3PvvIk9PQ==',
        'fail=w5cgezB9',
        'unexpected=5Y246L295Lit5pat77yaezB9',
        'notWindows=6L+Z5Liq6ISa5pys5Y+q55So5LqOIFdpbmRvd3PjgIJtYWNPUyDor7fnlKjlronoo4Xor7TmmI7pobXph4znmoQgbWFjT1Mg5Y246L295ZG95Luk44CC',
        'badName=5ZCv5Yqo6aG55ZCN56ew5Y+q6IO955So5a2X5q+N44CB5pWw5a2X44CB54K544CB5LiL5YiS57q/5ZKM5YeP5Y+377yaezB9',
        'stopped=4oiaIOW3suWBnOatouacrOacuuacjeWKoe+8iHswfSDkuKrov5vnqIvvvIk=',
        'notRunning=wrcg5pys5py65pyN5Yqh5rKh5Zyo6L+Q6KGM',
        'procWarn=ISDor7vkuI3liLDov5vnqIvliJfooajvvIzmsqHog73lgZzmraLmnKzmnLrmnI3liqHvvJp7MH3jgILlpoLliKDpmaTlpLHotKXvvIzph43lkK/nlLXohJHlkI7lho3ov5DooYzkuIDmrKHljbjovb3lkb3ku6TjgII=',
        'vbsDel=4oiaIOW3suWIoOmZpOWQr+WKqOmhuSB7MH0=',
        'vbsNone=wrcg5rKh5pyJ5ZCv5Yqo6aG5IHswfQ==',
        'taskDel=4oiaIOW3suWIoOmZpOavj+aXpeaPkOeCvOS7u+WKoSB7MH0=',
        'taskNone=wrcg5rKh5pyJ5q+P5pel5o+Q54K85Lu75Yqh',
        'destDel=4oiaIOW3suWIoOmZpCB7MH0=',
        'destNone=wrcg5a6J6KOF55uu5b2V5LiN5a2Y5Zyo77yaezB9',
        'destSkip=ISDlronoo4Xnm67lvZXkuI3lg4/lhpnmlrnmoYjnmoTnm67lvZXvvIzmnKrliKDpmaTvvJp7MH0=',
        'destFail=ISDliKDpmaQgezB9IOWksei0pe+8iHsxfe+8ie+8muWPr+iDvei/mOacieaWh+S7tuiiq+WNoOeUqO+8jOmHjeWQr+eUteiEkeWQjuWGjei/kOihjOS4gOasoeWNuOi9veWRveS7pOOAgg==',
        'tmpDel=4oiaIOW3suWIoOmZpOS4tOaXtuaWh+S7tiB7MH0=',
        'done=4oiaIOacrOacuuacjeWKoeW3suWNuOi9veOAguacgOWQjuWIsCBFZGdlIOWcsOWdgOagj+aJk+W8gCBlZGdlOi8vZXh0ZW5zaW9ucy8g56e76Zmk44CM5YaZ5pa55qGI44CN5o+S5Lu25Y2z5Y+v44CC'
    )) { $i = $kv.IndexOf('='); $M[$kv.Substring(0, $i)] = [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($kv.Substring($i + 1))) }
    function T([string]$k) {
        $s = $M[$k]
        if ($null -eq $s) { $s = $k }
        if ($args.Count -gt 0) { $s = $s -f $args }
        return $s
    }
    function Has([string]$s, [string]$sub) { return ($s -and $s.IndexOf($sub, [StringComparison]::OrdinalIgnoreCase) -ge 0) }
    function Get-ProcList {
        $f = "Name='node.exe' OR Name='cmd.exe' OR Name='powershell.exe' OR Name='pwsh.exe'"
        try { return @(Get-CimInstance -ClassName Win32_Process -Filter $f -ErrorAction Stop) }
        catch { return @(Get-WmiObject -Class Win32_Process -Filter $f -ErrorAction Stop) }
    }
    function Stop-Bridge([string]$runPath, [string]$serverPath) {
        $hits = @(Get-ProcList | Where-Object {
            $_.ProcessId -ne $PID -and $_.CommandLine -and (
                (($_.Name -eq 'powershell.exe' -or $_.Name -eq 'pwsh.exe') -and (Has $_.CommandLine $runPath)) -or
                (($_.Name -eq 'node.exe' -or $_.Name -eq 'cmd.exe') -and (Has $_.CommandLine $serverPath)))
        })
        $loops = @($hits | Where-Object { $_.Name -like 'p*' })
        $rest = @($hits | Where-Object { $_.Name -notlike 'p*' })
        foreach ($p in ($loops + $rest)) { Stop-Process -Id $p.ProcessId -Force -ErrorAction SilentlyContinue }
        if ($hits.Count -gt 0) { Start-Sleep -Milliseconds 1000 }
        return $hits.Count
    }

    $oldEnc = $null
    try { $oldEnc = [Console]::OutputEncoding; [Console]::OutputEncoding = [Text.Encoding]::UTF8 } catch {}
    try {
        Write-Host (T 'title')
        if ($env:OS -ne 'Windows_NT') { Write-Host (T 'fail' (T 'notWindows')) -ForegroundColor Red; return }
        $DEST = $env:XFA_DEST
        if (-not $DEST) { $DEST = Join-Path $env:LOCALAPPDATA 'XieFangAn' }
        $DEST = [IO.Path]::GetFullPath($DEST).TrimEnd('\')
        $STARTUP_NAME = $env:XFA_STARTUP_NAME
        if (-not $STARTUP_NAME) { $STARTUP_NAME = 'XieFangAn' }
        if ($STARTUP_NAME -notmatch '^[A-Za-z0-9_.-]+$') { Write-Host (T 'fail' (T 'badName' $STARTUP_NAME)) -ForegroundColor Red; return }
        $VBS = Join-Path ([Environment]::GetFolderPath('Startup')) ($STARTUP_NAME + '.vbs')

        try {
            $n = Stop-Bridge (Join-Path $DEST 'run.ps1') (Join-Path $DEST 'bridge\server.mjs')
            if ($n -gt 0) { Write-Host (T 'stopped' $n) } else { Write-Host (T 'notRunning') }
        } catch { Write-Host (T 'procWarn' $_.Exception.Message) -ForegroundColor Yellow }

        if (Test-Path -LiteralPath $VBS) { Remove-Item -LiteralPath $VBS -Force; Write-Host (T 'vbsDel' $VBS) } else { Write-Host (T 'vbsNone' $VBS) }

        $TASK = $env:XFA_DIGEST_TASK
        if (-not $TASK) { $TASK = 'XieFangAnDailyDigest' }
        if ($TASK -match '^[A-Za-z0-9_.-]+$') {
            $q = & schtasks /Query /TN $TASK 2>$null
            if ($LASTEXITCODE -eq 0) { & schtasks /Delete /TN $TASK /F 2>$null | Out-Null; Write-Host (T 'taskDel' $TASK) }
            else { Write-Host (T 'taskNone') }
        }

        $leaf = Split-Path -Leaf $DEST
        if (-not (Test-Path -LiteralPath $DEST)) {
            Write-Host (T 'destNone' $DEST)
        } elseif ($leaf -notlike '*XieFangAn*') {
            Write-Host (T 'destSkip' $DEST) -ForegroundColor Yellow
        } else {
            $err = ''
            for ($i = 0; $i -lt 3; $i++) {
                try { Remove-Item -LiteralPath $DEST -Recurse -Force; $err = ''; break } catch { $err = $_.Exception.Message; Start-Sleep -Seconds 1 }
            }
            if ($err) { Write-Host (T 'destFail' $DEST $err) -ForegroundColor Yellow } else { Write-Host (T 'destDel' $DEST) }
        }

        foreach ($t in @((Join-Path $env:TEMP 'xiefangan'), (Join-Path $env:TEMP 'xfa-login'))) {
            if (Test-Path -LiteralPath $t) {
                Remove-Item -LiteralPath $t -Recurse -Force -ErrorAction SilentlyContinue
                Write-Host (T 'tmpDel' $t)
            }
        }
        Write-Host ''
        Write-Host (T 'done') -ForegroundColor Green
    } catch {
        Write-Host (T 'fail' (T 'unexpected' $_.Exception.Message)) -ForegroundColor Red
    } finally {
        if ($oldEnc) { try { [Console]::OutputEncoding = $oldEnc } catch {} }
    }
}

Uninstall-XieFangAn

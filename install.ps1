# XieFangAn local bridge - one-line installer for Windows (Windows PowerShell 5.1 / PowerShell 7, no admin needed).
#   Install:   irm https://liyubuke.github.io/xiefangan/install.ps1 | iex
#   Uninstall: irm https://liyubuke.github.io/xiefangan/uninstall.ps1 | iex
# This file is pure ASCII on purpose: user-facing Chinese text is stored below as base64(UTF-8) and decoded at run time.

function Install-XieFangAn {
    $ErrorActionPreference = 'Stop'
    $ProgressPreference = 'SilentlyContinue'

    $M = @{}
    foreach ($kv in @(
        'title=PT0g5YaZ5pa55qGIIMK3IOWuieijheacrOacuuacjeWKoe+8iFdpbmRvd3PvvIk9PQ==',
        'fail=w5cgezB9',
        'seeSite=ICDlronoo4Xor7TmmI7lkozluLjop4Hpl67popjvvJp7MH0=',
        'unexpected=5a6J6KOF5Lit5pat77yaezB9',
        'notWindows=6L+Z5Liq6ISa5pys5Y+q55So5LqOIFdpbmRvd3PjgIJtYWNPUyDor7fnlKjlronoo4Xor7TmmI7pobXph4znmoQgbWFjT1Mg5ZG95Luk44CC',
        'psOld=6ZyA6KaBIFdpbmRvd3MgUG93ZXJTaGVsbCA1LjEg5oiW5pu05paw54mI5pys77yI5b2T5YmNIHswfe+8ieOAguivt+WFiOabtOaWsCBXaW5kb3dz44CC',
        'badPort=56uv5Y+j6K6+572u5LiN5a+577yaezB9',
        'badName=5ZCv5Yqo6aG55ZCN56ew5Y+q6IO955So5a2X5q+N44CB5pWw5a2X44CB54K544CB5LiL5YiS57q/5ZKM5YeP5Y+377yaezB9',
        'badExtId=5o+S5Lu2IElEIOWPquiDveaYr+Wtl+avjeWSjOaVsOWtl++8mnswfQ==',
        'foundClaude=4oiaIENsYXVkZSBDb2Rl77yaezB9',
        'noClaude=wrcg5rKh6KOFIENsYXVkZSBDb2Rl77yI5Y+v6YCJ77yJ',
        'foundCodex=4oiaIENvZGV477yaezB9',
        'noCodex=wrcg5rKh6KOFIENvZGV477yI5Y+v6YCJ77yJ',
        'foundWb=4oiaIFdvcmtCdWRkee+8mnswfQ==',
        'noWb=wrcg5rKh6KOFIFdvcmtCdWRkee+8iOWPr+mAie+8iQ==',
        'noEngine=Q2xhdWRlIENvZGXjgIFDb2RleOOAgVdvcmtCdWRkeSDkuIDkuKrpg73msqHmib7liLDjgILoh7PlsJHoo4Xlpb3kuIDkuKrvvIjlubbog73lnKggUG93ZXJTaGVsbCDph4zmraPluLjkvb/nlKjvvInvvIzlhbPmjonov5nkuKrnqpflj6PjgIHph43mlrDmiZPlvIAgUG93ZXJTaGVsbO+8jOWGjei/kOihjOS4gOasoeWuieijheWRveS7pOOAgg==',
        'stoppedOld=wrcg5bey5YGc5q2i5pen55qE5pys5py65pyN5Yqh77yIezB9IOS4qui/m+eoi++8iQ==',
        'procWarn=ISDor7vkuI3liLDov5vnqIvliJfooajvvIzmsqHog73mo4Dmn6Xml6fnmoTmnKzmnLrmnI3liqHvvJp7MH0=',
        'nodeFound=4oiaIE5vZGUuanPvvJp7MH3vvIh7MX3vvIk=',
        'nodeDownload=wrcg5rKh5om+5YiwIE5vZGUuanMgMTgg5Lul5LiK77yM5q2j5Zyo5LiL6L295L6/5pC654mIIE5vZGUuanMgezB977yIezF977yM57qmIDMwTULvvIzlj6rmlL7lnKjlronoo4Xnm67lvZXph4zvvIzkuI3lvbHlk43ns7vnu5/vvInigKY=',
        'nodeMirrorFail=ISDku44gezB9IOS4i+i9vSBOb2RlLmpzIOayoeaIkOWKn++8mnsxfQ==',
        'nodeShaBad=U0hBMjU2IOagoemqjOS4jemAmui/h++8iOaWh+S7tuWPr+iDveaNn+Wdj+aIluiiq+evoeaUue+8iQ==',
        'nodeShaMissing=5qCh6aqM5paH5Lu26YeM5rKh5pyJIHswfQ==',
        'nodeFail=5LiL6L29IE5vZGUuanMg5aSx6LSl44CC6K+35qOA5p+l572R57uc5ZCO6YeN6K+V77yb5oiW6ICF5YiwIGh0dHBzOi8vbm9kZWpzLm9yZyDkuIvovb0gTFRTIOeJiOWuieijhe+8jOWFs+aOiei/meS4queql+WPo+OAgemHjeaWsOaJk+W8gCBQb3dlclNoZWxs77yM5YaN6L+Q6KGM5LiA5qyh5a6J6KOF5ZG95Luk44CC',
        'nodeBroken=5LiL6L2955qEIE5vZGUuanMg6L+Q6KGM5LiN5LqG77yaezB944CC5Y+v6IO96KKr5p2A5q+S6L2v5Lu25oum5oiq77yM6K+35Zyo5p2A5q+S6L2v5Lu26YeM5YWB6K645ZCO5YaN6L+Q6KGM5LiA5qyh5a6J6KOF5ZG95Luk44CC',
        'badArch=5LiN5pSv5oyB6L+Z5Y+w55S16ISR55qEIENQVSDmnrbmnoTvvJp7MH0=',
        'dlApp=wrcg5LiL6L295pys5py65pyN5Yqh4oCm',
        'dlFail=5LiL6L295aSx6LSl77yaezB977yI5qOA5p+l572R57uc77yM5oiW56iN5ZCO5YaN6K+V77yJ44CC',
        'noTar=6L+Z5Y+w55S16ISR5rKh5pyJIHRhciDlkb3ku6TvvIjpnIDopoEgV2luZG93cyAxMCAxODAzIOaIluabtOaWsOeJiOacrO+8ieOAguivt+WFiOabtOaWsCBXaW5kb3dz77yM5YaN6L+Q6KGM5LiA5qyh5a6J6KOF5ZG95Luk44CC',
        'untarFail=5a6J6KOF5YyF6Kej5Y6L5aSx6LSl77yM6K+36YeN5paw6L+Q6KGM5a6J6KOF5ZG95Luk44CC',
        'incomplete=5a6J6KOF5YyF5YaF5a655LiN5a6M5pW077yM6K+36YeN5paw6L+Q6KGM5a6J6KOF5ZG95Luk44CC',
        'mkdirFail=5peg5rOV5YaZ5YWl5a6J6KOF55uu5b2V77yaezB977yIezF977yJ',
        'rulesBak=wrcg5L2g5pS56L+H55qE6KeE5YiZ5bey5aSH5Lu95Li6IHJ1bGVzLm1kLmJhaw==',
        'extIdHolder=ISDmj5DnpLrvvJrmj5Lku7YgSUQg6L+Y5piv5Y2g5L2N56ym77yIezB977yJ77yM5ZWG5bqX54mI5o+S5Lu25Lya6L+e5LiN5LiK77yM6K+36IGU57O75Y+R5biD5pa544CC',
        'wshOff=ISDov5nlj7DnlLXohJHnpoHnlKjkuoYgV2luZG93cyBTY3JpcHQgSG9zdO+8jOW8gOacuuiHquWKqOi/kOihjOeUqOS4jeS6hu+8m+i/measoeWFiOebtOaOpeWQr+WKqO+8jOmHjeWQr+eUteiEkeWQjumcgOimgeWGjei/kOihjOS4gOasoeWuieijheWRveS7pOOAgg==',
        'startupFail=ISDmsqHog73lhpnlhaXlvIDmnLrlkK/liqjpobnvvIh7MH3vvInvvJvov5nmrKHlhYjnm7TmjqXlkK/liqjvvIzph43lkK/nlLXohJHlkI7pnIDopoHlho3ov5DooYzkuIDmrKHlronoo4Xlkb3ku6TjgII=',
        'directStart=wrcg5ZCv5Yqo6aG55rKh5pyJ5ouJ6LW35pyN5Yqh77yM5pS55Li655u05o6l5ZCv5Yqo',
        'portBusy=56uv5Y+jIHswfSDooqvliKvnmoTnqIvluo/ljaDnlKjvvIh7MX3vvIxQSUQgezJ977yJ44CC5YWI5YWz5o6J5a6D5YaN6L+Q6KGM5LiA5qyh5a6J6KOF5ZG95Luk44CC',
        'starting=wrcg5ZCv5Yqo5Lit4oCm',
        'okTitle=4oiaIOijheWlveS6hu+8jOWbnuWIsCBFZGdlIOS+p+i+ueagj+WNs+WPr+S9v+eUqA==',
        'okDetail=ICDvvIjmnKzmnLrmnI3liqHvvJoxMjcuMC4wLjE6ezB9IMK3IOaXpeW/l++8mnsxfe+8iQ==',
        'okAutostart=ICDlt7Lorr7kuLrlvIDmnLroh6rliqjov5DooYzvvIjlkK/liqjpobnvvJp7MH3vvIk=',
        'okLogin=ICBDb2RleCAvIFdvcmtCdWRkeSDnrKzkuIDmrKHkvb/nlKjml7blpoLmnpzmsqHnmbvlvZXvvIzmj5Lku7bkvJroh6rliqjluKbkvaDnmbvlvZU=',
        'noExtId=5pyN5Yqh5bey6L+Q6KGM77yM5L2G5rKh6K6k5Ye65o+S5Lu2IElE44CC6K+36YeN5paw6L+Q6KGM5LiA5qyh5a6J6KOF5ZG95Luk44CC',
        'lastLog=5pyA6L+R55qE5pel5b+X77ya',
        'noLog=77yI6L+Y5rKh5pyJ5pel5b+X77yJ',
        'startFail=5pys5py65pyN5Yqh5rKh5pyJ5ZCv5Yqo5oiQ5Yqf77yI56uv5Y+jIHswfe+8ieOAguWmguaenOiiq+adgOavkui9r+S7tuaLpuaIqu+8jOivt+WcqOadgOavkui9r+S7tumHjOWFgeiuuOWQjuWGjei/kOihjOS4gOasoeWuieijheWRveS7pOOAgg=='
    )) { $i = $kv.IndexOf('='); $M[$kv.Substring(0, $i)] = [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($kv.Substring($i + 1))) }
    function T([string]$k) {
        $s = $M[$k]
        if ($null -eq $s) { $s = $k }
        if ($args.Count -gt 0) { $s = $s -f $args }
        return $s
    }
    function Die([string]$msg) {
        Write-Host ''
        Write-Host (T 'fail' $msg) -ForegroundColor Red
        Write-Host (T 'seeSite' $SITE)
        throw 'XFA_ABORT'
    }
    function Q([string]$s) { return "'" + $s.Replace("'", "''") + "'" }
    function Has([string]$s, [string]$sub) { return ($s -and $s.IndexOf($sub, [StringComparison]::OrdinalIgnoreCase) -ge 0) }
    function Is-File($p) { return ($p -and (Test-Path -LiteralPath $p -PathType Leaf)) }
    function Get-Url([string]$url, [string]$out) {
        Invoke-WebRequest -Uri $url -OutFile $out -UseBasicParsing -TimeoutSec 600
    }
    function Find-App([string]$name, [string[]]$extra) {
        $c = @()
        try {
            $c += @(Get-Command $name -CommandType Application -ErrorAction Stop |
                ForEach-Object { $_.Path } | Where-Object { $_ -match '\.(exe|cmd|bat)$' })
        } catch {}
        $c += @($extra)
        $c = @($c | Where-Object { Is-File $_ })
        $exe = @($c | Where-Object { $_ -like '*.exe' })
        if ($exe.Count -gt 0) { return $exe[0] }
        if ($c.Count -gt 0) { return $c[0] }
        return ''
    }
    function Node-Major([string]$p) {
        if (-not (Is-File $p)) { return 0 }
        $ErrorActionPreference = 'Continue'
        $v = ''
        try { $v = "$(& $p -v 2>$null)".Trim() } catch {}
        if ($v -match '^v(\d+)\.') { return [int]$Matches[1] }
        return 0
    }
    function Node-Version([string]$p) {
        $ErrorActionPreference = 'Continue'
        try { return "$(& $p -v 2>$null)".Trim() } catch { return '?' }
    }
    function Dir-Version([string]$n) {
        if ($n -match '(\d+)\.(\d+)\.(\d+)') { return [version]("{0}.{1}.{2}" -f $Matches[1], $Matches[2], $Matches[3]) }
        return [version]'0.0.0'
    }
    function Get-ProcList {
        $f = "Name='node.exe' OR Name='cmd.exe' OR Name='powershell.exe' OR Name='pwsh.exe'"
        try { return @(Get-CimInstance -ClassName Win32_Process -Filter $f -ErrorAction Stop) }
        catch { return @(Get-WmiObject -Class Win32_Process -Filter $f -ErrorAction Stop) }
    }
    function Find-Bridge([string]$runPath, [string]$serverPath) {
        return @(Get-ProcList | Where-Object {
            $_.ProcessId -ne $PID -and $_.CommandLine -and (
                (($_.Name -eq 'powershell.exe' -or $_.Name -eq 'pwsh.exe') -and (Has $_.CommandLine $runPath)) -or
                (($_.Name -eq 'node.exe' -or $_.Name -eq 'cmd.exe') -and (Has $_.CommandLine $serverPath)))
        })
    }
    function Stop-Bridge([string]$runPath, [string]$serverPath) {
        $hits = @(Find-Bridge $runPath $serverPath)
        $loops = @($hits | Where-Object { $_.Name -like 'p*' })
        $rest = @($hits | Where-Object { $_.Name -notlike 'p*' })
        foreach ($p in ($loops + $rest)) { Stop-Process -Id $p.ProcessId -Force -ErrorAction SilentlyContinue }
        if ($hits.Count -gt 0) { Start-Sleep -Milliseconds 800 }
        return $hits.Count
    }
    function Get-PortOwner([int]$port) {
        $c = $null
        try { $c = @(Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction Stop)[0] } catch { return $null }
        if (-not $c) { return $null }
        $name = '?'
        try { $name = (Get-Process -Id $c.OwningProcess -ErrorAction Stop).ProcessName } catch {}
        return @{ Pid = $c.OwningProcess; Name = $name }
    }
    function Test-Wsh {
        foreach ($k in 'HKCU:\Software\Microsoft\Windows Script Host\Settings', 'HKLM:\Software\Microsoft\Windows Script Host\Settings') {
            try { if ("$((Get-ItemProperty -LiteralPath $k -Name Enabled -ErrorAction Stop).Enabled)" -eq '0') { return $false } } catch {}
        }
        return $true
    }
    function Test-Health([string]$port, [hashtable]$headers) {
        $p = @{ Uri = "http://127.0.0.1:$port/health"; Method = 'Post'; Headers = $headers; UseBasicParsing = $true; TimeoutSec = 3 }
        if ($PSVersionTable.PSVersion.Major -ge 6) { $p.NoProxy = $true }
        try { return ((Invoke-WebRequest @p).StatusCode -eq 200) } catch { return $false }
    }

    $oldEnc = $null
    try { $oldEnc = [Console]::OutputEncoding; [Console]::OutputEncoding = [Text.Encoding]::UTF8 } catch {}
    try { [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12 } catch {}
    $SITE = $env:XFA_SITE
    if (-not $SITE) { $SITE = 'https://liyubuke.github.io/xiefangan' }
    $SITE = $SITE.TrimEnd('/')
    $TMP = $null
    $pushed = $false
    try {
        Write-Host (T 'title')
        if ($env:OS -ne 'Windows_NT') { Die (T 'notWindows') }
        if ($PSVersionTable.PSVersion.Major -lt 5) { Die (T 'psOld' $PSVersionTable.PSVersion) }

        $EXT_ID = $env:XFA_EXT_ID
        if (-not $EXT_ID) { $EXT_ID = 'jjnopgdhcpnbmpoefhfolbhgdfpmgklc' }
        $DEST = $env:XFA_DEST
        if (-not $DEST) { $DEST = Join-Path $env:LOCALAPPDATA 'XieFangAn' }
        $DEST = [IO.Path]::GetFullPath($DEST).TrimEnd('\')
        $PORT = $env:XFA_PORT
        if (-not $PORT) { $PORT = '19930' }
        $STARTUP_NAME = $env:XFA_STARTUP_NAME
        if (-not $STARTUP_NAME) { $STARTUP_NAME = 'XieFangAn' }
        if ($PORT -notmatch '^\d{1,5}$' -or [int]$PORT -lt 1 -or [int]$PORT -gt 65535) { Die (T 'badPort' $PORT) }
        if ($STARTUP_NAME -notmatch '^[A-Za-z0-9_.-]+$') { Die (T 'badName' $STARTUP_NAME) }
        if ($EXT_ID -notmatch '^[A-Za-z0-9_]+$') { Die (T 'badExtId' $EXT_ID) }
        $BRIDGE = Join-Path $DEST 'bridge'
        $SERVER = Join-Path $BRIDGE 'server.mjs'
        $RUN = Join-Path $DEST 'run.ps1'
        $LOGDIR = Join-Path $DEST 'logs'
        $LOG = Join-Path $LOGDIR 'bridge.log'
        $NODEDIR = Join-Path $DEST 'node'
        $STARTUP = [Environment]::GetFolderPath('Startup')
        $VBS = Join-Path $STARTUP ($STARTUP_NAME + '.vbs')
        $UP = $env:USERPROFILE
        $AD = $env:APPDATA
        $LAD = $env:LOCALAPPDATA

        $CLAUDE = Find-App 'claude' @((Join-Path $UP '.local\bin\claude.exe'), (Join-Path $AD 'npm\claude.cmd'))
        $CODEX = Find-App 'codex' @((Join-Path $AD 'npm\codex.cmd'), (Join-Path $UP '.local\bin\codex.exe'))
        $WB_FULL = Find-App 'codebuddy' @((Join-Path $UP '.local\bin\codebuddy.exe'), (Join-Path $AD 'npm\codebuddy.cmd'))
        $WB_APP = ''
        $roots = @()
        foreach ($pf in @($env:ProgramW6432, $env:ProgramFiles)) { if ($pf) { $roots += (Join-Path $pf 'WorkBuddy') } }
        $roots += (Join-Path $LAD 'Programs\WorkBuddy')
        foreach ($root in $roots) {
            $cand = Join-Path $root 'resources\app.asar.unpacked\cli\bin\codebuddy'
            if (Is-File $cand) { $WB_APP = $cand; break }
        }
        $WB_CLI = $WB_FULL
        if (-not $WB_CLI) { $WB_CLI = $WB_APP }
        if ($CLAUDE) { Write-Host (T 'foundClaude' $CLAUDE) } else { Write-Host (T 'noClaude') }
        if ($CODEX) { Write-Host (T 'foundCodex' $CODEX) } else { Write-Host (T 'noCodex') }
        if ($WB_CLI) { Write-Host (T 'foundWb' $WB_CLI) } else { Write-Host (T 'noWb') }
        if (-not ($CLAUDE -or $CODEX -or $WB_CLI)) { Die (T 'noEngine') }

        $n = 0
        try { $n = Stop-Bridge $RUN $SERVER } catch { Write-Host (T 'procWarn' $_.Exception.Message) -ForegroundColor Yellow }
        if ($n -gt 0) { Write-Host (T 'stoppedOld' $n) }

        try {
            foreach ($d in @($DEST, $BRIDGE, $LOGDIR)) { if (-not (Test-Path -LiteralPath $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null } }
        } catch { Die (T 'mkdirFail' $DEST $_.Exception.Message) }
        $TMP = Join-Path ([IO.Path]::GetTempPath()) ('xfa-install-' + [Guid]::NewGuid().ToString('N').Substring(0, 8))
        New-Item -ItemType Directory -Path $TMP -Force | Out-Null

        $WB_NODE = ''
        $wbNodes = @()
        $wbVer = Join-Path $UP '.workbuddy\binaries\node\versions'
        if (Test-Path -LiteralPath $wbVer) {
            foreach ($d in @(Get-ChildItem -LiteralPath $wbVer -Directory -ErrorAction SilentlyContinue | Sort-Object { Dir-Version $_.Name } -Descending)) {
                foreach ($c in @((Join-Path $d.FullName 'node.exe'), (Join-Path $d.FullName 'bin\node.exe'))) { if (Is-File $c) { $wbNodes += $c } }
            }
        }
        foreach ($c in $wbNodes) { if ((Node-Major $c) -ge 22) { $WB_NODE = $c; break } }
        $NODE = Find-App 'node' @()
        if ((Node-Major $NODE) -lt 18) {
            $NODE = ''
            foreach ($c in $wbNodes) { if ((Node-Major $c) -ge 18) { $NODE = $c; break } }
        }
        if (-not $NODE -and (Node-Major (Join-Path $NODEDIR 'node.exe')) -ge 18) { $NODE = Join-Path $NODEDIR 'node.exe' }
        if (-not $NODE) {
            $NODE_VER = '20.18.0'
            $arch = $env:PROCESSOR_ARCHITEW6432
            if (-not $arch) { $arch = $env:PROCESSOR_ARCHITECTURE }
            $na = ''
            if ($arch -eq 'AMD64') { $na = 'x64' } elseif ($arch -eq 'ARM64') { $na = 'arm64' } elseif ($arch -eq 'x86') { $na = 'x86' } else { Die (T 'badArch' $arch) }
            $pkg = "node-v$NODE_VER-win-$na"
            Write-Host (T 'nodeDownload' $NODE_VER $na)
            $zip = Join-Path $TMP "$pkg.zip"
            $sums = Join-Path $TMP 'SHASUMS256.txt'
            $got = $false
            foreach ($mirror in @('https://npmmirror.com/mirrors/node', 'https://nodejs.org/dist')) {
                try {
                    Get-Url "$mirror/v$NODE_VER/$pkg.zip" $zip
                    Get-Url "$mirror/v$NODE_VER/SHASUMS256.txt" $sums
                    $line = @(Get-Content -LiteralPath $sums | Where-Object { $_ -match ('\s' + [regex]::Escape("$pkg.zip") + '\s*$') })[0]
                    if (-not $line) { throw (T 'nodeShaMissing' "$pkg.zip") }
                    $want = ($line.Trim() -split '\s+')[0]
                    $have = (Get-FileHash -LiteralPath $zip -Algorithm SHA256).Hash
                    if ($want -ne $have) { throw (T 'nodeShaBad') }
                    $got = $true
                    break
                } catch {
                    Write-Host (T 'nodeMirrorFail' $mirror $_.Exception.Message) -ForegroundColor Yellow
                    Remove-Item -LiteralPath $zip, $sums -Force -ErrorAction SilentlyContinue
                }
            }
            if (-not $got) { Die (T 'nodeFail') }
            $xdir = Join-Path $DEST 'node-x'
            try {
                if (Test-Path -LiteralPath $xdir) { Remove-Item -LiteralPath $xdir -Recurse -Force }
                Add-Type -AssemblyName System.IO.Compression.FileSystem
                [IO.Compression.ZipFile]::ExtractToDirectory($zip, $xdir)
                if (Test-Path -LiteralPath $NODEDIR) { Remove-Item -LiteralPath $NODEDIR -Recurse -Force }
                Move-Item -LiteralPath (Join-Path $xdir $pkg) -Destination $NODEDIR
                Remove-Item -LiteralPath $xdir -Recurse -Force -ErrorAction SilentlyContinue
            } catch { Die (T 'nodeBroken' $_.Exception.Message) }
            $NODE = Join-Path $NODEDIR 'node.exe'
            if ((Node-Major $NODE) -lt 18) { Die (T 'nodeBroken' $NODE) }
        }
        Write-Host (T 'nodeFound' $NODE (Node-Version $NODE))

        Write-Host (T 'dlApp')
        $tgz = Join-Path $TMP 'app.tar.gz'
        $ok = $true
        try { Get-Url "$SITE/app.tar.gz" $tgz } catch { $ok = $false }
        if (-not $ok) { Die (T 'dlFail' "$SITE/app.tar.gz") }
        $tar = Join-Path $env:SystemRoot 'System32\tar.exe'
        if (-not (Is-File $tar)) { $tar = Find-App 'tar' @() }
        if (-not $tar) { Die (T 'noTar') }
        $appDir = Join-Path $TMP 'app'
        New-Item -ItemType Directory -Path $appDir -Force | Out-Null
        $code = 1
        Push-Location -LiteralPath $appDir
        $pushed = $true
        try {
            $ErrorActionPreference = 'Continue'
            & $tar -xzf '..\app.tar.gz' 2>$null | Out-Null
            $code = $LASTEXITCODE
        } catch { $code = 1 } finally { $ErrorActionPreference = 'Stop'; Pop-Location; $pushed = $false }
        if ($code -ne 0) { Die (T 'untarFail') }
        $newServer = Join-Path $appDir 'bridge\server.mjs'
        $newRules = Join-Path $appDir 'rules.md'
        if (-not ((Is-File $newServer) -and (Is-File $newRules))) { Die (T 'incomplete') }
        $rules = Join-Path $DEST 'rules.md'
        try {
            if ((Is-File $rules) -and ((Get-FileHash -LiteralPath $rules).Hash -ne (Get-FileHash -LiteralPath $newRules).Hash)) {
                Copy-Item -LiteralPath $rules -Destination (Join-Path $DEST 'rules.md.bak') -Force
                Write-Host (T 'rulesBak')
            }
            Copy-Item -LiteralPath $newServer -Destination $SERVER -Force
            Copy-Item -LiteralPath $newRules -Destination $rules -Force
        } catch { Die (T 'mkdirFail' $DEST $_.Exception.Message) }

        $tokFile = Join-Path $BRIDGE 'token'
        $TOKEN = ''
        if (Is-File $tokFile) { $TOKEN = ([IO.File]::ReadAllText($tokFile)).Trim() }
        if ($TOKEN -notmatch '^[0-9a-fA-F]{16,}$') {
            $b = New-Object byte[] 24
            [Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($b)
            $TOKEN = -join ($b | ForEach-Object { $_.ToString('x2') })
        }
        [IO.File]::WriteAllText($tokFile, $TOKEN + "`n")
        if ($EXT_ID -like '__*') { Write-Host (T 'extIdHolder' $EXT_ID) -ForegroundColor Yellow }
        [IO.File]::WriteAllText((Join-Path $BRIDGE 'allowed_ids'), $EXT_ID + "`n")

        $envs = [ordered]@{ GZD_PORT = $PORT }
        if ($CLAUDE) { $envs['GZD_CLAUDE'] = $CLAUDE }
        if ($CODEX) { $envs['GZD_CODEX'] = $CODEX }
        if ($WB_CLI) { $envs['GZD_WB_CLI'] = $WB_CLI }
        if ($WB_APP) { $envs['GZD_WB_APP_CLI'] = $WB_APP }
        if ($WB_NODE) { $envs['GZD_WB_NODE'] = $WB_NODE }
        $pathAdd = @()
        foreach ($p in @($NODE, $CLAUDE, $CODEX, $WB_FULL)) { if ($p) { $pathAdd += (Split-Path -Parent $p) } }
        $pathAdd += @((Join-Path $UP '.local\bin'), (Join-Path $AD 'npm'))
        $envs['XFA_PATH_ADD'] = (@($pathAdd | Select-Object -Unique) -join ';')
        $envLines = @()
        foreach ($k in $envs.Keys) { $envLines += ('$env:' + $k + ' = ' + (Q $envs[$k])) }
        $cmdExe = Join-Path $env:SystemRoot 'System32\cmd.exe'
        $runTpl = @'
# XieFangAn local bridge - restart loop. Generated by install.ps1; rerun the installer to regenerate.
$ErrorActionPreference = 'Continue'
@@ENV@@
$env:PATH = $env:XFA_PATH_ADD + ';' + $env:PATH
$node = @@NODE@@
$server = @@SERVER@@
$log = @@LOG@@
$cmdExe = @@CMD@@
$cmdArgs = '/d /s /c ""' + $node + '" "' + $server + '" >> "' + $log + '" 2>&1"'
function Note([string]$s) { try { [IO.File]::AppendAllText($log, '[' + (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') + '] run.ps1: ' + $s + "`r`n") } catch {} }
while ($true) {
    try { if ((Get-Item -LiteralPath $log -ErrorAction Stop).Length -gt 5MB) { Move-Item -LiteralPath $log -Destination ($log + '.1') -Force } } catch {}
    Note 'start node'
    $code = '?'
    try {
        $si = New-Object Diagnostics.ProcessStartInfo
        $si.FileName = $cmdExe
        $si.Arguments = $cmdArgs
        $si.UseShellExecute = $false
        $si.CreateNoWindow = $true
        $p = [Diagnostics.Process]::Start($si)
        $p.WaitForExit()
        $code = $p.ExitCode
    } catch { $code = $_.Exception.Message }
    Note ('node exited (' + $code + '), restart in 3s')
    Start-Sleep -Seconds 3
}
'@
        $runText = $runTpl.Replace('@@ENV@@', ($envLines -join "`r`n")).Replace('@@NODE@@', (Q $NODE)).Replace('@@SERVER@@', (Q $SERVER)).Replace('@@LOG@@', (Q $LOG)).Replace('@@CMD@@', (Q $cmdExe))
        [IO.File]::WriteAllText($RUN, $runText, (New-Object Text.UTF8Encoding $true))

        $psExe = Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'
        $psArgs = '-NoProfile -NonInteractive -WindowStyle Hidden -Command "& ([ScriptBlock]::Create([IO.File]::ReadAllText(' + (Q $RUN) + ', [Text.Encoding]::UTF8)))"'
        $vbsText = "' XieFangAn local bridge autostart (hidden window). Remove: irm $SITE/uninstall.ps1 | iex`r`n" +
            'CreateObject("WScript.Shell").Run "' + ('"' + $psExe + '" ' + $psArgs).Replace('"', '""') + '", 0, False' + "`r`n"
        $wsh = Test-Wsh
        $vbsOk = $false
        try {
            if (-not (Test-Path -LiteralPath $STARTUP)) { New-Item -ItemType Directory -Path $STARTUP -Force | Out-Null }
            [IO.File]::WriteAllText($VBS, $vbsText, [Text.Encoding]::Unicode)
            $vbsOk = $true
        } catch { Write-Host (T 'startupFail' $_.Exception.Message) -ForegroundColor Yellow }
        if (-not $wsh) { Write-Host (T 'wshOff') -ForegroundColor Yellow }

        $owner = $null
        for ($i = 0; $i -lt 10; $i++) { $owner = Get-PortOwner ([int]$PORT); if (-not $owner) { break }; Start-Sleep -Milliseconds 500 }
        if ($owner) { Die (T 'portBusy' $PORT $owner.Name $owner.Pid) }
        Write-Host (T 'starting')
        $started = $false
        if ($vbsOk -and $wsh) {
            try {
                Start-Process -FilePath (Join-Path $env:SystemRoot 'System32\wscript.exe') -ArgumentList ('"' + $VBS + '"')
                for ($i = 0; $i -lt 10 -and -not $started; $i++) {
                    Start-Sleep -Milliseconds 500
                    try { if (@(Find-Bridge $RUN $SERVER).Count -gt 0) { $started = $true } } catch { $started = $true }
                }
            } catch {}
        }
        if (-not $started) {
            if ($vbsOk -and $wsh) { Write-Host (T 'directStart') }
            Start-Process -FilePath $psExe -ArgumentList $psArgs -WindowStyle Hidden
        }

        for ($i = 0; $i -lt 40; $i++) {
            if (Test-Health $PORT @{ 'X-Gzd-Token' = $TOKEN }) {
                if (-not (Test-Health $PORT @{ 'Origin' = "chrome-extension://$EXT_ID" })) { Die (T 'noExtId') }
                Write-Host ''
                Write-Host (T 'okTitle') -ForegroundColor Green
                Write-Host (T 'okDetail' $PORT $LOG)
                if ($vbsOk -and $wsh) { Write-Host (T 'okAutostart' $VBS) }
                if ($CODEX -or $WB_CLI) { Write-Host (T 'okLogin') }
                return
            }
            Start-Sleep -Milliseconds 500
        }
        Write-Host (T 'lastLog')
        if (Is-File $LOG) { Get-Content -LiteralPath $LOG -Tail 20 -Encoding UTF8 | ForEach-Object { Write-Host $_ } } else { Write-Host (T 'noLog') }
        Die (T 'startFail' $PORT)
    } catch {
        if ("$($_.Exception.Message)" -ne 'XFA_ABORT') {
            Write-Host ''
            Write-Host (T 'fail' (T 'unexpected' $_.Exception.Message)) -ForegroundColor Red
            Write-Host (T 'seeSite' $SITE)
        }
    } finally {
        if ($pushed) { try { Pop-Location } catch {} }
        if ($TMP -and (Test-Path -LiteralPath $TMP)) { Remove-Item -LiteralPath $TMP -Recurse -Force -ErrorAction SilentlyContinue }
        if ($oldEnc) { try { [Console]::OutputEncoding = $oldEnc } catch {} }
    }
}

Install-XieFangAn

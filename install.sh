#!/bin/bash
# 「写方案」本机服务一键安装：curl -fsSL https://liyubuke.github.io/xiefangan/install.sh | bash
# 非交互、可重复执行（重装保留原令牌）。做的事：找引擎和 Node.js → 下载服务到 ~/Library/Application Support/XieFangAn
# → 登记商店版插件 ID → 注册登录后自动运行的后台服务（只监听 127.0.0.1）→ 自检。
# 测试用环境变量：XFA_SITE（下载源）、XFA_DEST（安装目录）、XFA_PORT（端口）、XFA_LABEL（launchd 标签）、XFA_EXT_ID（插件 ID）。
# 整个脚本包在 main 里，下载不完整时不会执行半截。

main() {
  SITE="${XFA_SITE:-https://liyubuke.github.io/xiefangan}"; SITE="${SITE%/}"
  EXT_ID="${XFA_EXT_ID:-jjnopgdhcpnbmpoefhfolbhgdfpmgklc}"
  DEST="${XFA_DEST:-$HOME/Library/Application Support/XieFangAn}"
  PORT="${XFA_PORT:-19930}"
  LABEL="${XFA_LABEL:-com.xiefangan.bridge}"
  PLIST="$HOME/Library/LaunchAgents/$LABEL.plist"
  if [ "$LABEL" = com.xiefangan.bridge ]; then LOG="$HOME/Library/Logs/xiefangan-bridge.log"; else LOG="$HOME/Library/Logs/$LABEL.log"; fi
  export PATH="$HOME/.local/bin:$HOME/.claude/local:/opt/homebrew/bin:/usr/local/bin:$PATH"

  die() { echo; echo "✗ $*"; echo "  安装说明和常见问题：$SITE"; exit 1; }

  echo "== 写方案 · 安装本机服务 =="
  [ "$(uname -s)" = Darwin ] || die "目前只支持 macOS。"
  case "$PORT" in ''|*[!0-9]*) die "端口设置不对：$PORT";; esac

  # 1. 三个引擎装了哪个用哪个，至少要有一个
  CLAUDE="$(command -v claude || true)"
  [ -z "$CLAUDE" ] && [ -x "$HOME/.claude/local/claude" ] && CLAUDE="$HOME/.claude/local/claude"
  CODEX="$(command -v codex || true)"
  [ -z "$CODEX" ] && [ -x /Applications/ChatGPT.app/Contents/Resources/codex-cli/bin/codex ] && CODEX=/Applications/ChatGPT.app/Contents/Resources/codex-cli/bin/codex
  [ -z "$CODEX" ] && [ -x /Applications/Codex.app/Contents/Resources/codex ] && CODEX=/Applications/Codex.app/Contents/Resources/codex
  WB_CLI=/Applications/WorkBuddy.app/Contents/Resources/app.asar.unpacked/cli/bin/codebuddy
  [ -f "$WB_CLI" ] || WB_CLI=""
  if [ -n "$CLAUDE" ]; then echo "✓ Claude Code：$CLAUDE"; else echo "· 没装 Claude Code（可选）"; fi
  if [ -n "$CODEX" ]; then echo "✓ Codex：$CODEX"; else echo "· 没装 Codex（可选）"; fi
  if [ -n "$WB_CLI" ]; then echo "✓ WorkBuddy：已安装"; else echo "· 没装 WorkBuddy（可选）"; fi
  [ -n "$CLAUDE$CODEX$WB_CLI" ] || die "Claude Code、Codex、WorkBuddy 一个都没找到。至少装好一个（并能在终端里正常使用）后，再运行一次安装命令。"

  # 2. Node.js 18 以上；没有就借 WorkBuddy 自带的
  node_ok() { [ -n "$1" ] && [ -x "$1" ] && [ "$("$1" -p 'process.versions.node.split(".")[0]' 2>/dev/null || echo 0)" -ge 18 ] 2>/dev/null; }
  NODE="$(command -v node || true)"
  if ! node_ok "$NODE"; then
    NODE="$(ls -d "$HOME"/.workbuddy/binaries/node/versions/*/bin/node 2>/dev/null | sort -V | tail -1)"
    node_ok "$NODE" || die "没找到 Node.js 18 以上。请先安装 Node.js（https://nodejs.org 下载 LTS 版，或在终端运行 brew install node），再运行一次安装命令。"
  fi
  echo "✓ Node.js：${NODE}（$("$NODE" -v)）"

  # 3. 下载并解压服务程序
  TMP="$(mktemp -d)" || die "无法创建临时目录。"
  trap 'rm -rf "$TMP"' EXIT
  echo "· 下载本机服务…"
  curl -fsSL "$SITE/app.tar.gz" -o "$TMP/app.tar.gz" || die "下载失败：$SITE/app.tar.gz（检查网络，或稍后再试）。"
  mkdir -p "$TMP/app" && tar -xzf "$TMP/app.tar.gz" -C "$TMP/app" || die "安装包解压失败，请重新运行安装命令。"
  [ -f "$TMP/app/bridge/server.mjs" ] || die "安装包内容不完整，请重新运行安装命令。"
  mkdir -p "$DEST/bridge" || die "无法创建安装目录：$DEST"
  # 改过规则文件的话留一份备份
  if [ -f "$DEST/rules.md" ] && ! cmp -s "$DEST/rules.md" "$TMP/app/rules.md"; then cp "$DEST/rules.md" "$DEST/rules.md.bak"; echo "· 你改过的规则已备份为 rules.md.bak"; fi
  cp "$TMP/app/bridge/server.mjs" "$DEST/bridge/server.mjs" && cp "$TMP/app/rules.md" "$DEST/rules.md" || die "复制文件失败：$DEST"

  # 4. 本机令牌（重装保留原令牌）+ 登记商店版插件 ID
  TOKEN=""
  [ -s "$DEST/bridge/token" ] && TOKEN="$(cat "$DEST/bridge/token")"
  [ -n "$TOKEN" ] || TOKEN="$(openssl rand -hex 24)"
  ( umask 077; printf '%s\n' "$TOKEN" > "$DEST/bridge/token" )
  case "$EXT_ID" in __*) echo "! 提示：插件 ID 还是占位符（${EXT_ID}），商店版插件会连不上，请联系发布方。";; esac
  printf '%s\n' "$EXT_ID" > "$DEST/bridge/allowed_ids"

  # 5. 注册登录后自动运行的后台服务
  mkdir -p "$HOME/Library/LaunchAgents" "$HOME/Library/Logs"
  cat > "$PLIST" <<PL
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key><string>$LABEL</string>
	<key>ProgramArguments</key>
	<array>
		<string>$NODE</string>
		<string>$DEST/bridge/server.mjs</string>
	</array>
	<key>EnvironmentVariables</key>
	<dict>
		<key>HOME</key><string>$HOME</string>
		<key>GZD_PORT</key><string>$PORT</string>
		<key>GZD_CLAUDE</key><string>${CLAUDE:-$HOME/.local/bin/claude}</string>
		<key>GZD_CODEX</key><string>$CODEX</string>
		<key>PATH</key><string>$HOME/.local/bin:$(dirname "$NODE"):/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
	</dict>
	<key>RunAtLoad</key><true/>
	<key>KeepAlive</key><true/>
	<key>StandardOutPath</key><string>$LOG</string>
	<key>StandardErrorPath</key><string>$LOG</string>
</dict>
</plist>
PL
  plutil -lint "$PLIST" >/dev/null || die "后台服务配置文件生成失败：$PLIST"

  launchctl bootout "gui/$(id -u)/$LABEL" 2>/dev/null || true
  # 只清理占用本服务端口（${PORT}）的旧进程，别的端口一概不碰
  PIDS="$(lsof -ti "tcp:$PORT" -sTCP:LISTEN 2>/dev/null || true)"
  [ -n "$PIDS" ] && kill $PIDS 2>/dev/null || true
  BOOTED=""
  for _ in 1 2 3 4 5; do
    if launchctl bootstrap "gui/$(id -u)" "$PLIST" 2>/dev/null; then BOOTED=1; break; fi
    sleep 1
  done
  [ -n "$BOOTED" ] || die "后台服务注册失败（launchctl bootstrap）。重启电脑后再运行一次安装命令试试。"

  # 6. 自检：服务起来了，且认得商店版插件
  echo "· 启动中…"
  for _ in $(seq 1 30); do
    if curl -sf -X POST -H "X-Gzd-Token: $TOKEN" "http://127.0.0.1:$PORT/health" >/dev/null 2>&1; then
      curl -sf -X POST -H "Origin: chrome-extension://$EXT_ID" "http://127.0.0.1:$PORT/health" >/dev/null 2>&1 \
        || die "服务已运行，但没认出插件 ID。请重新运行一次安装命令。"
      echo
      echo "✓ 装好了，回到 Edge 侧边栏即可使用"
      echo "  （本机服务：127.0.0.1:$PORT · 日志：${LOG}）"
      [ -n "$CODEX$WB_CLI" ] && echo "  Codex / WorkBuddy 第一次使用时如果没登录，插件会自动带你登录"
      return 0
    fi
    sleep 0.5
  done
  echo "最近的日志："; tail -20 "$LOG" 2>/dev/null
  die "本机服务没有启动成功（端口 ${PORT}）。如果端口被别的程序占用，先关掉它再运行一次安装命令。"
}

main "$@"

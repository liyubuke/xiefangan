#!/bin/bash
# 「写方案」本机服务卸载：curl -fsSL https://liyubuke.github.io/xiefangan/uninstall.sh | bash
# 停止并删除后台服务、安装目录、日志和本机临时文件。插件本身请到 edge://extensions/ 移除。
# 测试用环境变量：XFA_LABEL（launchd 标签）、XFA_DEST（安装目录）。

main() {
  DEST="${XFA_DEST:-$HOME/Library/Application Support/XieFangAn}"
  LABEL="${XFA_LABEL:-com.xiefangan.bridge}"
  PLIST="$HOME/Library/LaunchAgents/$LABEL.plist"
  if [ "$LABEL" = com.xiefangan.bridge ]; then LOG="$HOME/Library/Logs/xiefangan-bridge.log"; else LOG="$HOME/Library/Logs/$LABEL.log"; fi

  echo "== 写方案 · 卸载本机服务 =="
  launchctl bootout "gui/$(id -u)/$LABEL" 2>/dev/null && echo "✓ 已停止后台服务 $LABEL" || echo "· 后台服务没在运行"
  rm -f "$PLIST" && echo "✓ 已删除 $PLIST"
  # 「让它更懂你」的每日提炼定时任务（没开过就没有这一项）
  DIGEST="${XFA_DIGEST_LABEL:-com.xiefangan.digest}"
  launchctl bootout "gui/$(id -u)/$DIGEST" 2>/dev/null && echo "✓ 已停止每日提炼任务 $DIGEST" || echo "· 没有每日提炼任务"
  rm -f "$HOME/Library/LaunchAgents/$DIGEST.plist"
  # 安装目录只删本服务自己的目录，防止环境变量写错误删别的
  case "$DEST" in
    */XieFangAn|*/XieFangAn/|*xiefangan*) rm -rf "$DEST" && echo "✓ 已删除 $DEST" ;;
    *) echo "! 安装目录不像写方案的目录，未删除：$DEST" ;;
  esac
  rm -f "$LOG" && echo "✓ 已删除日志 $LOG"
  rm -rf /tmp/xiefangan /private/tmp/xiefangan /tmp/xfa-login && echo "✓ 已删除临时文件 /tmp/xiefangan"
  echo
  echo "✓ 本机服务已卸载。最后到 Edge 地址栏打开 edge://extensions/ 移除「写方案」插件即可。"
}

main "$@"

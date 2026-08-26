import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "local.memory-usage"

  property int usedMemory: 0
  property int totalMemory: 0
  readonly property int usagePercent: totalMemory > 0 ? Math.round(100 * usedMemory / totalMemory) : 0

  function formatGiB(kib) {
    return (kib / 1048576).toFixed(1) + "G"
  }

  function updateUsage(raw) {
    var lines = String(raw).trim().split(/\n/)
    if (lines.length < 2) return

    var totalMatch = lines[0].match(/^MemTotal:\s+(\d+)/)
    var availableMatch = lines[1].match(/^MemAvailable:\s+(\d+)/)
    if (!totalMatch || !availableMatch) return

    totalMemory = Number(totalMatch[1])
    usedMemory = Math.max(0, totalMemory - Number(availableMatch[1]))
  }

  function refresh() {
    if (!usageProc.running) usageProc.running = true
  }

  function copyUsage() {
    var value = "Memory usage: " + root.formatGiB(root.usedMemory) + " / " + root.formatGiB(root.totalMemory) + " (" + root.usagePercent + "%)"
    Quickshell.execDetached(["bash", "-c", "printf %s " + Util.shellQuote(value) + " | wl-copy"])
  }

  function handlePress(button) {
    if (button === Qt.LeftButton) {
      if (root.bar)
        root.bar.run("omarchy-launch-floating-terminal-with-presentation " + root.bar.shellQuote("ps -eo pid,user,%cpu,%mem,comm --sort=-%mem | head -21; read -r -p 'Press Enter to close...'"))
    } else if (button === Qt.RightButton) {
      if (root.bar) root.bar.run("omarchy-launch-or-focus-tui btop")
    } else if (button === Qt.MiddleButton) {
      root.copyUsage()
    }
  }

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  Process {
    id: usageProc
    command: ["bash", "-c", "grep -E '^(MemTotal|MemAvailable):' /proc/meminfo"]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.updateUsage(text)
    }
  }

  Timer {
    interval: 3000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: root.refresh()
  }

  WidgetButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: root.totalMemory > 0
      ? "󰘚 " + root.formatGiB(root.usedMemory) + "/" + root.formatGiB(root.totalMemory)
      : "󰘚 —/—"
    fontSize: Style.font.caption
    horizontalMargin: 5
    verticalPadding: 5
    tooltipText: "Left: top memory processes · Right: btop · Middle: copy"
    onPressed: function(b) { root.handlePress(b) }
  }
}

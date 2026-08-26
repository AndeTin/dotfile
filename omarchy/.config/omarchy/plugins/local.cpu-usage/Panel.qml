import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "local.cpu-usage"

  property int usage: 0
  property var previous: null

  function updateUsage(raw) {
    var values = String(raw).trim().split(/\s+/)
    if (values.length < 6 || values[0] !== "cpu") return

    var idle = Number(values[4])
    var total = 0
    for (var i = 1; i < values.length; i++) total += Number(values[i])
    var busy = total - idle - Number(values[5])

    if (previous !== null) {
      var totalDelta = total - previous.total
      var busyDelta = busy - previous.busy
      if (totalDelta > 0)
        usage = Math.max(0, Math.min(100, Math.round(100 * busyDelta / totalDelta)))
    }
    previous = { total: total, busy: busy }
  }

  function refresh() {
    if (!usageProc.running) usageProc.running = true
  }

  function copyUsage() {
    var value = "CPU usage: " + root.usage + "%"
    Quickshell.execDetached(["bash", "-c", "printf %s " + Util.shellQuote(value) + " | wl-copy"])
  }

  function handlePress(button) {
    if (button === Qt.LeftButton) {
      if (root.bar)
        root.bar.run("omarchy-launch-floating-terminal-with-presentation " + root.bar.shellQuote("ps -eo pid,user,%cpu,%mem,comm --sort=-%cpu | head -21; read -r -p 'Press Enter to close...'"))
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
    command: ["bash", "-c", "cat /proc/stat | head -1"]
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
    text: "󰍛 " + root.usage + "%"
    fontSize: Style.font.caption
    horizontalMargin: 5
    verticalPadding: 5
    tooltipText: "Left: top CPU processes · Right: btop · Middle: copy"
    onPressed: function(b) { root.handlePress(b) }
  }
}

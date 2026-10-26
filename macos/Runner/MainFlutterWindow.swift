import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()

    // Set default desktop window size (1280x800 for proper desktop UI)
    let defaultWidth: CGFloat = 1280
    let defaultHeight: CGFloat = 800
    let screenFrame = NSScreen.main?.visibleFrame ?? NSRect(x: 0, y: 0, width: defaultWidth, height: defaultHeight)
    let centerX = screenFrame.origin.x + (screenFrame.width - defaultWidth) / 2
    let centerY = screenFrame.origin.y + (screenFrame.height - defaultHeight) / 2
    let windowFrame = NSRect(x: centerX, y: centerY, width: defaultWidth, height: defaultHeight)

    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    // Set minimum window size to ensure desktop layout works properly
    self.minSize = NSSize(width: 1024, height: 700)

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}

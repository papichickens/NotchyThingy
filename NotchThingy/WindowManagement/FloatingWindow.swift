// NotchyThingy/WindowManagement/FloatingWindow.swift
import AppKit
import SwiftUI // For NSSize, CGPoint, NSRect

class FloatingWindow: NSWindow {
    // Default initial size, suitable for a menu or a compact view.
    // Can be changed dynamically by the AppDelegate.
    static let defaultMenuWidth: CGFloat = 260
    static let defaultMenuHeight: CGFloat = 220 // Adjust based on MainMenuView's content

    init(initialSize: NSSize = NSSize(width: defaultMenuWidth, height: defaultMenuHeight)) {
        guard let screen = NSScreen.main else {
            super.init(contentRect: .zero, styleMask: [.borderless], backing: .buffered, defer: false)
            print("Error: Could not get main screen.")
            return
        }
        let screenFrame = screen.frame

        let windowWidth = initialSize.width
        let windowHeight = initialSize.height
        let windowSize = NSSize(width: windowWidth, height: windowHeight)

        let yOffset: CGFloat = 20 // Pixels from the top of the screen, slightly lower for a menu
        let windowOrigin = CGPoint(x: (screenFrame.width - windowSize.width) / 2,
                                   y: screenFrame.height - windowSize.height - yOffset)

        super.init(contentRect: NSRect(origin: windowOrigin, size: windowSize),
                   styleMask: [.borderless], // No title bar, no standard window chrome
                   backing: .buffered,       // Use a buffer for drawing
                   defer: false)             // Create the window device immediately

        self.isOpaque = false                        // Allows transparency
        self.backgroundColor = .clear                // Make the window background transparent
        self.hasShadow = true                        // Give it a system shadow
        self.level = .statusBar                       // Keep it above most other windows
        //self.level = .floating                       // Keep it above most other windows
        //self.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary] // Behaves well with Spaces/Fullscreen
        self.collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle, .fullScreenAuxiliary]
        self.ignoresMouseEvents = false              // Menu needs mouse events

        self.isMovableByWindowBackground = true
        //self.isMovableByWindowBackground = false
    }

    // Call this to re-center the window under the notch using its *current* size
    // Useful after resizing the window.
    func positionNearNotch(yOffset: CGFloat = 0) { // Default yOffset to 0 for the actual notch thingy
        guard let screen = NSScreen.main else { return }
        let screenFrame = screen.frame
        let windowSize = self.frame.size // Current size of the window

        let newOrigin = CGPoint(x: (screenFrame.width - windowSize.width) / 2,
                                y: screenFrame.height - windowSize.height - yOffset)
        self.setFrameOrigin(newOrigin)
    }
    
    func setFrame(_ frameRect: NSRect, display flag: Bool, animate: Bool, andPositionNearNotchYOffset yOffset: CGFloat?) {
        super.setFrame(frameRect, display: flag, animate: animate)
        if let yOffset = yOffset {
            self.positionNearNotch(yOffset: yOffset)
        } else {
            // If no yOffset, just center it (or use existing position if not changing size)
            // self.center() // Could be an option too
        }
    }
}

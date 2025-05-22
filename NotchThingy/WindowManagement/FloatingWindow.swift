// NotchyThingy/WindowManagement/FloatingWindow.swift
import AppKit
import SwiftUI // For NSSize, CGPoint, NSRect

class FloatingWindow: NSWindow {
    init() {
        // Determine screen dimensions
        guard let screen = NSScreen.main else {
            super.init(contentRect: .zero, styleMask: [.borderless], backing: .buffered, defer: false)
            print("Error: Could not get main screen.")
            return
        }
        let screenFrame = screen.frame

        // Define the size of the floating window
        let windowWidth: CGFloat = 250
        let windowHeight: CGFloat = 80
        let windowSize = NSSize(width: windowWidth, height: windowHeight)

        // Position it centered horizontally near the top (under the notch)
        // Adjust `yOffset` to position it perfectly under your notch or menu bar.
        let yOffset: CGFloat = 0 // Pixels from the top of the screen
        let windowOrigin = CGPoint(x: (screenFrame.width - windowSize.width) / 2,
                                   y: screenFrame.height - windowSize.height - yOffset)

        super.init(contentRect: NSRect(origin: windowOrigin, size: windowSize),
                   styleMask: [.borderless], // No title bar, no standard window chrome
                   backing: .buffered,       // Use a buffer for drawing
                   defer: false)             // Create the window device immediately

        self.isOpaque = false                        // Allows transparency
        self.backgroundColor = .clear                // Make the window background transparent
        self.hasShadow = true                        // Give it a system shadow (optional)
        self.level = .floating                       // Keep it above most other windows
        self.ignoresMouseEvents = true               // Make it click-through for now (can change)
        self.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary] // Behaves well with Spaces/Fullscreen
        self.ignoresMouseEvents = false

        // Optional: If you want to drag it by its background (if not ignoring mouse events)
        self.isMovableByWindowBackground = true
    }

    // If you want the window to be able to receive keyboard/mouse events
    // (and set ignoresMouseEvents = false above)
    // override var canBecomeKey: Bool {
    //     return true
    // }
    //
    // override var canBecomeMain: Bool {
    //     return true
    // }
}

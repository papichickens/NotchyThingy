//
//  AppDelegate.swift
//  NotchThingy
//
//  Created by Nuno Alves on 22/05/2025.
//

import SwiftUI
import AppKit // For NSApplicationDelegate, NSWindow, NSHostingView

class AppDelegate: NSObject, NSApplicationDelegate {
    private var floatingWindow: FloatingWindow? // Keep a reference

    func applicationDidFinishLaunching(_ notification: Notification) {
        // 1. Create an instance of our custom FloatingWindow
        floatingWindow = FloatingWindow()

        // 2. Create the SwiftUI view that will be the content
        let contentView = NotchContentView() // Your simple SwiftUI view

        // 3. Host the SwiftUI view within an NSHostingView
        let hostingView = NSHostingView(rootView: contentView)
        floatingWindow?.contentView = hostingView // Set it as the window's content

        // 4. Make the window visible
        floatingWindow?.makeKeyAndOrderFront(nil) // Brings it to the front and makes it key
        floatingWindow?.orderFrontRegardless()    // Ensures it's visible even if app isn't active

        // Optional: Hide the Dock icon if you want it to be a utility-style app
        // Add <key>LSUIElement</key><true/> to Info.plist for this.
        // Or: NSApp.setActivationPolicy(.accessory) // Call this before window is shown
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        // If the Dock icon is clicked (and visible) and window was closed, show it again.
        if !flag {
            floatingWindow?.makeKeyAndOrderFront(nil)
        }
        return true
    }
}

//
//  AppDelegate.swift
//  NotchThingy
//
//  Created by Nuno Alves on 22/05/2025.
//

import SwiftUI
import AppKit // For NSApplicationDelegate, NSWindow, NSHostingView

class AppDelegate: NSObject, NSApplicationDelegate {
    private var floatingWindow: FloatingWindow?

    // Define target sizes for different views
    // Define target sizes for different views
    private let initialHookSize = NSSize(width: InitialHookView.expandedHookWidth, height: InitialHookView.expandedHookHeight)
    private let menuSize = NSSize(width: FloatingWindow.defaultMenuWidth, height: FloatingWindow.defaultMenuHeight)
    private let remindersSize = NSSize(width: 300, height: 120) // Adjusted for Reminders list
    private let mirrorSize = NSSize(width: 300, height: 120)    // Example for Mirror view
    

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create window with menu size initially
        floatingWindow = FloatingWindow(initialSize: menuSize)
        
        showInitialHook()

        floatingWindow?.makeKeyAndOrderFront(nil)
        floatingWindow?.orderFrontRegardless()
    }

    private func setWindowContent<V: View>(to view: V, newSize: NSSize, yOffsetForPositioning: CGFloat? = 20) {
        guard let window = floatingWindow else { return }
        
        let rootView = view

        let hostingView = NSHostingView(rootView: rootView)
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        //hostingView.frame.size = newSize
      
        //window.contentView = hostingView
        window.contentView = NSView()  // Create an empty container view first
        window.contentView?.addSubview(hostingView)

        // Setup Auto Layout for hostingView inside contentView
        NSLayoutConstraint.activate([
            hostingView.centerXAnchor.constraint(equalTo: window.contentView!.centerXAnchor),
            hostingView.centerYAnchor.constraint(equalTo: window.contentView!.centerYAnchor),
            hostingView.widthAnchor.constraint(equalToConstant: newSize.width),
            hostingView.heightAnchor.constraint(equalToConstant: newSize.height)
        ])
      
        let currentOrigin = window.frame.origin // Keep current origin X as a base for centering
        let newFrame = NSRect(origin: CGPoint(x: currentOrigin.x, y: window.frame.origin.y - (newSize.height - window.frame.height)),
                             size: newSize)
      
        window.setFrame(newFrame, display: true, animate: true, andPositionNearNotchYOffset: yOffsetForPositioning)
    }
    
    private func showInitialHook() {
        let hookView = InitialHookView { [weak self] in
            self?.showMainMenuView()
        }
        // Initial hook is tight to the notch
        setWindowContent(to: hookView, newSize: initialHookSize, yOffsetForPositioning: -3)
    }

    private func showMainMenuView() {
        let menuView = MainMenuView { [weak self] selection in
            self?.handleMenuSelection(selection)
        }
        // Menu typically a bit lower than the notch
        setWindowContent(to: menuView, newSize: menuSize, yOffsetForPositioning: 20)
    }

    private func handleMenuSelection(_ selection: MenuSelection) {
        switch selection {
        case .reminders:
            showRemindersView()
        case .mirror:
            showMirrorView()
        }
    }

    private func showRemindersView() {
        let remindersContentView = ReminderView()
        setWindowContent(to: remindersContentView, newSize: remindersSize, yOffsetForPositioning: 20)
    }

    private func showMirrorView() {
        let mirrorContentView = MirrorView { [weak self] in
            self?.showMainMenuView() // Action for the "Back to Menu" button
        }
        // Mirror view might be larger and also offset from notch
        setWindowContent(to: mirrorContentView, newSize: mirrorSize, yOffsetForPositioning: 20)
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag {
            floatingWindow?.makeKeyAndOrderFront(nil) // Or decide to always showMainMenuView()
        }
        return true
    }
}

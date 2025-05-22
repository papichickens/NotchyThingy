//
//  FloatingWindow.swift
//  NotchThingy
//
//  Created by Nuno Alves on 25/04/2025.
//

import SwiftUI

class FloatingWindow: NSWindow {
    init() {
        let screenFrame = NSScreen.main?.frame ?? NSRect.zero
        
        // Define the size of the floating window
        let windowSize = NSSize(width: 300, height: 80)
        
        // Position it centered horizontally near the top (under the notch)
        let windowOrigin = CGPoint(x: (screenFrame.width - windowSize.width) / 2,
                                   y: screenFrame.height - windowSize.height - 20)

        super.init(contentRect: NSRect(origin: windowOrigin, size: windowSize),
                   styleMask: [.borderless],
                   backing: .buffered,
                   defer: false)
        
        self.isOpaque = false
        self.backgroundColor = .clear
        self.hasShadow = true
        self.level = .floating
        self.ignoresMouseEvents = false
    }
}

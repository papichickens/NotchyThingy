//
//  ContentView.swift
//  NotchThingy
//
//  Created by Nuno Alves on 25/04/2025.
//

import SwiftUI

struct NotchFunApp: App {
    // Hold the window here
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            EmptyView() // We don't need a regular window
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var floatingWindow: FloatingWindow?

    func applicationDidFinishLaunching(_ notification: Notification) {
        floatingWindow = FloatingWindow()
        
        // Add a SwiftUI view inside
        floatingWindow?.contentView = NSHostingView(rootView: FloatingContentView())
        floatingWindow?.makeKeyAndOrderFront(nil)
    }
}

struct FloatingContentView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.black.opacity(0.7)) // Semi-transparent background
            Text("Hello, Notch!")
                .foregroundColor(.white)
                .font(.headline)
        }
        .frame(width: 300, height: 80)
    }
}

//
//  NotchThingyApp.swift
//  NotchThingy
//
//  Created by Nuno Alves on 25/04/2025.
//

import SwiftUI

@main
struct NotchyThingyApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        // This ensures no standard window is created by SwiftUI automatically.
        // We will manage our FloatingWindow manually.
        Settings { // Or WindowGroup if you might add a settings window later
            EmptyView()
        }
    }
}

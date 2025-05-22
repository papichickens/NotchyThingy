//
//  NotchThingyApp.swift
//  NotchThingy
//
//  Created by Nuno Alves on 25/04/2025.
//

import SwiftUI
import EventKit

@main
struct NotchThingyApp: App {
    // Hold the window here
    @NSApplicationDelegateAdaptor(NotchAppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            EmptyView() // We don't need a regular window
        }
    }
}

class NotchAppDelegate: NSObject, NSApplicationDelegate {
    var floatingWindow: FloatingWindow?

    func applicationDidFinishLaunching(_ notification: Notification) {
        floatingWindow = FloatingWindow()
        
        // Add a SwiftUI view inside
        floatingWindow?.contentView = NSHostingView(rootView: NotchFloatingContentView())
        floatingWindow?.makeKeyAndOrderFront(nil)
    }
}

struct NotchFloatingContentView: View {
    @State private var isHovering = false
    @State private var wasClicked = false
    
    @StateObject private var reminderManager = ReminderManager()

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(isHovering ? Color.black.opacity(0.9) : Color.black.opacity(wasClicked ? 0.5 : 0.7))
                .animation(.easeInOut(duration: 0.3), value: isHovering)
                .animation(.easeInOut(duration: 0.3), value: wasClicked)

            VStack(spacing: 8) {
                if reminderManager.authorizationStatus == .fullAccess || reminderManager.authorizationStatus == .writeOnly {
                    if reminderManager.reminders.isEmpty {
                        Text("No Reminders 🎯")
                    } else {
                        Text("Next: \(reminderManager.reminders.first?.title ?? "Unknown")")
                    }
                } else if reminderManager.authorizationStatus == .denied {
                    Text("No Permission 🛑")
                } else {
                    Text("Loading...")
                }
            }
            .foregroundColor(.white)
            .font(.headline)
            .padding()
        }
        .frame(width: 300, height: 80)
        .onHover { hovering in
            self.isHovering = hovering
        }
        .onTapGesture {
            wasClicked.toggle()
        }
    }
}

class ReminderManager: ObservableObject {
    private var eventStore = EKEventStore()
    
    @Published var reminders: [EKReminder] = []
    @Published var authorizationStatus: EKAuthorizationStatus = .notDetermined
    
    init() {
        requestAccess()
    }
    
    func requestAccess() {
        eventStore.requestAccess(to: .reminder) { (granted, error) in
            DispatchQueue.main.async {
                self.authorizationStatus = EKEventStore.authorizationStatus(for: .reminder)
                if granted {
                    self.fetchReminders()
                } else {
                    print("Access to reminders denied")
                }
            }
        }
    }
    
    func fetchReminders() {
        let predicate = eventStore.predicateForIncompleteReminders(withDueDateStarting: nil, ending: nil, calendars: nil)
        eventStore.fetchReminders(matching: predicate) { (reminders) in
            DispatchQueue.main.async {
                self.reminders = reminders ?? []
            }
        }
    }
}

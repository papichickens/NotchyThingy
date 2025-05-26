//
//  MainMenuView.swift
//  NotchThingy
//
//  Created by Nuno Alves on 25/05/2025.
//

import SwiftUI

// --- Helper Subview for Menu Buttons ---
struct MenuButtonView: View {
    let iconName: String
    let title: String
    let action: () -> Void
    @Binding var isHovering: Bool // Use Binding to reflect hover state changes back to parent

    // Constants can be internal to this subview
    private let buttonCornerRadius: CGFloat = 10
    private let buttonHeight: CGFloat = 55
    private let iconSize: Font = .title2

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: iconName)
                    .font(iconSize)
                    .frame(width: 30) // Align icons
                Text(title)
                    .fontWeight(.medium)
                Spacer() // Push content to left
            }
            .foregroundColor(.white)
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .frame(height: buttonHeight)
            .background(isHovering ? Color.white.opacity(0.25) : Color.white.opacity(0.1))
            .cornerRadius(buttonCornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: buttonCornerRadius)
                    .stroke(isHovering ? Color.white.opacity(0.5) : Color.white.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.1)) {
                self.isHovering = hovering // Update the binding
            }
        }
        .scaleEffect(isHovering ? 1.02 : 1.0)
        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isHovering)
    }
}

// --- MainMenuView using the helper ---
struct MainMenuView: View {
    // Callback to inform the AppDelegate (or a coordinator) of the selection
    var onSelect: (MenuSelection) -> Void

    // States for hover effects, now used with the MenuButtonView's @Binding
    @State private var isHoveringReminders = false
    @State private var isHoveringMirror = false

    var body: some View {
        VStack(spacing: 12) {
            Text("Select Mode")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .padding(.bottom, 8)

            // Reminders Button - Using the subview
            MenuButtonView(
                iconName: "list.bullet.rectangle.portrait.fill",
                title: "Reminders",
                action: { onSelect(.reminders) },
                isHovering: $isHoveringReminders // Pass the @State as a @Binding
            )

            // Mirror Button - Using the subview
            MenuButtonView(
                iconName: "macwindow.on.rectangle.rtl", // Or "camera.metering.center.weighted.average" / "videoprojector.fill"
                title: "Mirror",
                action: { onSelect(.mirror) },
                isHovering: $isHoveringMirror // Pass the @State as a @Binding
            )
        }
        .padding(20) // Generous padding for the menu content
        .background(
            RoundedRectangle(cornerRadius: 16) // Slightly larger corner radius for the menu background
                .fill(Color.black.opacity(0.80))
        )
        // This view will try to fit its content. The FloatingWindow size should accommodate it.
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView(onSelect: { selection in
            print("Preview Selected: \(selection)")
        })
        .frame(width: 280, height: 250) // Approximate size for previewing
        .background(Color.purple.opacity(0.3))
    }
}

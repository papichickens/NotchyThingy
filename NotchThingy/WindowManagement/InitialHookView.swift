//
//  InitialHookView.swift
//  NotchThingy
//
//  Created by Nuno Alves on 26/05/2025.
//


//
//  InitialHookView.swift
//  NotchThingy
//
//  Created by Nuno Alves on [Your Current Date]
//

import SwiftUI

struct InitialHookView: View {
    var onTap: () -> Void // Action to perform when tapped (e.g., show MainMenu)
    @State private var isHovering: Bool = false
    
    private var backgroundOpacity: Double { isHovering ? 1.0 : 0.5 }
    private var scale: CGFloat { isHovering ? 1.1 : 1.0 } // Bulge to 110%

    // Define a very compact size for this initial hook
    static let hookWidth: CGFloat = 240
    static let hookHeight: CGFloat = 50 // Adjusted for a compact look

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Self.hookHeight / 2)
            .fill(Color.black.opacity(backgroundOpacity))
        }
        .frame(width: Self.hookWidth, height: Self.hookHeight)
        .scaleEffect(scale)
        .contentShape(Rectangle()) // Make the ZStack tappable
        .onTapGesture {
            onTap()
        }
        .onHover { hovering in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) { // Smooth animation for scale and opacity
                self.isHovering = hovering
            }
        }
    }
}

struct InitialHookView_Previews: PreviewProvider {
    static var previews: some View {
        InitialHookView(onTap: {
            print("Initial Hook Tapped")
        })
        .padding(20)
        .background(Color.blue.opacity(0.3))
    }
}

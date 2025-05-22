//
//  NotchContentView.swift
//  NotchThingy
//
//  Created by Nuno Alves on 22/05/2025.
//


// NotchyThingy/WindowManagement/NotchContentView.swift
import SwiftUI

struct NotchContentView: View {
    @State private var isHovering: Bool = false

    // Define opacities
    private let defaultOpacity: Double = 0.5
    private let hoverOpacity: Double = 1.0
    
    var body: some View {
        ZStack {
            // Background shape
            RoundedRectangle(cornerRadius: 12)
                // Dynamically set opacity based on hover state
                .fill(Color.black.opacity(isHovering ? hoverOpacity : defaultOpacity))
                .animation(.easeInOut(duration: 0.15), value: isHovering) // Smooth transition

            // Text content
            Text("My Notch Thingy!")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .padding(.horizontal)
        }
        // Add the .onHover modifier to the ZStack (or any encompassing view)
        .onHover { hovering in
            self.isHovering = hovering
        }
        // Important for consistent hit-testing with transparent areas:
        // Make sure the content shape fills the area you want to be hoverable.
        // If the ZStack itself isn't filling the window, you might need to add
        // .contentShape(Rectangle()) to the ZStack or its background.
        // In this case, RoundedRectangle should be sufficient.
    }
}

struct NotchContentView_Previews: PreviewProvider {
    static var previews: some View {
        NotchContentView()
            .frame(width: 250, height: 80)
            .background(Color.blue) // Preview background
    }
}

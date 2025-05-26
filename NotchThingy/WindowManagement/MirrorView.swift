//
//  MirrorView.swift
//  NotchThingy
//
//  Created by Nuno Alves on 25/05/2025.
//


import SwiftUI

struct MirrorView: View {
    var onBack: () -> Void // Action to go back to the main menu

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "camera.fill")
                .font(.system(size: 50))
                .foregroundColor(.white.opacity(0.8))
            
            Text("Mirror Mode")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            Text("Your camera feed will appear here.")
                .font(.caption)
                .foregroundColor(.gray)
            
            Button(action: onBack) {
                HStack {
                    Image(systemName: "arrow.left.circle.fill")
                    Text("Back to Menu")
                }
                .foregroundColor(.white.opacity(0.9))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.white.opacity(0.15))
                .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.top, 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.80))
        )
    }
}

struct MirrorView_Previews: PreviewProvider {
    static var previews: some View {
        MirrorView(onBack: {
            print("Preview: Back to menu")
        })
        .frame(width: 300, height: 250)
        .background(Color.orange.opacity(0.3))
    }
}
// NotchyThingy/WindowManagement/NotchContentView.swift
import SwiftUI

struct ListItem: Identifiable, Hashable {
    let id = UUID()
    var text: String
}

struct ReminderView: View {
    @State private var isHovering: Bool = false
    //var onBack: () -> Void

    private let defaultOpacity: Double = 0.5
    private let hoverOpacity: Double = 1.0

    @State private var listItems: [ListItem] = []
    @State private var editingItemID: UUID? = nil // ID of the item currently being edited
    @State private var currentEditBuffer: String = "" // Text buffer for the TextField
    
    private func commitEdit() {
           guard let idToEdit = editingItemID else { return }
           if let index = listItems.firstIndex(where: { $0.id == idToEdit }) {
               listItems[index].text = currentEditBuffer
           }
           editingItemID = nil
           currentEditBuffer = ""
           // isTextFieldFocused = false // If using @FocusState
           
           // On macOS, explicitly resign first responder
           DispatchQueue.main.async {
                NSApp.keyWindow?.makeFirstResponder(nil)
           }
       }

       private func addNewItem() {
           let newItem = ListItem(text: "") // Start with empty text
           listItems.append(newItem)
           editingItemID = newItem.id
           currentEditBuffer = "" // Ensure buffer is empty for new item
           // isTextFieldFocused = true // If using @FocusState
       }

       private func startEditing(item: ListItem) {
           editingItemID = item.id
           currentEditBuffer = item.text
           // isTextFieldFocused = true // If using @FocusState
       }

    var body: some View {
        
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(isHovering || editingItemID != nil ? hoverOpacity : defaultOpacity))
                    .animation(.easeInOut(duration: 0.15), value: isHovering || editingItemID != nil)

                HStack(spacing: 12) { // Increased spacing a bit
                    // Main Text Section
                    Text("Reminders")
                    .font(.system(size: 20, weight: .semibold)) // Adjusted font size for vertical fit
                    .foregroundColor(.white)
                    .fixedSize() // Let the Text calculate its ideal size *before* rotation
                    .rotationEffect(.degrees(-90)) // Rotate the text
                    .padding(.leading, -40)
                    // --- Right Section: Editable List ---
                    VStack(alignment: .leading, spacing: 4) {
                        // Using ScrollView if list can get long, otherwise ForEach directly
                        // For a notch, a few items are typical. Let's assume it fits.
                        // If it needs to scroll, wrap ForEach in a ScrollView.
                        // For simplicity for now, no ScrollView. Add if needed.
                        ForEach($listItems) { $item in // Use $item for direct binding if ListItem members were @State
                                                    // Or handle edits via editingItemID as implemented
                            if editingItemID == item.id {
                                TextField("Edit item...", text: $currentEditBuffer, onCommit: commitEdit)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .font(.system(size: 12))
                                    .foregroundColor(.white)
                                    .padding(.vertical, 3)
                                    .padding(.horizontal, 5)
                                    .background(Color.white.opacity(0.2))
                                    .cornerRadius(4)
                                    // .focused($isTextFieldFocused) // For macOS 12+
                                    .onSubmit(commitEdit) // Handles "Enter" explicitly
                                    .id(item.id) // Important for TextField identity
                            } else {
                                Text(item.text.isEmpty ? "Tap to edit" : item.text)
                                    .font(.system(size: 12))
                                    .foregroundColor(item.text.isEmpty ? .gray : .white.opacity(0.9))
                                    .padding(.vertical, 3)
                                    .padding(.horizontal, 5)
                                    .lineLimit(1)
                                    .frame(maxWidth: .infinity, alignment: .leading) // Allow text to take width
                                    .background(Color.clear) // Ensure onTapGesture target is sized correctly
                                    .onTapGesture {
                                        startEditing(item: item)
                                    }
                            }
                        }
                        .animation(.default, value: listItems) // Animate changes to the list
                        .animation(.default, value: editingItemID)


                        // "Add Item" Button
                        Button(action: addNewItem) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 12))
                            }
                            .foregroundColor(.white.opacity(0.7))
                            .padding(.vertical, 2)
                        }
                        .buttonStyle(PlainButtonStyle()) // Remove default button chrome
                        .padding(.top, 2) // Space above add button
                    }
                    .frame(minWidth: 100, idealWidth: 150, maxWidth: 200) // Constrain width of the list area
                    .opacity((isHovering || editingItemID != nil) ? 1.0 : 0.7)
                    .animation(.easeInOut(duration: 0.2), value: isHovering || editingItemID != nil)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8) // Added some vertical padding to the main HStack
            }
            .onHover { hovering in
                if editingItemID == nil { // Don't change visual state if an item is being edited
                    self.isHovering = hovering
                }
            }
            .contentShape(Rectangle()) // Make the ZStack tappable for "tap outside to commit"
            .onTapGesture {
                // If a tap occurs on the ZStack background AND we are editing, commit.
                // The TextField or Text's onTapGesture will usually consume taps on themselves.
                if editingItemID != nil {
                    // Check if the tap was truly "outside". This can be tricky.
                    // A simple approach: if this gıesture fires while editing, commit.
                    // More robust might involve geometry checks or focus state.
                    commitEdit()
                }
            }
            // Adjust FloatingWindow size if needed, perhaps make it taller.
            // The FloatingWindow currently has a fixed height of 80.
            // This might need to be dynamic or increased. For now, let's assume
            // the items + add button will fit or the user wants a compact list.
        }
}

struct ReminderView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            ReminderView()
                .previewDisplayName("Default State")
        }
        .frame(width: 300, height: 150) // Adjusted preview frame to see both
        .background(Color.blue)
    }
}

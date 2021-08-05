//
//  ChatKeyboard.swift
//  ChatLibrary
//
//  Created by Igor Malyarov on 02.08.2021.
//

import SwiftUI

public extension View {
#warning("not sure about closure with string parameter - already have a binding")
    /// Attach a TextEditor with dismiss keyboard and send buttons to a view.
    /// - Parameters:
    ///   - text: Binding to string value.
    ///   - maxHeight: Maximum height of TexEditor.
    ///   - action: Closure to perform action on string value.
    ///
    ///         SomeView()
    ///             .chatKeyboard(text: $text) { _ in
    ///                 text = ""
    ///             }
    ///
    /// - Attention: Not sure about closure with string parameter - already have a binding.
    /// - Warning: how to make TextEditor maxHeight dynamic?
    func chatKeyboard(
        text: Binding<String>,
        // TODO: how to make TextEditor maxHeight dynamic?
        maxHeight: CGFloat = 280,
        action: @escaping () -> Void
    ) -> some View {
        Group {
            self
            ChatKeyboard(text: text, maxHeight: maxHeight, action: action)
        }
    }
}

fileprivate struct ChatKeyboard: View {
    @Binding var text: String
    let maxHeight: CGFloat
    let action: () -> Void
    
    init(
        text: Binding<String>,
        maxHeight: CGFloat,
        action: @escaping () -> Void
    ) {
        self._text = text
        self.maxHeight = maxHeight
        self.action = action
    }
    
    enum FocusField { case text }
    @FocusState private var focusField: FocusField?
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            Button(action: hideKeyboard) {
                Label("hide", systemImage: "keyboard.chevron.compact.down")
                    .labelStyle(.iconOnly)
                    .frame(width: 44, height: 32)
            }
            .offset(y: -5)
            .disabled(focusField == nil)
            
            HStack(alignment: .bottom, spacing: 0) {
                // TextField("New message", text: $text)
                TextEditor(text: $text)
                // min height of TextEditor is 38
                    .frame(
                        maxWidth: .infinity,
                        minHeight: 38,
                        // TODO: how to make TextEditor maxHeight dynamic?
                        maxHeight: maxHeight,
                        alignment: .leading
                    )
                    .fixedSize(horizontal: false, vertical: true)
                    .focused($focusField, equals: .text)
                
                Button {
                    withAnimation {
                        focusField = nil
                        action()
                    }
                } label: {
                    Label("Post message", systemImage: "arrow.up.circle.fill")
                        .labelStyle(.iconOnly)
                        .imageScale(.large)
                        .frame(width: 44, height: 32)
                }
                .disabled(text.isEmpty)
                .offset(y: -4)
            }
            .padding(.leading, 6)
            .padding(.vertical, 2)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(.tertiary)
            )
        }
        .padding(.trailing, 6)
        .padding(.bottom, 4)
        .layoutPriority(1)
        /// [SwiftUI default focus on TextField/TextEditor when view is loaded](https://developer.apple.com/forums/thread/681962)
        //    .onAppear {
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        //            focus = .text
        //        }
        //    }
    }
    
    private func hideKeyboard() {
        withAnimation {
            if focusField != nil {
                focusField = nil
            }
        }
    }
    
}

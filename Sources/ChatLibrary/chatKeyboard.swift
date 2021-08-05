//
//  ChatKeyboard.swift
//  ChatLibrary
//
//  Created by Igor Malyarov on 02.08.2021.
//

import SwiftUI

public extension View {
    /// Attach a TextEditor with dismiss keyboard and send buttons to a view.
    /// - Parameters:
    ///   - text: Binding to a string value.
    ///   - minHeight: Binding to text editor hight. Initial value is min height,
    ///     38 is recommended rot TextEditor.. Optional.
    ///   - maxHeight: Maximum height of TexEditor.
    ///   - delay: Delay in seconds during witch cancel action is available.
    ///   - sendAction: Closure to perform send action.
    ///   - cancelAction: Cancel action, available during delay.
    ///
    ///         SomeView()
    ///             .chatKeyboard(
    ///                 text: $text,
    ///                 delay: 5
    ///             ) {
    ///                 post()
    ///             } cancelAction: {
    ///                 cancelPost()
    ///             }
    ///
    /// - Warning: how to make TextEditor maxHeight dynamic?
    /// - Returns: Modified view with chat keyboard.
    func chatKeyboard(
        text: Binding<String>,
        minHeight: Binding<CGFloat>? = nil,
        // TODO: how to make TextEditor maxHeight dynamic?
        maxHeight: CGFloat = 280,
        delay: TimeInterval,
        sendAction: @escaping () -> Void,
        cancelAction: @escaping () -> Void
    ) -> some View {
        Group {
            self
            ChatKeyboard(
                text: text,
                // min height of TextEditor is 38
                minHeight: minHeight ?? .constant(38),
                maxHeight: maxHeight,
                delay: delay,
                sendAction: sendAction,
                cancelAction: cancelAction
            )
        }
    }
}

private struct ChatKeyboard: View {
    @Binding var text: String
    @Binding var minHeight: CGFloat
    let maxHeight: CGFloat
    let delay: TimeInterval
    let sendAction: () -> Void
    let cancelAction: () -> Void
    
    init(
        text: Binding<String>,
        minHeight: Binding<CGFloat>,
        maxHeight: CGFloat,
        delay: TimeInterval,
        sendAction: @escaping () -> Void,
        cancelAction: @escaping () -> Void
    ) {
        self._text = text
        self._minHeight = minHeight
        self.maxHeight = maxHeight
        self.sendAction = sendAction
        self.delay = delay
        self.cancelAction = cancelAction
    }
    
    enum FocusField { case text }
    @FocusState private var focusField: FocusField?
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            hideKeyboardButton
            
            HStack(alignment: .bottom, spacing: 0) {
                textEditor
                sendActionButton
            }
            .padding(.leading, 6)
            //.padding(.vertical, 1)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(.tertiary)
            )
        }
        .padding(.trailing, 6)
        .overlay(cancelButton)
        .padding(.bottom, 4)
        .layoutPriority(1)
        /// [SwiftUI default focus on TextField/TextEditor when view is loaded](https://developer.apple.com/forums/thread/681962)
        //    .onAppear {
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        //            focus = .text
        //        }
        //    }
    }
    
    private var textEditor: some View {
        TextEditor(text: $text)
            .frame(
                maxWidth: .infinity,
                minHeight: minHeight,
                maxHeight: maxHeight,
                alignment: .leading
            )
            .overlay(
                GeometryReader { geo in
                    Color.clear
                        .onChange(of: geo.size.height) { newValue in
                            minHeight = newValue
                        }
                }
            )
            .fixedSize(horizontal: false, vertical: true)
            .focused($focusField, equals: .text)
    }
    
    private var sendActionButton: some View {
        Button {
            withAnimation {
                focusField = nil
                showingCancelButton = true
                sendAction()
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
    
    @State private var showingCancelButton = false
    
    @ViewBuilder
    private var cancelButton: some View {
        if showingCancelButton {
            ExpiringButton(
                "Cancel posting message",
                role: .destructive,
                seconds: delay
            ) {
                showingCancelButton = false
                focusField = .text
                cancelAction()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.small)
            .onDisappear {
                showingCancelButton = false
            }
        }
    }
    
    private var hideKeyboardButton: some View {
        Button(action: hideKeyboard) {
            Label("hide", systemImage: "keyboard.chevron.compact.down")
                .labelStyle(.iconOnly)
                .frame(width: 44, height: 32)
        }
        .offset(y: -5)
        .disabled(focusField == nil)
    }
    
    private func hideKeyboard() {
        withAnimation {
            if focusField != nil {
                focusField = nil
            }
        }
    }
    
}

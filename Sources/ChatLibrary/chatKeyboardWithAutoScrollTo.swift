//
//  chatKeyboardWithAutoScrollTo.swift
//  ChatLibrary
//
//  Created by Igor Malyarov on 03.08.2021.
//

import SwiftUI

public extension View {
    /// Attach chat keyboard with auto scrolling to view.
    /// - Parameters:
    ///   - id: Optional ID to scroll to.
    ///   - anchor: The alignment behavior of the scroll action.
    ///   - text: Binding to string value (message text).
    ///   - maxHeight: Maximum height of TexEditor.
    ///   - delay: Delay in seconds during witch cancel action is available.
    ///   - action: Closure to perform action on string value.
    ///   - cancelAction: Cancel action, available during delay.
    ///
    ///         SomeView()
    ///             .chatKeyboard(text: $text) {
    ///                 cancelPost()
    ///             } action: {
    ///                 post()
    ///             }
    ///
    /// - Returns: Modified view with chat keyboard with auto scrolling.
    func chatKeyboardWithAutoScrollTo<ID: Hashable>(
        _ id: ID?,
        anchor: UnitPoint? = nil,
        text: Binding<String>,
        maxHeight: CGFloat = 280,
        delay: TimeInterval,
        sendAction: @escaping () -> Void,
        cancelAction: @escaping () -> Void
    ) -> some View {
        ChatKeyboardWithAutoScrollTo(
            view: self,
            id: id,
            anchor: anchor,
            text: text,
            maxHeight: maxHeight,
            delay: delay,
            sendAction: sendAction,
            cancelAction: cancelAction
        )
    }
}

private struct ChatKeyboardWithAutoScrollTo<ID: Hashable, V: View>: View {
    @Binding var text: String
    
    let view: V
    let id: ID?
    let anchor: UnitPoint?
    let maxHeight: CGFloat
    let delay: TimeInterval
    let sendAction: () -> Void
    let cancelAction: () -> Void
    
    init(
        view: V,
        id: ID?,
        anchor: UnitPoint?,
        text: Binding<String>,
        maxHeight: CGFloat,
        delay: TimeInterval,
        sendAction: @escaping () -> Void,
        cancelAction: @escaping () -> Void
    ) {
        self.view = view
        self.id = id
        self.anchor = anchor
        self._text = text
        self.maxHeight = maxHeight
        self.delay = delay
        self.sendAction = sendAction
        self.cancelAction = cancelAction
    }
    
    // min height of TextEditor is 38
    @State var minHeight: CGFloat = 38
    
    var body: some View {
        ScrollViewReader { proxy in
            view
                .onChange(of: minHeight) { _ in
                    scroll(proxy: proxy)
                }
                .autoScrollTo(id, anchor: anchor)
                .chatKeyboard(
                    text: $text,
                    minHeight: $minHeight,
                    maxHeight: maxHeight,
                    delay: delay,
                    sendAction: sendAction,
                    cancelAction: cancelAction
                )
        }
    }
    
    func scroll(proxy: ScrollViewProxy) {
        // need a delay to let text change animation (in case of paste or other programmatic change) finish
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if let id = id {
                // additional animation here leads to self jiggle when second animation invoked after text change animation
                // withAnimation {
                proxy.scrollTo(id, anchor: .bottom)
                // }
            }
        }
    }
}

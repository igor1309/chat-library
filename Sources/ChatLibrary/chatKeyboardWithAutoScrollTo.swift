//
//  chatKeyboardWithAutoScrollTo.swift
//  ChatLibrary
//
//  Created by Igor Malyarov on 03.08.2021.
//

import SwiftUI

public extension View {
#warning("how to track text height change? ad use height for tracking, not test itself")
    /// Attach chat keyboard with auto scrolling to view.
    func chatKeyboardWithAutoScrollTo<ID: Hashable>(
        _ id: ID?,
        anchor: UnitPoint? = nil,
        text: Binding<String>,
        maxHeight: CGFloat = 280,
        action: @escaping (String) -> Void
    ) -> some View {
        
        func scroll(proxy: ScrollViewProxy) {
            // additional animation here leads to self jiggle when second animation invoked after text change animation
            // withAnimation {
            // need a delay to let text change animation (in case of paste or other programmatic change) finish
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                if let id = id {
                    proxy.scrollTo(id, anchor: .bottom)
                }
            }
            // }
        }
        
        return ScrollViewReader { proxy in
            self
            // TODO: how to track text height change?
                .onChange(of: text.wrappedValue) { _ in
                    scroll(proxy: proxy)
                }
                .autoScrollTo(id, anchor: anchor)
                .chatKeyboard(text: text, maxHeight: maxHeight, action: action)
        }
    }
}

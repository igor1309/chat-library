//
//  autoScrollTo.swift
//  ChatLibrary
//
//  Created by Igor Malyarov on 03.08.2021.
//

import SwiftUI
import Combine

public extension View {
    /// Auto scroll view to provided id using anchor.
    ///
    /// Triggering events:
    /// - view appear
    /// - on id change
    /// - when keyboard shows or hides
    func autoScrollTo<ID: Hashable>(
        _ id: ID?,
        anchor: UnitPoint? = nil
    ) -> some View {
        
        func scroll(proxy: ScrollViewProxy, id: ID?) {
            if let id = id {
                withAnimation {
                    proxy.scrollTo(id, anchor: anchor)
                }
            }
        }
        
        return ScrollViewReader { proxy in
            self
                .onAppear {
                    scroll(proxy: proxy, id: id)
                }
                .onChange(of: id) { newValue in
                    scroll(proxy: proxy, id: newValue)
                }
                .onReceive(NotificationCenter.keyboardDidShow) { _ in
                    scroll(proxy: proxy, id: id)
                }
                .onReceive(NotificationCenter.keyboardDidHide) { _ in
                    scroll(proxy: proxy, id: id)
                }
        }
        
    }
}

fileprivate extension NotificationCenter {
    static let keyboardDidShow = NotificationCenter.default.publisher(for: UIApplication.keyboardDidShowNotification)
    static let keyboardDidHide = NotificationCenter.default.publisher(for: UIApplication.keyboardDidHideNotification)
}

fileprivate struct SimpleAutoScrollToDemo: View {
    struct Item: Identifiable, Hashable {
        let id: Int
        let title: String
    }
    
    @State private var listRowCount = 20
    
    var items: [Item] {
        (0 ..< listRowCount).map {
            Item(id: $0, title: "Row \($0)")
        }
    }
    
    var body: some View {
        VStack {
            Picker("List row count", selection: $listRowCount) {
                ForEach([5, 10, 20, 40], id: \.self) { number in
                    Text(number.formatted())
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            List {
                ForEach(items) { item in
                    Text(item.title)
                }
            }
            .autoScrollTo(
                items.last?.id,
                anchor: .bottom
            )
        }
    }
}

struct SimpleAutoScrollToDemo_Previews: PreviewProvider {
    static var previews: some View {
        SimpleAutoScrollToDemo()
    }
}

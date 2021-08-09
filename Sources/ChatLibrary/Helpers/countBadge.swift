//
//  countBadge.swift
//  countBadge
//
//  Created by Igor Malyarov on 09.08.2021.
//

import SwiftUI

public extension View {
    @ViewBuilder
    func countBadge(_ count: Int, font: Font? = nil) -> some View {
        self
            .modifier(BadgeCountModifier(count: count, font: font))
    }
}

fileprivate struct BadgeCountModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    
    let count: Int
    var font: Font? = nil
    
    @ViewBuilder
    func body(content: Content) -> some View {
        if count > 1 {
            HStack {
                content
                Spacer()
                badged
            }
        } else {
            content
        }
    }
    
    @ViewBuilder
    var badged: some View {
        
        switch colorScheme {
        case .dark:
            Text(count.formatted())
                .foregroundStyle(.thickMaterial)
                .font(font ?? .caption2)
                .padding(.horizontal, 3)
                .padding(1)
                .background(.secondary, in: Capsule())
            
        case .light:
            Text(count.formatted())
                .foregroundStyle(.secondary)
                .font(font ?? .caption2)
                .padding(.horizontal, 3)
                .padding(1)
                .overlay(
                    Capsule()
                        .strokeBorder()
                        .foregroundStyle(.secondary)
                )
            //                .background(.secondary, in: Capsule())
            
        @unknown default:
            Text(count.formatted())
        }
    }
}

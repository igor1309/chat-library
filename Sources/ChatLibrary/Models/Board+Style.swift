//
//  File.swift
//  File
//
//  Created by Igor Malyarov on 16.08.2021.
//

import SwiftUI

public extension Board {
    var icon: String {
        switch (status, type) {
        case (.unread, .notify):
            return "bell.circle.fill"
        case (.unread, .watch):
            return "eye.circle.fill"
        case (.unread, _):
            return "circle.inset.filled"
        case (_, .notify):
            return "bell.circle"
        case (_, .watch):
            return "eye.circle"
        default:
            return "circle"
        }
    }
    
    var style: HierarchicalShapeStyle {
        switch status {
        case .unread:
            return .primary // .accentColor
        default:
            return .secondary // .primary
        }
    }
    
    var color: Color {
        switch type {
        case .notify:
            return .mint
        case .watch:
            return .cyan
        default:
            return .primary
        }
    }

    var font: Font {
        switch status {
        case .unread:
            return .headline
        default:
            return .body
        }
    }

}

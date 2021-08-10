//
//  SpinningProgressViewStyle.swift
//  SpinningProgressViewStyle
//
//  Created by Igor Malyarov on 07.08.2021.
//

import SwiftUI

public extension ProgressViewStyle where Self == SpinningProgressViewStyle {
    static func spinningProgressViewStyle(
        lineWidth: CGFloat,
        duration: Double = 1
    ) -> SpinningProgressViewStyle {
        SpinningProgressViewStyle(
            lineWidth: lineWidth,
            duration: duration
        )
    }
}

public struct SpinningProgressViewStyle: ProgressViewStyle {
    let lineWidth: CGFloat
    let duration: Double
    
    public func makeBody(configuration: Configuration) -> some View {
        SpinningView(
            lineWidth: lineWidth,
            duration: duration
        )
    }
}

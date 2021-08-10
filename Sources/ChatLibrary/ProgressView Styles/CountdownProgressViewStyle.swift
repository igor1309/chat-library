//
//  CountdownProgressViewStyle.swift
//  CountdownProgressViewStyle
//
//  Created by Igor Malyarov on 04.08.2021.
//

import SwiftUI

public extension ProgressViewStyle where Self == CountdownProgressViewStyle {
    static func countdownProgressViewStyle(
        time: Double,
        lineWidth: CGFloat = 10
    ) -> CountdownProgressViewStyle {
        CountdownProgressViewStyle(time: time, lineWidth: lineWidth)
    }
}

public struct CountdownProgressViewStyle: ProgressViewStyle {
    let time: Double
    let lineWidth: CGFloat
    
    public func makeBody(configuration: Configuration) -> some View {
        let progress = configuration.fractionCompleted ?? 0
        
        return ZStack {
            ZStack {
                Circle()
                    .stroke(lineWidth: lineWidth)
                    .opacity(0.3)
                    .foregroundStyle(.secondary)
                
                Circle()
                    .trim(from: 0.0, to: progress)
                    .stroke(
                        style: StrokeStyle(
                            lineWidth: lineWidth,
                            lineCap: .round,
                            lineJoin: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .foregroundStyle(.primary)
            }
            
            // adding a bit to see starting time
            Text(Int(time * (1 - progress) + 0.3).formatted())
        }
    }
}

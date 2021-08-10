//
//  SpinningView.swift
//  SpinningView
//
//  Created by Igor Malyarov on 06.08.2021.
//

import SwiftUI

extension View {
    public func makeSpinningView(lineWidth: CGFloat, duration: Double) -> some View {
        SpinningView(lineWidth: lineWidth, duration: duration)
    }
}

struct SpinningView: View {
    let lineWidth: CGFloat
    let duration: Double
    
    var angularGradient: AngularGradient {
        let gradient = Gradient(
            colors: [.black.opacity(0), .black]
        )
        
        return AngularGradient(
            gradient: gradient,
            center: .center,
            startAngle: .degrees(25),
            endAngle: .degrees(180)
        )
    }
    
    @State private var angle = 0.0
    
    var body: some View {
        Arch(
            startAngle: .degrees(90),
            endAngle: .degrees(360)
        )
            .strokeBorder(
                style: StrokeStyle(
                    lineWidth: lineWidth,
                    lineCap: .round,
                    lineJoin: .round)
            )
            .mask(angularGradient)
            .rotationEffect(.degrees(angle))
            .animateForever(using: .linear(duration: duration)) {
                angle = 360
            }
        // .drawingGroup()
    }
}


// Create an immediate, looping animation
/// [How to start an animation immediately after a view appears - a free SwiftUI by Example tutorial](https://www.hackingwithswift.com/quick-start/swiftui/how-to-start-an-animation-immediately-after-a-view-appears)
extension View {
    func animateForever(
        using animation: Animation = .easeInOut(duration: 1),
        autoreverses: Bool = false,
        _ action: @escaping () -> Void
    ) -> some View {
        let repeated = animation.repeatForever(autoreverses: autoreverses)
        
        return onAppear {
            withAnimation(repeated) {
                action()
            }
        }
    }
}

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
            .onAppear {
                // using DispatchQueue.main.async to prevent rotating animation
                // to mess up with navigation animation
                DispatchQueue.main.async {
                    withAnimation(
                        .linear(duration: duration).repeatForever(autoreverses: false)
                    ) {
                        angle = 360
                    }
                }
            }
             .rotationEffect(.degrees(angle), anchor: .center)
        // .drawingGroup()
            .aspectRatio(1, contentMode: .fit)
    }
}

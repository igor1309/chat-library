//
//  Arch.swift
//  Arch
//
//  Created by Igor Malyarov on 06.08.2021.
//

import SwiftUI

public struct Arch: InsettableShape {
    public var startAngle: Angle
    public var endAngle: Angle
    public var clockwise = true
    
    public init(startAngle: Angle, endAngle: Angle, clockwise: Bool = true) {
        self.startAngle = startAngle
        self.endAngle = endAngle
        self.clockwise = clockwise
    }

    var insetAmount: CGFloat = 0
    
    public func inset(by amount: CGFloat) -> some InsettableShape {
        var arc = self
        arc.insetAmount += amount
        return arc
    }
    
    public func path(in rect: CGRect) -> Path {
        let radius = min(rect.height, rect.width) / 2 - insetAmount
        let rotationAdjustment = Angle.degrees(90)
        let modifiedStart = startAngle - rotationAdjustment
        let modifiedEnd = endAngle - rotationAdjustment
        
        return Path { path in
            path.addArc(
                center: CGPoint(x: rect.midX, y: rect.midY),
                radius: radius,
                startAngle: modifiedStart,
                endAngle: modifiedEnd,
                clockwise: !clockwise
            )
        }
    }
}

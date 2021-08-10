//
//  SwiftUIView.swift
//  SwiftUIView
//
//  Created by Igor Malyarov on 10.08.2021.
//

import SwiftUI

public extension View {
    /// Get height of the view.
    func getHeight(_ height: Binding<CGFloat>) -> some View {
        self
        // .modifier(HeightModifier(height: height))
            .background(
                GeometryReader { geo in
                    Color.clear
                        .onChange(of: geo.size.height) { newValue in
                            height.wrappedValue = newValue
                            // print("new height: \(newValue.formatted())")
                        }
                }
            )
    }
}

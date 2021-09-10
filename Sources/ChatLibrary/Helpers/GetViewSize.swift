//
//  GetViewSize.swift
//  GetViewSize
//
//  Created by Igor Malyarov on 10.08.2021.
//

import SwiftUI

public extension View {
    /// Get size of the view.
    func getSize(_ size: Binding<CGSize>) -> some View {
        self
            .background(
                GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            size.wrappedValue = geo.size
                        }
                        .onChange(of: geo.size) { newValue in
                            size.wrappedValue = newValue
                        }
                }
            )
    }

    /// Get height of the view.
    func getHeight(_ height: Binding<CGFloat>) -> some View {
        self
        // .modifier(HeightModifier(height: height))
            .background(
                GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            height.wrappedValue = geo.size.height
                            // print("new height: \(newValue.formatted())")
                        }
                        .onChange(of: geo.size.height) { newValue in
                            height.wrappedValue = newValue
                            // print("new height: \(newValue.formatted())")
                        }
                }
            )
    }

    /// Get width of the view.
    func getWidth(_ width: Binding<CGFloat>) -> some View {
        self
        // .modifier(HeightModifier(width: width))
            .background(
                GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            width.wrappedValue = geo.size.width
                        }
                        .onChange(of: geo.size.width) { newValue in
                            width.wrappedValue = newValue
                        }
                }
            )
    }
}

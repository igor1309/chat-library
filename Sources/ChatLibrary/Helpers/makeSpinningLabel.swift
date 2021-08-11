//
//  makeSpinningLabel.swift
//  makeSpinningLabel
//
//  Created by Igor Malyarov on 07.08.2021.
//

import SwiftUI

extension Text {
    public func makeSpinningLabel(
        lineWidth: CGFloat = 2,
        duration: Double = 1,
        padding: CGFloat = 3
    ) -> some View {
        Label {
            self
        } icon: {
#warning("excessive animation when using progressViewStyle - see MessageListView in BoardsIOS")
            SpinningView(
                lineWidth: lineWidth,
                duration: duration
            )
//            ProgressView()
//                .progressViewStyle(
//                    .spinningProgressViewStyle(
//                        lineWidth: lineWidth,
//                        duration: duration
//                    )
//                )
                .padding(padding)
        }
    }
}


//
//  ExpiringButton.swift
//  ExpiringButton
//
//  Created by Igor Malyarov on 04.08.2021.
//

import SwiftUI
import Combine

public struct ExpiringButton: View {
    let title: String
    let role: ButtonRole?
    let time: TimeInterval
    let action: () -> Void
    
    /// Disappearing button
    /// - Parameters:
    ///   - title: Button title.
    ///   - role: Optional Button role.
    ///   - time: Time to expiration in seconds.
    ///   - action: Button action.
    public init(
        _ title: String,
        role: ButtonRole? = nil,
        seconds time: Double,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.role = role
        self.time = time
        self.action = action
        
        let every = time / 100
        
        timer = Timer.publish(every: every, tolerance: 0.01, on: .main, in: .common).autoconnect()
    }
    
    @State private var progress = 0.0
    
    let timer: Publishers.Autoconnect<Timer.TimerPublisher>
    
    public var body: some View {
        if progress < 100 {
            Button(role: role) {
                action()
                progress = 100
            } label: {
                Label {
                    Text(title)
                } icon: {
                    ProgressView(value: progress, total: 100)
                        .progressViewStyle(
                            .countdownProgressViewStyle(
                                time: time,
                                lineWidth: 2
                            )
                        )
                        .frame(width: 20, height: 20)
                        .font(.caption)
                        .frame(height: 24)
                }
            }
            .onReceive(timer) { _ in
                if progress < 100 {
                    withAnimation {
                        progress += 1
                    }
                }
            }
        }
    }
}

fileprivate struct ExpiringButtonDemo: View {
    var body: some View {
        VStack {
            ExpiringButton(
                "Undo post message",
                role: .destructive,
                seconds: 5
            ) {
                print("undo message post action fired")
            }
            .buttonStyle(.borderedProminent)
            
            Divider().padding()
            
            ExpiringButton(
                "Undo post message",
                role: .destructive,
                seconds: 5
            ) {
                print("undo message post action fired")
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.small)
            
            Divider().padding()
            
            ExpiringButton(
                "Undo post message",
                seconds: 5
            ) {
                print("undo message post action fired")
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.small)
            
            Divider().padding()
            
            ExpiringButton("Undo post", seconds: 5) {
                print("undo fired")
            }
        }
    }
}

struct ExpiringButton_Previews: PreviewProvider {
    static var previews: some View {
        ExpiringButtonDemo()
    }
}

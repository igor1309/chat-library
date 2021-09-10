//
//  Message.swift
//  Message
//
//  Created by Igor Malyarov on 29.07.2021.
//

import Foundation
import Tagged

public struct Message: Identifiable, Hashable {
    public let id: Tagged<Self, String>
    public let user: String
    public let text: String
    public var creationDate: Date?
    
    // message status
    public var isInFlight: Bool { creationDate == nil }
    public var isSaved: Bool { creationDate != nil }
    
    public init(
        id: Tagged<Self, String>,
        user: String,
        text: String,
        creationDate: Date? = nil
    ) {
        self.id = id
        self.user = user
        self.text = text
        self.creationDate = creationDate
    }
}

public extension Message {
    init(
        id: String = UUID().uuidString,
        user: String,
        text: String,
        creationDate: Date? = nil
    ) {
        self.id = .init(rawValue: id)
        self.user = user
        self.text = text
        self.creationDate = creationDate
    }
}

public extension Message {
    func contains(
        _ string: String,
        options: String.CompareOptions
    ) -> Bool {
        user.contains(string, options: options)
        || text.contains(string, options: options)
    }
}

//
//  Board.swift
//  Board
//
//  Created by Igor Malyarov on 29.07.2021.
//

import Foundation
import Tagged
import SwiftUI

public struct Board: Identifiable, Hashable {
    public let id: Tagged<Self, String>
    public let creator: String
    public var name: String
    public var description: String
    
    public var lastMessage: Message?
    public var messagesCount: Int
    
    public var type: BoardType?
    public var status: BoardStatus?
    
    public init(
        id: Tagged<Self, String>,
        creator: String,
        name: String,
        description: String,
        lastMessage: Message? = nil,
        messagesCount: Int,
        type: Board.BoardType? = nil,
        status: Board.BoardStatus? = nil
    ) {
        self.id = id
        self.creator = creator
        self.name = name
        self.description = description
        self.lastMessage = lastMessage
        self.messagesCount = messagesCount
        self.type = type
        self.status = status
    }
}

public extension Board {
    func contains(
        _ string: String,
        options: String.CompareOptions
    ) -> Bool {
        name.contains(string, options: options)
        || description.contains(string, options: options)
    }
}

public extension Board {
    enum BoardError: Error {
        case emptyCreator, emptyName
        // "Board is not created: name is too short"
        case shortName
    }
    
    init(
        id: String = UUID().uuidString,
        creator: String,
        name: String,
        description: String,
        lastMessage: Message? = nil,
        messagesCount: Int = 0
    ) throws {
        guard !creator.isEmpty else {
            throw BoardError.emptyCreator
        }
        guard !name.isEmpty else {
            throw BoardError.emptyName
        }
        
        guard name.count > 2 else {
            throw BoardError.shortName
        }
        
        self.id = .init(rawValue: id)
        self.creator = creator
        self.name = name
        self.description = description
        self.lastMessage = lastMessage
        self.messagesCount = messagesCount
    }
}

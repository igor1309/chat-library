//
//  Board+CloudKit.swift
//  Board+CloudKit
//
//  Created by Igor Malyarov on 16.08.2021.
//

import CloudKit

public extension Board {
    static let recordType = "Board"
    
    enum RecordKey: String {
        case id, creator, name, description
    }
    
    enum RecordError: Error {
        case wrongRecordType, missingKey(RecordKey)
    }
    
    init(from record: CKRecord) /*async*/ throws {
        guard record.recordType == Self.recordType else {
            throw RecordError.wrongRecordType
        }
        
        let id = record.recordID.recordName
        
        guard let creator = record[RecordKey.creator] as? String else {
            throw RecordError.missingKey(.creator)
        }
        
        guard let name = record[RecordKey.name] as? String else {
            throw RecordError.missingKey(.name)
        }
        
        guard let description = record[RecordKey.description] as? String else {
            throw RecordError.missingKey(.description)
        }
        
        self.init(
            id: .init(rawValue: id),
            creator: creator,
            name: name,
            description: description,
            messagesCount: 0
        )
    }
    
    func prepareRecord() -> CKRecord {
        let recordName = id.rawValue
        let recordID = CKRecord.ID(recordName: recordName)
        let record = CKRecord(recordType: Self.recordType, recordID: recordID)
        record[RecordKey.id] = id.rawValue
        record[RecordKey.creator] = creator
        record[RecordKey.name] = name
        record[RecordKey.description] = description
        
        return record
    }
    
}

extension CKRecord {
    subscript(key: Board.RecordKey) -> Any? {
        get {
            return self[key.rawValue]
        }
        set {
            self[key.rawValue] = newValue as? CKRecordValue
        }
    }
}

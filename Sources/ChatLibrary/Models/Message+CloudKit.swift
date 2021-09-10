//
//  File.swift
//  File
//
//  Created by Igor Malyarov on 16.08.2021.
//

import CloudKit

public extension Message {
    static let recordType = "Message"
    
    enum RecordKey: String {
        case id, user, text, status, board
    }
    
    enum RecordError: Error {
        case wrongRecordType, missingKey(RecordKey)
    }
    
    init(from record: CKRecord) throws {
        guard record.recordType == Self.recordType else {
            throw RecordError.wrongRecordType
        }
        
        let id = record.recordID.recordName
        
        guard let user = record[RecordKey.user] as? String else {
            throw RecordError.missingKey(.user)
        }
        
        guard let text = record[RecordKey.text] as? String else {
            throw RecordError.missingKey(.text)
        }
        
        self.init(
            id: .init(rawValue: id),
            user: user,
            text: text,
            creationDate: record.creationDate
        )
    }
    
    func prepareRecord(parentID: Board.ID) -> CKRecord {
        let recordName = id.rawValue
        let recordID = CKRecord.ID(recordName: recordName)
        let record = CKRecord(
            recordType: Self.recordType,
            recordID: recordID
        )
        record[RecordKey.id] = id
        record[RecordKey.user] = user
        record[RecordKey.text] = text
        // no need for message status in cloud - once it's there it is delivered
        // record[RecordKey.status] = status
        
        let parentName = parentID.rawValue
        let parentID = CKRecord.ID(recordName: parentName)
        record[RecordKey.board] = CKRecord.Reference(
            recordID: parentID,
            action: .deleteSelf
        )
        
        return record
    }
    
    static func query(
        in board: Board,
        sortKey key: String = "creationDate",
        ascending: Bool = false
    ) -> CKQuery {
        let recordID = CKRecord.ID(recordName: board.id.rawValue)
        let reference = CKRecord.Reference(recordID: recordID, action: .none)
        let predicate = NSPredicate(
            format: "%K == %@",
            Message.RecordKey.board.rawValue,
            reference
        )
        let sort = NSSortDescriptor(key: key, ascending: ascending)
        let query = CKQuery(recordType: Message.recordType, predicate: predicate)
        query.sortDescriptors = [sort]
        
        return query
    }
    
}

extension CKRecord {
    subscript(key: Message.RecordKey) -> Any? {
        get {
            return self[key.rawValue]
        }
        set {
            self[key.rawValue] = newValue as? CKRecordValue
        }
    }
}

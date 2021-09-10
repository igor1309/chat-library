//
//  Board+BoardType.swift
//  Board+BoardType
//
//  Created by Igor Malyarov on 16.08.2021.
//

import CloudKit

#warning("THAT IS WRONG - SHOULD NOT STORE BOARD SUBSCRIPTION DATA IN PUBLIC DATABASE")
public extension Board {
    enum BoardType: Equatable, Hashable {
        case notify(CKSubscription.ID)
        case watch(CKSubscription.ID)
    }
    
    var subscriptionID: CKSubscription.ID? {
        switch type {
        case let .notify(subscriptionID),
            let .watch(subscriptionID):
            return subscriptionID
        case .none:
            return nil
        }
    }
    
    var isWatch: Bool {
        guard case .watch = type else {
            return false
        }
        return true
    }
    
    var isNotify: Bool {
        guard case .notify = type else {
            return false
        }
        return true
    }
}

//
//  String+Ext.swift
//  String+Ext
//
//  Created by Igor Malyarov on 04.08.2021.
//

import Foundation

public extension String {
    func contains(_ other: String, options: String.CompareOptions = .diacriticInsensitive) -> Bool {
        let range = range(of: other, options: options)
        return range != nil
    }
}

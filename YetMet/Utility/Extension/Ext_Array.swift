//
//  Ext_Array.swift
//  YetMet
//
//  Created by Sun on 2021/8/2.
//

import Foundation

extension Array {
    func takeElements(_ elementCount: Int) -> Array {
        var element_count = elementCount
        if (element_count > count) {
            element_count = count
        }
        return Array(self[0..<element_count])
    }
    
    subscript (range r: Range<Int>) -> Array {
        return Array(self[r])
    }
}

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}

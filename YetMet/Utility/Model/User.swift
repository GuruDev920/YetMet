//
//  User.swift
//  YetMet
//
//  Created by Sun on 2021/8/2.
//

import Foundation

class User: NSObject {
    var uid = String()
    
    static let key_uid = "uid"
    
    override init() {
        super.init()
    }
    
    init(dic: [String: Any]) {
        super.init()
        
        if let uid = dic[User.key_uid] as? String {
            self.uid = uid
        }
    }
}

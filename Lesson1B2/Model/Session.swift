//
//  Session.swift
//  Lesson1B2
//
//  Created by user on 25.05.2021.
//

import Foundation

class Session {
    
    static let instance = Session()
    
    private init() {}
    
    var token = String()
    var userID = Int()
}

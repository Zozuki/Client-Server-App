//
//  DataStorage.swift
//  Lesson1B2
//
//  Created by user on 13.04.2021.
//

import UIKit

class DataStorage: NSObject {
    
    static let shared = DataStorage()
    
    private override init() {
        super.init()
    }
    
    var news = [News]()
    
    var usersArrray = [User]()
    var myFriendsArray = [User]()
    
    var allGroups = [Group]()
    var myGroups = [Group]()
}

//
//  Utilities.swift
//  PersonalisedFilters
//
//  Created by Midhunlal M on 01/09/21.
//

import Foundation

class Utilities {
    static func getDataFromUserDefaults(for key: String) -> [String: String]? {
        return UserDefaults.standard.object(forKey: key) as? [String: String]
    }
    
    static func setDataInUserDefaults(_ data: [String: String], for key: String) {
        UserDefaults.standard.setValue(data, forKey: key)
        UserDefaults.standard.synchronize()
    }
}

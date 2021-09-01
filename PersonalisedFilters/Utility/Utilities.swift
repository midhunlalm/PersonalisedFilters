//
//  Utilities.swift
//  PersonalisedFilters
//
//  Created by Midhunlal M on 01/09/21.
//

import Foundation

class Utilities {
    static func getDataFromUserDefaults(for key: String) -> [String: Int]? {
        return UserDefaults.standard.object(forKey: key) as? [String: Int]
    }
    
    static func setDataInUserDefaults(_ data: [String: Int], for key: String) {
        UserDefaults.standard.setValue(data, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    static func sortFilters(_ data: [Filter], filterType: FilterType) -> [Filter] {
        switch filterType {
        case .autoCustomisedFilter:
            let sortedData = data.sorted(by: {
                $0.count > $1.count
            })
            return sortedData
        case .selfCustomisedFilter:
            let sortedData = data.sorted(by: {
                $0.count < $1.count
            })
            return sortedData
        }
    }
}

//
//  Utilities.swift
//  PersonalisedFilters
//
//  Created by Midhunlal M on 01/09/21.
//

import Foundation

enum FilterType: String {
    case selfCustomisedFilter
    case autoCustomisedFilter
    
    var screenTitle: String {
        switch self {
        case .selfCustomisedFilter:
            return "User Customisable Filter"
        case .autoCustomisedFilter:
            return "Auto Customised Filter"
        }
    }
    
    var userInfoText: String {
        switch self {
        case .selfCustomisedFilter:
            return "Rearrange your filter option and click on save"
        case .autoCustomisedFilter:
            return "Customised automatically based on the frequency of usage"
        }
    }
}

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
            if !Utilities.shouldResetFiltersCount(filters: data) {
                let sortedData = data.sorted(by: { $0.count > $1.count })
                return sortedData
            } else {
                var updatedData = [Filter]()
                for each in data {
                    let filter = Filter(id: each.id, name: each.name, count: 0)
                    updatedData.append(filter)
                }
                return updatedData
            }
        case .selfCustomisedFilter:
            let sortedData = data.sorted(by: { $0.count < $1.count })
            return sortedData
        }
    }
    
    static func fetchSavedFilterData(forType filterType: FilterType) -> [Filter]? {
        guard let path = Bundle.main.path(forResource: "input", ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe),
              var model = try? JSONDecoder().decode([Filter].self, from: data) else { return nil }
        
        if let sortedFilters = getDataFromUserDefaults(for: filterType.rawValue) {
            var newModel = [Filter]()
              for (key, value) in sortedFilters {
                for (index, var each) in model.enumerated() {
                    if each.id == key { //check for matching FilterIds
                        each.count = value //update the count
                        newModel.append(each)
                        model.remove(at: index) //append to the actual sorted/updated dataModel.
                        break
                    }
                }
            }
            newModel.append(contentsOf: model)
            return sortFilters(newModel, filterType: filterType)
        }
        
        return model
    }
    
    static func shouldResetFiltersCount(filters: [Filter]) -> Bool {
        //reset filters count if all of them reach max value.
        for each in filters {
            if each.count != CustomisedFiltersViewController.maxSelectionCount {
                return false
            }
        }
        return true
    }
}

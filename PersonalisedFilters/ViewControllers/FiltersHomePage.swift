//
//  FiltersHomePage.swift
//  PersonalisedFilters
//
//  Created by Manjula Pajaniraja on 01/09/21.
//

import UIKit

enum FilterType: String {
    case SelfCustomisedFilter
    case AutoCustomisedFilter
}

class FiltersHomePage: UIViewController {
    
    var currentFilterSelected: FilterType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func fetchData() -> [[String: String]]? {
        var model: [[String: String]]?
        guard let path = Bundle.main.path(forResource: "input", ofType: "json") else { return nil }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else { return nil }
        do{
            model = try JSONDecoder().decode([[String: String]].self, from: data)
        } catch (let error) {
            print(error.localizedDescription)
        }
        if var model = model, let currentFilterSelected = self.currentFilterSelected,
              let sortedFilters = UserDefaults.standard.object(forKey: currentFilterSelected.rawValue) as? [String: String] {
            var newModel = [[String: String]]()
              for (key, value) in sortedFilters {
                for (index, var each) in model.enumerated() {
                    if each["id"] == key { //check for matching FilterIds
                        each["count"] = value //update the count
                        newModel.append(each)
                        model.remove(at: index) //append to the actual sorted/updated dataModel.
                        break
                    }
                }
            }
            newModel.append(contentsOf: model)
            return newModel
        }
        return model
    }
    
    func pushFiltersVC() {
        guard let data = fetchData() else { return }
        // push the customisedFiltersViewController and then unComment the below lines of code.
//        filtersVC.filtersData = data
//        filtersVC.currentFilterType = currentFilterSelected
    }
    
    
    @IBAction func openSelfCustomizedFilters(_ sender: Any) {
        currentFilterSelected = .SelfCustomisedFilter
        pushFiltersVC()
    }
    
    
    @IBAction func openAutoCustomizedFilters(_ sender: Any) {
        currentFilterSelected = .AutoCustomisedFilter
        pushFiltersVC()
    }
    
    
    
}

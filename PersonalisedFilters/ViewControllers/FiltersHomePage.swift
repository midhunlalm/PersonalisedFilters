//
//  FiltersHomePage.swift
//  PersonalisedFilters
//
//  Created by Manjula Pajaniraja on 01/09/21.
//

import UIKit

struct Filter: Decodable {
    var id: String
    var name: String
    var count: Int
}

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

class FiltersHomePage: UIViewController {
    
    var currentFilterSelected: FilterType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension FiltersHomePage {
    func fetchData() -> [Filter]? {
        var model: [Filter]?
        guard let path = Bundle.main.path(forResource: "input", ofType: "json") else { return nil }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else { return nil }
        do{
            model = try JSONDecoder().decode([Filter].self, from: data)
        } catch (let error) {
            print(error.localizedDescription)
        }
        if var model = model, let currentFilterSelected = self.currentFilterSelected,
           let sortedFilters = Utilities.getDataFromUserDefaults(for: currentFilterSelected.rawValue) {
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
            return Utilities.sortFilters(newModel, filterType: currentFilterSelected)
        }
        return model
    }
    
    func pushFiltersVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let customisedFiltersVC = storyboard.instantiateViewController(withIdentifier: "CustomisedFiltersViewController") as? CustomisedFiltersViewController
        guard let viewController = customisedFiltersVC,
              let data = fetchData() else { return }
        viewController.filtersData = data
        viewController.currentFilterType = currentFilterSelected
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func openSelfCustomizedFilters(_ sender: Any) {
        currentFilterSelected = .selfCustomisedFilter
        pushFiltersVC()
    }
    
    @IBAction func openAutoCustomizedFilters(_ sender: Any) {
        currentFilterSelected = .autoCustomisedFilter
        pushFiltersVC()
    }
}

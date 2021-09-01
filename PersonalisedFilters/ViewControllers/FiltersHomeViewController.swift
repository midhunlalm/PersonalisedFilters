//
//  FiltersHomeViewController.swift
//  PersonalisedFilters
//
//  Created by Manjula Pajaniraja on 01/09/21.
//

import UIKit

class FiltersHomeViewController: UIViewController {
    var currentFilterSelected: FilterType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension FiltersHomeViewController {
    func pushFiltersVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let customisedFiltersVC = storyboard.instantiateViewController(withIdentifier: "CustomisedFiltersViewController") as? CustomisedFiltersViewController
        guard let viewController = customisedFiltersVC,
              let currentFilterSelected = currentFilterSelected,
              let data = Utilities.fetchSavedFilterData(forType: currentFilterSelected) else { return }
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

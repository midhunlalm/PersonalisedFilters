//
//  CustomisedFiltersViewController.swift
//  PersonalisedFilters
//
//  Created by Manjula Pajaniraja on 01/09/21.
//

import UIKit

class CustomisedFiltersViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var saveYourChangesButton: UIButton!
    
    private var datasource = [String]()
    var filtersData: [Filter]?
    var currentFilterType: FilterType?
    
    static let maxSelectionCount = 25
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        saveAutoCustomisedFilterData()
        super.viewWillDisappear(animated)
    }
    
    @IBAction func didTapSaveYourChanges(_ sender: Any) {
        saveSelfCustomisedFilterData()
    }
}

extension CustomisedFiltersViewController {
    func setupInterface() {
        title = currentFilterType?.screenTitle
        infoLabel.text = currentFilterType?.userInfoText
        collectionView.dataSource = self
        collectionView.delegate = self
        
        if currentFilterType == .selfCustomisedFilter {
            collectionView.dragDelegate = self
            collectionView.dropDelegate = self
            collectionView.dragInteractionEnabled = true
            saveYourChangesButton.isHidden = false
        } else {
            saveYourChangesButton.isHidden = true
        }
        updateDatasource()
    }
    
    func updateDatasource() {
        datasource.removeAll()
        filtersData?.forEach({ (item) in
            datasource.append(item.name)
        })
    }
    
    func reorderItems(coordinator: UICollectionViewDropCoordinator,
                      destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        guard let item = coordinator.items.first,
              let sourceIndexPath = item.sourceIndexPath else { return }
        collectionView.performBatchUpdates({ [weak self] in
            guard let self = self else { return }
            self.datasource.remove(at: sourceIndexPath.item)
            self.datasource.insert((item.dragItem.localObject as? String) ?? "", at: destinationIndexPath.item)
            self.collectionView.deleteItems(at: [sourceIndexPath])
            self.collectionView.insertItems(at: [destinationIndexPath])
        }, completion: nil)
        coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
    }
    
    func saveUserFilerCustomisation() {
        (currentFilterType == .selfCustomisedFilter) ? saveSelfCustomisedFilterData()
            : saveAutoCustomisedFilterData()
    }

    func saveSelfCustomisedFilterData() {
        var filterDictToSave = [String: Int]()
        datasource.enumerated().forEach { (index, item) in
            if let filterItem = filtersData?.first(where: { $0.name == item }) {
                filterDictToSave[filterItem.id] = (index+1)
            }
        }
        Utilities.setDataInUserDefaults(filterDictToSave, for: FilterType.selfCustomisedFilter.rawValue)
    }
    
    func saveAutoCustomisedFilterData() {
        guard let filtersData = self.filtersData else { return }
        var dict = [String: Int]()
        for each in filtersData {
            dict[each.id] = each.count
        }
        Utilities.setDataInUserDefaults(dict, for: currentFilterType?.rawValue ?? "")
    }
    
    func updateDataForAutoCustomisedFilters(for item: String) {
        for (index, each) in self.filtersData!.enumerated() {
            if each.name == item && each.count < CustomisedFiltersViewController.maxSelectionCount {
                self.filtersData?[index].count += 1
            }
        }
    }
}

extension CustomisedFiltersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath)
        if let filterCell = cell as? FilterCell {
            filterCell.configure(title: datasource[indexPath.row])
        }
        return cell
    }
}

extension CustomisedFiltersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = datasource[indexPath.row]
        infoLabel.text = "You have selected \(item)"
        if currentFilterType == .autoCustomisedFilter {
            updateDataForAutoCustomisedFilters(for: item)
        }
    }
}

extension CustomisedFiltersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 50)
    }
}

extension CustomisedFiltersViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession,
                        at indexPath: IndexPath) -> [UIDragItem] {
        let item = datasource[indexPath.row]
        let itemProvider = NSItemProvider(object: item as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
}

extension CustomisedFiltersViewController: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession,
                        withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UICollectionViewDropProposal(operation: .forbidden)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        var destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let row = collectionView.numberOfItems(inSection: 0)
            destinationIndexPath = IndexPath(item: (row - 1), section: 0)
        }
        if coordinator.proposal.operation == .move {
            reorderItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath,
                         collectionView: collectionView)
        }
    }
}

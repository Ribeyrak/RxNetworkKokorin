//
//  ViewController.swift
//  RxNetworkKokorin
//
//  Created by Yevhen Lukhtan on 20.12.2023.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    var searchBar: UISearchBar {
        return searchController.searchBar
    }
    
    var viewModel: ViewModel?
    let apiManager = APIManager()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configSearchController()
        
        viewModel = ViewModel(APIManager: apiManager)
        if let viewModel = viewModel {
            viewModel.data.drive(tableView.rx.items(cellIdentifier: "cell")) { _, repository, cell in
                cell.textLabel?.text = repository.name
                cell.detailTextLabel?.text = repository.url
            }
            .disposed(by: disposeBag)
            
            searchBar.rx.text
                .orEmpty
                .bind(to: viewModel.searchText)
                .disposed(by: disposeBag)
            searchBar.rx.cancelButtonClicked
                .map {""}
                .bind(to: viewModel.searchText)
                .disposed(by: disposeBag)
            
            viewModel.data.asDriver()
                .map {
                    "\($0.count) finding repos"
                }
                .drive(navigationItem.rx.title)
                .disposed(by: disposeBag)
        }
    }

    func configSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        //searchController.automaticallyShowsCancelButton = true
        searchBar.showsCancelButton = true
        searchBar.text = "Rx"
        searchBar.placeholder = "Enter text"
        
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
    }
}


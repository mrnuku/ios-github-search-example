//
//  GithubSearchViewController.swift
//  github-search-example
//
//  Created by mrnuku on 31/10/2023.
//

import UIKit
import SwiftUI

class GithubSearchViewController: UITableViewController {
    
    var searchText: String = ""
    var isFiltered = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let search = UISearchController(searchResultsController: nil)
        search.delegate = self
        search.searchBar.delegate = self
        self.navigationItem.searchController = search
    }


}

extension GithubSearchViewController: UISearchControllerDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchText = ""
        isFiltered = false
        self.tableView.reloadData()
    }
}

extension GithubSearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            self.searchText = ""
            isFiltered = false
            self.tableView.reloadData()
            return
        }
        self.searchText = searchText
        isFiltered = true
        self.tableView.reloadData()
    }
}

// UITableViewDelegate and DataSource
extension GithubSearchViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
    }
}

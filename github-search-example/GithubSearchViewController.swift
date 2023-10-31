//
//  GithubSearchViewController.swift
//  github-search-example
//
//  Created by mrnuku on 31/10/2023.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage

class GithubSearchViewController: UITableViewController {
    
    var reqest: Disposable?
    var items: [Repo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let search = UISearchController(searchResultsController: nil)
        search.delegate = self
        search.searchBar.delegate = self
        self.navigationItem.searchController = search
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        
        let data = items[indexPath.row]

        switch segue.identifier {
        case "openDetail":
            if let dest = segue.destination as? WebViewViewController {
                dest.url = data.html_url
            }
        default:
            break
        }
    }
}

extension GithubSearchViewController: UISearchControllerDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        items = []
        self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
}

extension GithubSearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        reqest?.dispose()
        
        if !searchText.isEmpty {
            
            let req = URLRequest(url: URL(string: "https://api.github.com/search/repositories?q=\(searchText)")!)
            let responseJSON = URLSession.shared.rx.data(request: req)
            
            reqest = responseJSON
            // this will fire the request
                .subscribe(onNext: { data in
                    
                    let decoder = JSONDecoder()
                    var itemsNew: [Repo] = []
                    
                    do { 
                        let decoded = try decoder.decode(SearchResponse.self, from: data)
                        itemsNew = decoded.items
                    }
                    catch {
                        print("deserialization failed: \(error)")
                    }
                    
                    DispatchQueue.main.async {
                        self.items = itemsNew
                        self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                    }
                    
                })
        }
        else {
            self.items = []
            self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }
}

// UITableViewDelegate and DataSource
extension GithubSearchViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dequedCell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        
        if let cell = dequedCell as? GithubSearchTableViewCell {
            
            let cellData = items[indexPath.row]
            
            cell.avatarImageView.sd_setImage(with: URL(string: cellData.owner.avatar_url), placeholderImage: UIImage(named: "github-mark.png"))
            cell.ownerNameLabel.text = cellData.owner.login
            cell.repoNameLabel.text = cellData.full_name
            cell.repoDescriptionLabel.text = cellData.description
            cell.repoLanguageLabel.text = cellData.language
            cell.repoStarsLabel.text = "☆ \(cellData.stargazers_count)"
        }
        
        return dequedCell
    }
}

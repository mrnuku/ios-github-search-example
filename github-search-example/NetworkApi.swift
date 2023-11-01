//
//  NetworkApi.swift
//  github-search-example
//
//  Created by mrnuku on 01/11/2023.
//

import Foundation
import RxSwift
import RxCocoa

func searchRepos(searchText: String, success: @escaping (([Repo]) -> Void)) -> Disposable {
    let req = URLRequest(url: URL(string: "https://api.github.com/search/repositories?q=\(searchText)")!)
    let responseData = URLSession.shared.rx.data(request: req)
    
    let request = responseData
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
                success(itemsNew)
            }
            
        })
    
    return request
}

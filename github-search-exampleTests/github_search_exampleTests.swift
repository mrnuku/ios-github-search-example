//
//  github_search_exampleTests.swift
//  github-search-exampleTests
//
//  Created by mrnuku on 31/10/2023.
//

import XCTest
import RxSwift
import RxCocoa
import RxBlocking

@testable import github_search_example

final class github_search_exampleTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSearchRepos() throws {
        let searchText = "git"
        let req = URLRequest(url: URL(string: "https://api.github.com/search/repositories?q=\(searchText)")!)
        let responseData = URLSession.shared.rx.data(request: req)
        var items: [Repo] = []
        
        if let data = try responseData.toBlocking().first() {
            let decoder = JSONDecoder()
            let decoded = try decoder.decode(SearchResponse.self, from: data)
            items = decoded.items
        }
        
        XCTAssertGreaterThan(items.count, 0)
    }

}

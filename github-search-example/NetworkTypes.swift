//
//  NetworkTypes.swift
//  github-search-example
//
//  Created by mrnuku on 31/10/2023.
//

import Foundation

struct Owner: Codable {
    var login: String
    var avatar_url: String
}

struct Repo: Codable {
    var owner: Owner
    var description: String?
    var full_name: String
    var html_url: String
    var stargazers_count: Int
    var language: String?
}

struct SearchResponse: Codable {
    var items: [Repo]
}

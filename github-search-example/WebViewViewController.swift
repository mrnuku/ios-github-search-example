//
//  WebViewViewController.swift
//  github-search-example
//
//  Created by mrnuku on 31/10/2023.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController {
    
    var url: String?
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let url = url {
            webView.load(URLRequest(url: URL(string: url)!))
        }
    }


}

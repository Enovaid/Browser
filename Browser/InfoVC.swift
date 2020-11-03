//
//  InfoVC.swift
//  Browser
//
//  Created by Айдана on 10/3/20.
//

import UIKit
import WebKit

protocol passInfDelegate {
    func pass(browser: Browser)
}

class InfoVC: UIViewController {
    var browser: Browser?
    var delegate: passInfDelegate?
    
    @IBOutlet weak var webView: WKWebView!
    var siteString: String? {
        didSet {
            if webView != nil {
                updateUI()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if browser?.favourite == true {
            view.backgroundColor = UIColor.yellow
        }
//        navigationItem.hidesBackButton = true
        updateUI()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tripleTapped))
        tap.numberOfTapsRequired = 3
        view.addGestureRecognizer(tap)
        //self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
    }
    @objc func tripleTapped() {
        if browser?.favourite == false {
            view.backgroundColor = UIColor.yellow
            delegate?.pass(browser: browser!)
            browser?.favourite = true
        }
        else {
            view.backgroundColor = UIColor.clear
            delegate?.pass(browser: browser!)
            browser?.favourite = false
            
        }
    }
    
    func updateUI(){
        if let siteString = siteString {
            webView.load(URLRequest(url: URL(string: siteString)!))
        }
        
    }
    

   
    

}



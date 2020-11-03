//
//  BrowsersVC.swift
//  Browser
//
//  Created by Айдана on 10/6/20.
//

import UIKit

class BrowsersVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var showAlertButton: UIBarButtonItem!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    private var browsers: [Browser] =
        [
            Browser(name: "Google", image: "https://www.google.com/", favourite: false, indexList: 0, indexFav: 0),
            Browser(name: "VK", image: "https://vk.com/", favourite: false, indexList: 0, indexFav: 0),
            Browser(name: "Instagram", image: "https://www.instagram.com/", favourite: false, indexList: 0, indexFav: 0),
            Browser(name: "Linkedin", image: "https://www.linkedin.com/", favourite: false, indexList: 0, indexFav: 0)
        ]
    private var favourites: [Browser] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.title = "Websites"
        showAlertButton.target = self
        showAlertButton.action = #selector(showAddingAlert)
        
    }
    
    @objc func showAddingAlert() {
        let textAlertView = UIAlertController(title: "Add website", message: "Fill all the fields", preferredStyle: .alert)
        textAlertView.addTextField(configurationHandler: nil)
        textAlertView.addTextField(configurationHandler: nil)
        textAlertView.textFields![0].placeholder = "Enter title"
        textAlertView.textFields![1].placeholder = "Enter url"
        textAlertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        textAlertView.addAction(UIAlertAction(title: "Add", style: .default, handler: { [self] (_) in
            
            browsers.append(Browser(name: textAlertView.textFields![0].text!, image: textAlertView.textFields![1].text!, favourite: false, indexList: 0, indexFav: 0))
            tableView.reloadData()
            print(browsers)
        }))
        
        self.present(textAlertView, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return browsers.count
        case 1:
            return favourites.count
        default:
            break
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            cell.textLabel?.text = browsers[indexPath.row].name
        case 1:
            cell.textLabel?.text = favourites[indexPath.row].name
        default:
            break
        }
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    @IBAction func segmentedChanged(_ sender: Any) {
        tableView.reloadData()
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let navcon = segue.destination as? UINavigationController {
                if let destination = navcon.visibleViewController as? InfoVC{
                    if let row = tableView.indexPathForSelectedRow?.row {
                       
                        destination.delegate = self
                        switch segmentedControl.selectedSegmentIndex {
                        case 0:
                            
                            browsers[row].indexList = row
                            tableView.reloadData()
                            destination.browser = browsers[row]
                            destination.siteString = browsers[row].image
//                            destination.navigationItem.title = browsers[row].name
                        case 1:
                            destination.browser = favourites[row]
                            destination.siteString = favourites[row].image
//                            destination.navigationItem.title = smth[row].name
                        default:
                            break
                        }
                    }
                }
            }
        }
    }

}

extension BrowsersVC: passInfDelegate {
    func pass(browser: Browser) {
        self.dismiss(animated: true) { [self] in
            if browser.favourite == true {
                if favourites.count != 1 && segmentedControl.selectedSegmentIndex == 1{
                    for i in browser.indexFav!+1...favourites.count-1 {
                        self.favourites[i].indexFav = self.favourites[i].indexFav! - 1
                        self.browsers[favourites[i].indexList!].indexFav = self.favourites[i].indexFav! - 1
                    }
                    
                }
                self.favourites.remove(at: browser.indexFav!)
                self.browsers[browser.indexList!].favourite = false
            }
            else if browser.favourite == false {
                print(self.browsers)
                self.browsers[browser.indexList!].indexFav = self.favourites.count
                self.browsers[browser.indexList!].favourite = true
            
                self.favourites.append(Browser(name: browser.name, image: browser.image, favourite: true, indexList: browser.indexList, indexFav: self.favourites.count))
            }
            
            self.tableView.reloadData()
        }
    }
}

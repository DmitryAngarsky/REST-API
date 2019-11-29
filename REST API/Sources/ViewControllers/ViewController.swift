//
//  ViewController.swift
//  REST API
//
//  Created by Дмитрий Тараканов on 29.11.2019.
//  Copyright © 2019 Dmitry Angarsky. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UITableViewController {
    
    var days: [Day] = []
    let spinner = UIActivityIndicatorView(style: .large)
    
    let cellIdentifier = "cell"
    let URLCell        = "URLTableViewCell"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        APIServices.shared.getObject(method: APIServices.eventMethod, params: ["id" : "F95908B6-492E-4D4A-B780-66E9DFE413E4"])
        {[weak self] (result : Cource?, error: Error?) in
            if let error = error {
                print("\(error)")
            } else if let result = result {
                self?.update(from: result)
            }
        }
        
        spinner.startAnimating()
        tableView.backgroundView = spinner
        tableView.register(UINib(nibName: URLCell, bundle: nil), forCellReuseIdentifier: URLCell)
    }

    private func update(from result: Cource) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            
            self.spinner.stopAnimating()
            self.spinner.isHidden = true
            
            self.navigationItem.title = result.event.title
            self.days = result.event.dayes
            
            self.tableView.reloadData()
        }
    }
    //MARK: -TableView Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if days[section].items.first?.links.isEmpty ?? true {
            return 1
        } else {
            return (days[section].items.first?.links.count ?? 0) + 1}
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return days.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CustomTableViewCell
            let day = days[indexPath.section].items.first
            
            cell.title.text           = day?.title
            cell.itemDescription.text = day?.itemDescription
            cell.presenterName.text   = day?.presenterName
            cell.timeString.text      = day?.timeString
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: URLCell, for: indexPath) as! URLTableViewCell
            let link = days[indexPath.section].items.first?.links[indexPath.row - 1]
            
            cell.title.text = link?.title
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Темы на " + days[section].title
    }
    
    //MARK: -TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row != 0 {
            if let link = days[indexPath.section].items.first?.links[indexPath.row - 1].url {
                let url = URL(string: link)
                let svc = SFSafariViewController(url: url!)
                present(svc, animated: true)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 25)
    }
}



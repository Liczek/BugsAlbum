//
//  ViewController.swift
//  BugsAlbum
//
//  Created by Paweł Liczmański on 16.05.2017.
//  Copyright © 2017 Paweł Liczmański. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var bugs = [ScaryBug]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scaryBugs = ScaryBug.bugs()
        bugs = scaryBugs
        
        title = "Bugs Album"
        
        automaticallyAdjustsScrollViewInsets = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

extension ViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bugs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BugsCell", for: indexPath)
        let bug = bugs[indexPath.row]
        cell.textLabel?.text = bug.name
        if let bugImage = bug.image {
            cell.imageView?.image = bugImage
        }
        
        return cell
    }
}

//
//  ViewController.swift
//  BugsAlbum
//
//  Created by Paweł Liczmański on 16.05.2017.
//  Copyright © 2017 Paweł Liczmański. All rights reserved.
//

import UIKit

class BugsViewController: UIViewController {
    
    var bugSections = [BugSection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBugs()
        
        title = "Bugs Album"
        
        automaticallyAdjustsScrollViewInsets = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    private func setupBugs() {
        bugSections.append(BugSection(howScary: .NotScary))
        bugSections.append(BugSection(howScary: .ALittleScary))
        bugSections.append(BugSection(howScary: .AverageScary))
        bugSections.append(BugSection(howScary: .QuiteScary))
        bugSections.append(BugSection(howScary: .Aiiiiieeeee))
        let bugs = ScaryBug.bugs()
        for bug: ScaryBug in bugs {
            let bugSection = bugSections[bug.howScary.rawValue]
            bugSection.bugs.append(bug)
        }
    }
}

extension BugsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return bugSections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let bugSection = bugSections[section]
        return ScaryBug.scaryFactorToString(scaryFactor: bugSection.howScary)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let bugSection = bugSections[section]
        return bugSection.bugs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BugsCell", for: indexPath)
        let bugSection = bugSections[indexPath.section]
        let bugs = bugSection.bugs
        let bug = bugs[indexPath.row]
        
        cell.textLabel?.text = bug.name
        cell.detailTextLabel?.text = ScaryBug.scaryFactorToString(scaryFactor: bug.howScary)
        if let bugImage = bug.image {
            cell.imageView?.image = bugImage
        }
        
        return cell
    }
}

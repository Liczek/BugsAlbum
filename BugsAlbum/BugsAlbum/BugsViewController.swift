//
//  ViewController.swift
//  BugsAlbum
//
//  Created by Paweł Liczmański on 16.05.2017.
//  Copyright © 2017 Paweł Liczmański. All rights reserved.
//

import UIKit

class BugsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var bugSections = [BugSection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        
        tableView.allowsSelectionDuringEditing = true
        
        navigationItem.rightBarButtonItem = editButtonItem
        
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

//MARK: Table View DATA SOURCE

extension BugsViewController: UITableViewDataSource {
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            
            tableView.beginUpdates()
            for (index, bugSection) in bugSections.enumerated() {
                let indexPath = IndexPath(row: bugSection.bugs.count, section: index)
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
            tableView.endUpdates()
            tableView.setEditing(true, animated: true)
        } else {
            tableView.beginUpdates()
            for (index, bugSection) in bugSections.enumerated() {
                let indexPath = IndexPath(row: bugSection.bugs.count, section: index)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            tableView.endUpdates()
            tableView.setEditing(false, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let bugSection = bugSections[indexPath.section]
            bugSection.bugs.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } else if editingStyle == .insert {
            let bugSection = bugSections[indexPath.section]
            let newBug = ScaryBug(withName: "New Kind", imageName: nil, howScary: bugSection.howScary)
            bugSection.bugs.append(newBug)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return bugSections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let bugSection = bugSections[section]
        return ScaryBug.scaryFactorToString(scaryFactor: bugSection.howScary)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let bugSection = bugSections[section]
        let adjustment = isEditing ? 1 : 0
        return bugSection.bugs.count + adjustment
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BugsCell", for: indexPath)
        let bugSection = bugSections[indexPath.section]
        let bugs = bugSection.bugs
        
        if indexPath.row >= bugs.count && isEditing {
            cell.textLabel?.text = "New Kind Of Bug"
            cell.detailTextLabel?.text = nil
            cell.imageView?.image = nil
            
        } else {
            let bug = bugs[indexPath.row]
            cell.textLabel?.text = bug.name
            cell.detailTextLabel?.text = ScaryBug.scaryFactorToString(scaryFactor: bug.howScary)
            if let bugImage = bug.image {
                cell.imageView?.image = bugImage
            } else {
                cell.imageView?.image = nil
            }
        }
        return cell
    }
}

//MARK: TableView DELEGATE

extension BugsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        let bugSection = bugSections[indexPath.section]
        if indexPath.row >= bugSection.bugs.count && isEditing{
            return .insert
        } else {
            return .delete
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let bugSection = bugSections[indexPath.section]
        if isEditing && indexPath.row < bugSection.bugs.count {
            return nil
        } else {
            return indexPath
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if isEditing{
            self.tableView(tableView, commit: .insert, forRowAt: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        let bugSection = bugSections[indexPath.section]
        if indexPath.row >= bugSection.bugs.count {
            return false
        } else {
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let sourceBugSection = bugSections[sourceIndexPath.section]
        let destinationBugSection = bugSections[destinationIndexPath.section]
        let bugToMove = sourceBugSection.bugs[sourceIndexPath.row]
        
        if destinationBugSection == sourceBugSection {
            if destinationIndexPath.row != sourceIndexPath.row {
                swap(&destinationBugSection.bugs[destinationIndexPath.row], &sourceBugSection.bugs[sourceIndexPath.row])
            }
        } else {
            bugToMove.howScary = destinationBugSection.howScary
            print(bugToMove.howScary)
            destinationBugSection.bugs.insert(bugToMove, at: destinationIndexPath.row)
            sourceBugSection.bugs.remove(at: sourceIndexPath.row)
        }
        
        
        UIView.animate(withDuration: 0.3, animations: {
        }) { (isComplete) in
            let cell = tableView.cellForRow(at: destinationIndexPath)
            cell?.detailTextLabel?.text = ScaryBug.scaryFactorToString(scaryFactor: bugToMove.howScary)
        }
        
    }
}














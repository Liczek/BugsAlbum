//
//  BugSection.swift
//  BugsAlbum
//
//  Created by Paweł Liczmański on 16.05.2017.
//  Copyright © 2017 Paweł Liczmański. All rights reserved.
//

import UIKit

class BugSection: NSObject {
    
    let howScary: ScaryFactor
    var bugs = [ScaryBug]()
    
    init(howScary: ScaryFactor) {
        self.howScary = howScary
    }

}

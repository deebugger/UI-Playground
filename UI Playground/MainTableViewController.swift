//
//  MainTableViewController.swift
//  UI Playground
//
//  Created by Dror Ben-Gai on 30/07/2016.
//  Copyright © 2016 Dror Ben-Gai. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.tableFooterView = UIView()
    }

}

//
//  STListsViewController.swift
//  iOS_Audio
//
//  Created by Apple on 2018/1/15.
//  Copyright © 2018年 zxl. All rights reserved.
//

import UIKit

let cellID = "cellID"


class STListsViewController: UITableViewController {

    deinit {
        print("销毁了")
    }
    
    var dataSource = URL.getAudioAllFiles()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dataSource = URL.getAudioAllFiles()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)

        cell.textLabel?.text = self.dataSource[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = self.dataSource[indexPath.row]
        let playVC = AudioPlayerViewController()
        playVC.name = name
        self.navigationController?.pushViewController(playVC, animated: true)
    }
    
    
//    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        
//    }
}

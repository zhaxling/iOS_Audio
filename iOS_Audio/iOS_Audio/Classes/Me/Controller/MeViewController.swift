//
//  MeViewController.swift
//  iOS_Audio
//
//  Created by Apple on 2018/2/9.
//  Copyright © 2018年 zxl. All rights reserved.
//

import UIKit

class MeViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = ["Internationalization国际化",
                      "User Defaults",
                      "VOIP",
                      "User Defaults",
                      "User Defaults"]
    }
    
    override func config() {
        super.config()
        
        self.navigationTitle = "我的"
        tableView.rowHeight = HEIGHT(50)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MeViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellBaseID, for: indexPath)
        
        if indexPath.row < dataSource.count {
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell.textLabel?.text = dataSource[indexPath.row] as? String
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
            case 0:
                break
            case 1:
                break
            case 2:
                self.navigationController?.pushViewController(VOIPViewController(), animated: true)
                break
            default:
                break
        }
        
    }
}

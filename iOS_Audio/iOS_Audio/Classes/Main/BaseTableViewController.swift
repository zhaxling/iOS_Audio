//
//  BaseTableViewController.swift
//  iOS_Audio
//
//  Created by Apple on 2018/2/9.
//  Copyright © 2018年 zxl. All rights reserved.
//

import UIKit

class BaseTableViewController: BaseViewController {

    let cellBaseID = "cellBaseID"
    let tableView = UITableView(frame: CGRect(x: 0, y: kNavBarH, width: kScreenWidth, height: kScreenHeight - kNavBarH), style: UITableViewStyle.plain)
    var dataSource = Array<Any>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func config() {
        // 父类 本身或者可能被继承的配置(最好不要写子类中不需要的)
        super.config()
        
        // UI
        view.addSubview(tableView)
        tableView.backgroundColor = kBackGroundColor()
        tableView.showsHorizontalScrollIndicator = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = HEIGHT(100)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellBaseID)
        // 设置adjustedContentInset
        self.setContentInsetAdjustmentFalse(scrollView: tableView)
    }
}

extension BaseTableViewController : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellBaseID, for: indexPath)
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

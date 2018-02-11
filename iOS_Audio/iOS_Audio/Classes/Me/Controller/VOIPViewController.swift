//
//  VOIPViewController.swift
//  iOS_Audio
//
//  Created by Apple on 2018/2/10.
//  Copyright © 2018年 zxl. All rights reserved.
//

import UIKit

class VOIPViewController: BaseViewController {

    
    let callManager = CallManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        callManager.callComing()
        callManager.getCarrierInfo();
    }
    
    override func config() {
        super.config()
        
        view.backgroundColor = UIColor.orange
        self.navigationTitle = "VOIP"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

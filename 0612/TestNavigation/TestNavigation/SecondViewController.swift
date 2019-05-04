//
//  SecondViewController.swift
//  TestNavigation
//
//  Created by perkin on 2017/6/12.
//  Copyright © 2017年 perkin. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    deinit
    {
        print("view2被釋放")
    }

}

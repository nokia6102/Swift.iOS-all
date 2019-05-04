//
//  ViewController.swift
//  testAction
//
//  Created by perkin on 2017/7/14.
//  Copyright © 2017年 perkin. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func objectTouched(_ sender: Any)
    {
        if (sender as AnyObject).tag == 0
        {
            let inputStr = (sender as! UITextField).text!
            print("輸入文字：\(inputStr)")
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    
    
}


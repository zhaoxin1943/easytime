//
//  RootViewController.swift
//  EasyTime
//
//  Created by 赵新 on 14-8-14.
//  Copyright (c) 2014年 souche. All rights reserved.
//

import UIKit

class RootViewController:UITabBarController{
    override func shouldAutorotate() -> Bool {
        return false
    }
    override func supportedInterfaceOrientations() -> Int {
        return UIInterfaceOrientation.Portrait.toRaw()
    }
}

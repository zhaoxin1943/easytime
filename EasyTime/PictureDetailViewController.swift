//
//  PictureDetailViewController.swift
//  EasyTime
//
//  Created by 赵新 on 14-8-5.
//  Copyright (c) 2014年 souche. All rights reserved.
//

import UIKit

class PictureDetailViewController:UIViewController{
    
    var index:Int?
    var cache:NSMutableDictionary?
    var picUrls:Array<String>?
    var toolBar:UIToolbar?
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
    @IBAction func onTap(sender: AnyObject) {
        toggleToolbar()
    }
    
    
    override func viewDidLoad() {
        
        let width = view.frame.size.width
        let height = UIScreen.mainScreen().bounds.height
        
        let size = countElements(picUrls!) - 1
        scrollView.frame = CGRectMake(0, 0, width, height)
        scrollView.contentSize = CGSizeMake(CGFloat(size + 1) * width, 0)
        scrollView.bounces = false
        scrollView.alwaysBounceVertical = true
        scrollView.directionalLockEnabled = true
        for i in 0...size{
            var imageView = UIImageView()
            imageView.frame = CGRectMake(CGFloat(i) * width, 0, width, height)
            imageView.image = cache![picUrls![i]] as? UIImage
            imageView.contentMode = UIViewContentMode.ScaleToFill
            
            scrollView.addSubview(imageView)
        }
        scrollView.delaysContentTouches = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.pagingEnabled = true
        scrollView.addGestureRecognizer(tapGesture)
        
        addToolBar()
        
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        navigationController.setNavigationBarHidden(false, animated: false)
        let width = view.frame.size.width
        scrollView.setContentOffset(CGPointMake(CGFloat(index!) * width, 0), animated: false)
    }
    
    func toggleToolbar(){
         toolBar?.hidden = !toolBar!.hidden
    }
    
    func addToolBar(){
        let width = view.frame.size.width
        let height = view.frame.size.height
        toolBar = UIToolbar(frame: CGRectMake(0, height-40, width, 40))
        toolBar!.alpha = CGFloat(0.5)
        toolBar!.autoresizingMask = UIViewAutoresizing.FlexibleTopMargin
        toolBar!.barStyle = UIBarStyle.BlackTranslucent
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        let item = UIBarButtonItem(image: UIImage(named:"cover_down_normal.png"), style: UIBarButtonItemStyle.Bordered, target: self, action: Selector("downLoad"))
        
        toolBar!.setItems([flexibleSpace,item,flexibleSpace], animated: false)
        view.addSubview(toolBar!)
    }

    func downLoad(){
        let width = view.frame.size.width
        var currentIndex = scrollView.contentOffset.x / width
        var image = cache![picUrls![Int(currentIndex)]] as UIImage
        UIImageWriteToSavedPhotosAlbum(image, nil,nil, nil)
        showToast()
    }
    
    func showToast(){
        UIAlertView(title: "保存成功", message: nil, delegate: nil, cancelButtonTitle: "OK").show()
    }
    
}

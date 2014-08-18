//
//  JokeTableViewController.swift
//  EasyTime
//
//  Created by 赵新 on 14-8-12.
//  Copyright (c) 2014年 souche. All rights reserved.
//

import UIKit

class JokeTableViewController:MJTableViewController,UITableViewDataSource,UITableViewDelegate{
    
    var jokes = [NSDictionary]()
    let requestCount = 20
    var index = 1
    var memCache = NSMutableDictionary()
    var progressView:ProgressView?
    
    override func viewDidLoad() {
        var refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新")
        refreshControl.addTarget(self, action:"loadData", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl

        var nib = NSBundle.mainBundle().loadNibNamed("progress", owner: self, options: nil)
        progressView = nib[0] as? ProgressView
        progressView!.activity.hidesWhenStopped = true
        progressView!.activity.startAnimating()
        var tempFrame = self.view.frame

        progressView!.center = CGPointMake(tempFrame.size.width/2, tempFrame.size.height/2-44)
        self.view.addSubview(progressView!)
        
        
        self.tableView.addFooterWithCallback({
            self.loadMoreData()
        })
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        var queue = NSOperationQueue.mainQueue()
        var operation = NSInvocationOperation(target: self, selector: "loadData", object: nil)
        queue.addOperation(operation)
        
    }
    
    override func didReceiveMemoryWarning() {
        memCache.removeAllObjects()
    }
    
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return jokes.count
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell = tableView.dequeueReusableCellWithIdentifier("jokeCell", forIndexPath: indexPath) as JokeTableCell
        var json:NSDictionary = jokes[indexPath.row]
        var content = json.objectForKey("content") as String
        var height = content.stringHeightWith(17,width:300)
        cell.jokeLable.numberOfLines = 0
        cell.jokeLable.setHeight(content.stringHeightWith(17, width: 300))
        cell.jokeLable.text = content
        if getImageUrl(json).length > 0{
            cell.jokeImageView.hidden = false
            cell.jokeImageView.frame.origin.y = bottom(cell.jokeLable) + 8
            cell.jokeImageView.canClick = true
            loadImage(getImageUrl(json), imageView: cell.jokeImageView)

        }else {
            cell.jokeImageView.hidden = true
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    func onTap(sender:UITapGestureRecognizer){
        
        
    }
    
    func bottom(view:UIView)->CGFloat{
        return view.frame.origin.y + view.frame.size.height
    }
    
    func loadImage(picUrl:String,imageView:UIImageView){
        
        var fileName = picUrl.lastPathComponent
        if memCache[fileName] != nil{
            var image = memCache[fileName] as UIImage
            imageView.frame.size = image.size
            imageView.image = image
        }else if FileUtils.imageDataFromPath(fileName) as NSObject != NSNull(){
            var image = FileUtils.imageDataFromPath(fileName) as UIImage
            memCache[fileName] = image
            imageView.frame.size = image.size
            imageView.image = image
        }else{
            imageView.image = nil
            dispatch_async(dispatch_get_main_queue(), {
                var data = NSData(contentsOfURL: NSURL(string: picUrl), options: NSDataReadingOptions.DataReadingMappedIfSafe, error: nil)
                
                var image = UIImage(data: data)
                FileUtils.imageCacheToPath(fileName, image: data)
                self.memCache[fileName] = image
                imageView.frame.size = image.size
                imageView.image = image
            })

        }
        
    }
    
    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        var json:NSDictionary = jokes[indexPath.row]
        var content = json.objectForKey("content") as String
        if getImageUrl(json).length > 0{
            var image_size = json.objectForKey("image_size") as NSDictionary
            var s_size = image_size.objectForKey("s") as NSArray
            var imageHeight = s_size[1] as CGFloat
            return CGFloat(8 + content.stringHeightWith(17, width: 300) + imageHeight + 16)
        }
        return CGFloat(8 + content.stringHeightWith(17, width: 300) + 8)
    }
    
    func getImageUrl(json:NSDictionary)->NSString{
        var id = json.objectForKey("id") as NSString
        var imageUrl:AnyObject? = json["image"]
        if imageUrl as NSObject == NSNull(){
            return ""
        }else{
            var picUrl = "http://pic.moumentei.com/system/pictures/\(id.substringToIndex(4))/\(id)/small/\(imageUrl!)"
            return picUrl
        }
    }
    
    func loadData(){
        
        index = 1
        jokes.removeAll(keepCapacity: false)
        requestNetWork()
        if self.refreshControl.refreshing{
            self.refreshControl.endRefreshing()
        }
        if progressView != nil{
            progressView?.activity.stopAnimating()
            progressView?.removeFromSuperview()
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
            progressView = nil
        }
        
        tableView.reloadData()
    }
    
    func requestNetWork(){
        var url = "http://m2.qiushibaike.com/article/list/suggest?count=\(self.requestCount)&page=\(self.index)"
        var data = NSData(contentsOfURL: NSURL(string: url))
        var items:AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil)
        var itemArray = items.objectForKey("items") as NSArray
        var size = itemArray.count - 1
        for i in 0...size{
            self.jokes.append(itemArray[i] as NSDictionary)
        }

    }
    
    func loadMoreData(){
        index++
        requestNetWork()
        self.tableView.footerEndRefreshing()
        self.tableView.reloadData()
    }
    
}

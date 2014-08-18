//
//  SecondViewController.swift
//  EasyTime
//
//  Created by 赵新 on 14-8-5.
//  Copyright (c) 2014年 souche. All rights reserved.
//

import UIKit

class PictureViewController: MJCollectionViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    
    var picUrls=[String]()
    var cache:NSMutableDictionary=NSMutableDictionary()
    var index = 0
    let count = 20
    let keyWord = "%E7%BE%8E%E5%A5%B3"
    let keyWord2 = "%E6%A0%A1%E8%8A%B1"
    var progressView:ProgressView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.addFooterWithCallback { () -> Void in
            self.loadData(true)
            self.collectionView.footerEndRefreshing()
            self.collectionView.reloadData()
        }
        self.collectionView.addHeaderWithCallback({
            self.loadData(false)
            self.collectionView.headerEndRefreshing()
            self.collectionView.reloadData()
        })
        
        var nib = NSBundle.mainBundle().loadNibNamed("progress", owner: self, options: nil)
        progressView = nib[0] as? ProgressView
        progressView!.activity.hidesWhenStopped = true
        progressView!.activity.startAnimating()
        var tempFrame = self.view.frame
        
        progressView!.center = CGPointMake(tempFrame.size.width/2, tempFrame.size.height/2-44)
        self.view.addSubview(progressView!)

        var queue = NSOperationQueue.mainQueue()
        var operation = NSInvocationOperation(target: self, selector: "loadData:", object: false)
        queue.addOperation(operation)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        cache.removeAllObjects()
    }
    
       
    override func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("picCell", forIndexPath: indexPath) as GridCell
        var url = picUrls[indexPath.row]
        if(cache[url]){
            cell.imageView.image = cache[url] as UIImage
        }else{
            cell.imageView.image = nil
            cell.indicator.hidesWhenStopped = true
            cell.indicator.startAnimating()
            var request = NSURLRequest(URL: NSURL(string: url), cachePolicy: NSURLRequestCachePolicy.ReloadRevalidatingCacheData, timeoutInterval: 30)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response:NSURLResponse!, data:NSData!, error:NSError!) -> Void in
                cell.indicator.stopAnimating()
                if(data != nil){
                    var tempImage = UIImage(data: data)
                    self.cache[url] = tempImage
                    cell.imageView.image = tempImage
                }else{
                    cell.imageView.image=UIImage(named: "default.jpg")
                }
                }
            )
            
        }
        return cell;
    }
    
    override func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
        return picUrls.count
    }
    
    
    func loadData(isLoadMore:Bool){
        NSLog("loadData \(isLoadMore)")
        if !isLoadMore{
            index = 0
            picUrls.removeAll(keepCapacity: false)
        }
        var url="http://image.baidu.com/channel/listjson?pn=\(index)&rn=\(count)&tag1=\(keyWord)&tag2=\(keyWord2)&ie=utf8"
        var data=NSData.dataWithContentsOfURL(NSURL(string: url), options: NSDataReadingOptions.DataReadingMappedIfSafe, error: nil)
        var json:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        var dataArray:NSArray = json.objectForKey("data") as NSArray
        let size = dataArray.count - 2
        for i in 0...size{
            var picUrl = dataArray[i].objectForKey("image_url") as String
            picUrls.append(picUrl)
        }
        if isLoadMore{
            index++
        }
        if progressView != nil{
            progressView?.activity.stopAnimating()
            progressView?.removeFromSuperview()
            progressView = nil
        }
        collectionView.reloadData()
    }
    
    override func collectionView(collectionView: UICollectionView!, didSelectItemAtIndexPath indexPath: NSIndexPath!) {
        self.performSegueWithIdentifier("pictureDetail", sender: indexPath)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        var detailViewController = segue!.destinationViewController as PictureDetailViewController
        var indexPath = sender as NSIndexPath
        detailViewController.index = indexPath.row
        detailViewController.cache = cache
        detailViewController.picUrls = picUrls
        
    }
    
}


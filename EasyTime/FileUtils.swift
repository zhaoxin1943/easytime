//
//  FileUtils.swift
//  EasyTime
//
//  Created by 赵新 on 14-8-12.
//  Copyright (c) 2014年 souche. All rights reserved.
//

import Foundation
import UIKit

class FileUtils{
    class func cachePath(fileName:String)->String{
        var array = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        var path = array[0] as String
        return "\(path)/imageCache\(fileName)"
    }
    
    class func imageCacheToPath(path:String,image:NSData)->Bool{
        return image.writeToFile(path, atomically: true)
    }
    
    class func imageDataFromPath(path:String)->AnyObject{
        var exist = NSFileManager.defaultManager().fileExistsAtPath(path)
        if exist
        {
            return  UIImage(contentsOfFile: path)
        }
        
        return NSNull()

    }
}

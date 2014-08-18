// Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"


var url = "http://m2.qiushibaike.com/article/list/suggest?count=20&page=1"
var data = NSData(contentsOfURL: NSURL(string: url))
var items:AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil)
var itemArray = items.objectForKey("items") as NSArray

var json:NSDictionary = itemArray[0] as NSDictionary
var content  = json.objectForKey("content") as String

var id = json.objectForKey("id") as NSString
var imageUrl:AnyObject? = json.objectForKey("image")
if imageUrl is NSNull{
    var picUrl = "http://pic.moumentei.com/system/pictures/\(id.substringToIndex(4))/\(id)/small/\(imageUrl)"
}


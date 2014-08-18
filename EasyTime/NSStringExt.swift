//
//  NSStringExt.swift
//  EasyTime
//
//  Created by 赵新 on 14-8-12.
//  Copyright (c) 2014年 souche. All rights reserved.
//

import Foundation
import UIKit

extension String{
    func stringHeightWith(fontSize:CGFloat,width:CGFloat)->CGFloat{
        var font = UIFont.systemFontOfSize(fontSize)
        var size = CGSizeMake(width,CGFloat.max)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .ByWordWrapping;
        var  attributes = [NSFontAttributeName:font,
            NSParagraphStyleAttributeName:paragraphStyle.copy()]
        
        var text = self as NSString
        var rect = text.boundingRectWithSize(size, options:.UsesLineFragmentOrigin, attributes: attributes, context:nil)
        return rect.size.height
    }
}

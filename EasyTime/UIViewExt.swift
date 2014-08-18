//
//  UIViewExt.swift
//  EasyTime
//
//  Created by 赵新 on 14-8-12.
//  Copyright (c) 2014年 souche. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    func contentSizeOfTextView(){
         var textViewSize = self.sizeThatFits(CGSizeMake(self.frame.size.width, CGFloat(FLT_MAX)))
         self.frame.size = textViewSize
    }
    
    
    func setHeight(height: CGFloat)
    {
        var rect:CGRect = self.frame
        rect.size.height = height
        self.frame = rect
    }

}

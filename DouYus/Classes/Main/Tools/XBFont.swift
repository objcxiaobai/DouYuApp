//
//  XBFont.swift
//  DouYus
//
//  Created by 冼 on 2018/9/27.
//  Copyright © 2018年 Null. All rights reserved.
//

import UIKit

// 常规字体
func FontSize(_ size : CGFloat) -> UIFont {
    
    return UIFont.systemFont(ofSize: AdaptW(size))
}

// 加粗字体
func BoldFontSize(_ size : CGFloat) -> UIFont {
    
    return UIFont.boldSystemFont(ofSize: AdaptW(size))
}

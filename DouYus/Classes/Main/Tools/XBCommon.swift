//
//  XBCommon.swift
//  DouYus
//
//  Created by 冼 on 2018/9/26.
//  Copyright © 2018年 Null. All rights reserved.
//

import UIKit
import SnapKit
let kScreenW = UIScreen.main.bounds.size.width
let kScreenH = UIScreen.main.bounds.size.height
// 宽度比
let kWidthRatio = kScreenW / 375.0
// 高度比
let kHeightRatio = kScreenH / 667.0

// 自适应
func Adapt(_ value : CGFloat) -> CGFloat {
    
    return AdaptW(value)
}

// 自适应宽度
func AdaptW(_ value : CGFloat) -> CGFloat {
    
    return ceil(value) * kWidthRatio
}

// 自适应高度
func AdaptH(_ value : CGFloat) -> CGFloat {
    
    return ceil(value) * kHeightRatio
}
// 状态栏高度
// 判断是否为 iPhone X
let isIphoneX = kScreenH >= 812 ? true : false
let kStatuHeight : CGFloat = isIphoneX ? 44 : 20
// 导航栏高度
let kNavigationBarHeight :CGFloat = 44

// TabBar高度
let kCateTitleH : CGFloat = 42
let kTabBarHeight : CGFloat = isIphoneX ? 49 + 34 : 49
let CateItemHeight = kScreenW / 4


func getloadingImages() -> [UIImage] {
    var loadingImages = [UIImage]()
    for index in 0...14 {
        let loadImageName = String(format: "dyla_ima_loading_%03d", index)
        if let loadImage = UIImage(named: loadImageName){
            loadingImages.append(loadImage)
        }
        
    }
    
    return loadingImages
    
}


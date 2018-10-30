//
//  XBBaseCollectionCell.swift
//  DouYus
//
//  Created by 冼 on 2018/10/24.
//  Copyright © 2018 Null. All rights reserved.
//

import UIKit

class XBBaseCollectionCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = kWhite
        xb_initWithView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //给子类重写
    public func xb_initWithView(){
        
    }
    
    public class func itemHeight() -> CGSize{
        return CGSize(width: 0.0, height: 0.0)
    }
    
    public class func itemHeightWithModel(model : Any) -> CGSize{
        return CGSize(width: 0.0, height: 0.0)
    }
    
    //获取当前的类对象
    public class func identifier() -> String{
        
        let name: AnyClass! = object_getClass(self)
        return NSStringFromClass(name)
    }
    
    
    
}

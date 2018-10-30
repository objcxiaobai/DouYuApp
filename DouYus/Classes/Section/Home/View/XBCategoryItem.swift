//
//  XBCategoryItem.swift
//  DouYus
//
//  Created by 冼 on 2018/10/24.
//  Copyright © 2018 Null. All rights reserved.
//

import UIKit

class XBCategoryItem: XBBaseCollectionCell {
    
    var model : XBRecomCateList?{
        didSet{
            titleLab.text = model?.cate2_name
            icon.zj_setImage(urlStr: model?.square_icon_url ?? "", placeholder: UIImage(named: "home_column_more"))
        }
    }
    
    
    
    private lazy var icon : UIImageView = {
        let icon = UIImageView()
        return icon
    }()
    
    private lazy var titleLab : UILabel = {
        let titleLab = UILabel()
        titleLab.textColor = kGrayTextColor
        titleLab.font = FontSize(12)
        titleLab.backgroundColor = kWhite
        titleLab.textAlignment = .center
        return titleLab
    }()
    
    
    
    override func xb_initWithView() {
        setUpAllView()
    }
}

extension XBCategoryItem{
    
    private func setUpAllView(){
        addSubview(icon)
        addSubview(titleLab)
        
        icon.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(60)
        }
        
        titleLab.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.bottom.equalTo(-10)
            make.left.equalTo(3)
            make.right.equalTo(-3)
        }
        
    }
    
}

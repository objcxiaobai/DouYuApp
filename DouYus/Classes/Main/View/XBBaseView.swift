//
//  XBBaseView.swift
//  DouYus
//
//  Created by 冼 on 2018/10/30.
//  Copyright © 2018 Null. All rights reserved.
//

import UIKit

class XBBaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = kWhite
        // 配置所有子视图
        xb_initWithAllView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func xb_initWithAllView() {
        
    }

}

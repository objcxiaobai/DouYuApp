//
//  XBCollectionReusableView.swift
//  DouYus
//
//  Created by 冼 on 2018/10/29.
//  Copyright © 2018 Null. All rights reserved.
//

import UIKit

class XBCollectionReusableView: UICollectionReusableView {
    lazy var titleLab = UILabel()
    lazy var topLine : UIView = UIView()
    lazy var botLine : UIView = UIView()
    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setUpVIew()
        backgroundColor = kWhite
    }
    
    func configTitle(title : String){
        titleLab.text = title
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension XBCollectionReusableView{
    private func setUpVIew(){
        
        topLine = UIView.xb_createView(bgClor: klineColor, supView: self, closure: { (make) in
            
            make.left.right.top.equalTo(0)
            make.height.equalTo(0.6)
            
        })
        
        titleLab = UILabel.xb_createLabel(text: "", textColor: kMainTextColor, font: BoldFontSize(16), supView: self, closure: { (make) in
            
            make.centerY.equalTo(self.snp.centerY)
            make.left.equalTo(Adapt(15))
        })
        
        botLine = UIView.xb_createView(bgClor: klineColor, supView: self, closure: { (make) in
            
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(0.6)
        })
        
    }
}

//
//  XBHomeSearchView.swift
//  DouYus
//
//  Created by 冼 on 2018/9/27.
//  Copyright © 2018年 Null. All rights reserved.
//

import UIKit

class XBHomeSearchView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpChildView()
    }
    
    /*这个叫必要初始化器，这种情况一般会出现在继承了遵守NSCoding protocol的类，比如UIView系列的类、UIViewController系列的类。
     
*/
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpChildView(){
        self.addSubview(textField)
        self.addSubview(searchIcon)
        self.addSubview(QcodeIcon)
        
        textField.snp.makeConstraints{
            (make) in
            make.left.equalTo(self).offset(AdaptW(35))
            make.right.equalTo(self).offset(AdaptW(-35))
            make.height.equalTo(30)
            make.center.equalTo(self.snp.center)
        }
        searchIcon.snp.makeConstraints {
            (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(5)
            make.width.height.equalTo(AdaptW(30))
            
        }
        
        QcodeIcon.snp.makeConstraints {
            (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(AdaptW(-5))
            make.width.height.equalTo(AdaptW(30))
        }
        
        
    }
    
    //懒加载
    lazy var textField : UITextField = {
       () -> UITextField in
        let textField = UITextField()
        textField.backgroundColor = UIColor.clear
        textField.borderStyle = .none
        textField.font = FontSize(14)
        textField.textColor = kWhite
        textField.placeholder = "请输入搜索内容"
        
        textField.setValue(FontSize(14), forKeyPath: "_placeholderLabel.font")
        textField.setValue(colorWithRGBA(100, 100, 100, 0.5), forKeyPath: "_placeholderLabel.textColor")
        return textField
    }()
    
    var searchIcon : UIImageView = {
        
        () -> UIImageView in
        let searchIcon = UIImageView()
        searchIcon.image = UIImage(named: "home_newSeacrhcon")
        searchIcon.contentMode = .center
        return searchIcon
        
    }()
    
    var QcodeIcon : UIImageView = {
        () -> UIImageView in
        let QcodeIcon = UIImageView()
        QcodeIcon.image = UIImage(named: "home_newSaoicon")
        QcodeIcon.contentMode = .center
        return QcodeIcon
    }()
    
    
    
    

    
}

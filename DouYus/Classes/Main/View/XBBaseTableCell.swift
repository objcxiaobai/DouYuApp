//
//  XBBaseTableCell.swift
//  DouYus
//
//  Created by 冼 on 2018/10/24.
//  Copyright © 2018 Null. All rights reserved.
//

import UIKit

class XBBaseTableCell: UITableViewCell {

    //重写父类的初始化方法
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.accessoryType = .none
        self.contentView.backgroundColor = kWhite
        
        xb_initWithView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //自定义配置子控件
    public func xb_initWithView(){
        
    }
    
    //自动计算Cell高度
    public class func cellHeight() -> CGFloat{
        
        return UITableView.automaticDimension
    }
    
    //根据Model计算高度
    public class func cellHeightWithModel(model : Any) -> CGFloat{
        return UITableView.automaticDimension
    }
    
    //获取类对象
    public class func identifier() -> String{
        let name : AnyClass! = object_getClass(self)
        
        return NSStringFromClass(name);
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

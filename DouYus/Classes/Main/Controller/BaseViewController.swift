//
//  BaseViewController.swift
//  DouYus
//
//  Created by 冼 on 2018/9/26.
//  Copyright © 2018年 Null. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    // 状态栏的背景色
    lazy var statuView : UIView = {
        let view = UIView();
        view.backgroundColor = kMainOrangeColor;
        view.frame = CGRect(x: 0, y: 0, width: kScreenW, height: 20)
        
        // 设置背景渐变
        let graditntLayer: CAGradientLayer = CAGradientLayer();
        graditntLayer.colors = kGradientColors;
        //(这里的起始和终止位置就是按照坐标系,四个角分别是左上(0,0),左下(0,1),右上(1,0),右下(1,1))
        //渲染的起始位置
        graditntLayer.startPoint = CGPoint.init(x: 0, y: 0)
        //渲染的终止位置
        graditntLayer.endPoint = CGPoint.init(x: 1, y: 0)

        //设置frame和插入view的layer
        graditntLayer.frame = view.frame;
        view.layer.insertSublayer(graditntLayer, at: 0);


        return view
    }()
    
    // 配置 NavigationBar
    func setUpNavigation() -> Void{
        
        //应用于导航栏背景的颜色。
        //默认情况下，除非将isTranslucent属性设置为false，否则此颜色为半透明。
        self.navigationController?.navigationBar.barTintColor = kMainOrangeColor
        //应用于导航项和栏按钮项的颜色。
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "btn_user_normal"), style: .done, target: self, action: nil);
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "viewHistoryIcon"), style: .done, target: self, action: nil);
        //搜索栏:
        let searchView = XBHomeSearchView()
        searchView.layer.cornerRadius = 5
        searchView.backgroundColor = kSearchBGColor
        
        navigationItem.titleView = searchView
        
        /*自定义视图可以包含按钮。
         自定义标题视图位于导航栏的中心，可以根据需要调整大小。
         */
        searchView.snp.makeConstraints {
            (make) in
            make.center.equalTo((navigationItem.titleView?.snp.center)!)
            make.width.equalTo(AdaptW(230))
            make.height.equalTo(33)
        }
        
    }

//    override func viewDidLoad() {
//        //不然颜色显示不出来
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        //状态栏
//        view.addSubview(statuView)
//        
//        setUpNavigation()
//
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

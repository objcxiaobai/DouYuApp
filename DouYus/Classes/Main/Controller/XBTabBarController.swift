//
//  XBTabBarController.swift
//  DouYus
//
//  Created by 冼 on 2018/9/26.
//  Copyright © 2018年 Null. All rights reserved.
//

import UIKit

class XBTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpAllViewControllers();
        //设置 tabBar 工具栏字体颜色 (未选中  和  选中)
        
        // 设置图片和文字选中时的颜色   必须设置（系统默认选中蓝色）
        self.tabBar.tintColor = UIColor.orange;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //添加所有控制器
    func setUpAllViewControllers() ->Void{
        
        setUpAllChildControllers(HomeViewController(),"推荐","tabLive","tabLiveHL");
        setUpAllChildControllers(RecreationController(),"娱乐","tabYule","tabYuleHL");
        setUpAllChildControllers(FollowController(),"关注","tabFocus","tabFocusHL");
        setUpAllChildControllers(FishBarController(),"鱼吧","tabYuba","tabYubaHL");
        setUpAllChildControllers(DiscoverController(),"发现","tabDiscovery","tabDiscoveryHL");


    }
    
    //初始化所有的子控制器：
    private func setUpAllChildControllers(_ controller : UIViewController,_ title : String, _ norImage :String,_ selectedImage : String){
        
        //修改tabBar标题
        controller.tabBarItem.title = title;
        controller.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -3);
        controller.tabBarItem.image = UIImage(named: norImage);
        controller.tabBarItem.selectedImage = UIImage(named: selectedImage);
        /* 个人感觉此处有问题*/
        let nav = XBNavigaController(rootViewController: controller);
        //导航栏标题
        controller.title = title;
        //添加到tabbar控制器容器中
        self.addChildViewController(nav);
        
    }
    
}

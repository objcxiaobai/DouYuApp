//
//  HomeViewController.swift
//  DouYus
//
//  Created by 冼 on 2018/9/26.
//  Copyright © 2018年 Null. All rights reserved.
//

import UIKit
// 记录导航栏是否隐藏
private var isNavHidden : Bool = false

class HomeViewController: BaseViewController {
    
    //标题数组
    private lazy var titles : [String] = ["分类","推荐","全部","LOL","绝地求生","王者荣耀","QQ飞车"]
    // 控制器数组
    private lazy var controllers : [UIViewController] = {
        
        let controllers = [ClassifyController(),RecommendController(),AllViewController(),LoLViewController(),JDQSViewController(),WZRYViewController(),QQCarViewController()]
        
        return controllers
    }()
    
    //标题View
    private lazy var pageTitleView : XBPageTitleView = {
        
        [weak self] in
        let frame = CGRect(x: 0, y: 0, width: kScreenW, height: kCateTitleH)
        
        let option = XBPageOptions()
        
        option.kGradColors = kGradientColors

        option.kBotLineColor = kWhite
        //普通状态颜色
        option.kNormalColor = (220,220,220)
        //选择状态的颜色
        option.kSelectColor = (250,250,250)
        //字体大小
        option.kTitleSelectFontSize = 14
        
        option.isShowBottomLine = false
        
        option.kIsShowBottomBorderLine = true
        
        let pageTitleViw = XBPageTitleView(frame: frame, titles: titles, options: option)
       //所以weak self
        pageTitleViw.delegate = self        
        return pageTitleViw
        
    }()
    
    //内容 View
    private lazy var pageContenView : XBPageContentView = {
        [weak self] in
        let height : CGFloat = kScreenH - kStatuHeight - kNavigationBarHeight - kCateTitleH - kTabBarHeight
        
        let frame = CGRect(x: 0, y: kCateTitleH, width: kScreenW, height: height)
        
        let contentView = XBPageContentView(frame: frame, childVCs: controllers, parentViewController: self!)
        
        contentView.delegate = self
        return contentView;
        
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpAllView()
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshNavBar), name: NSNotification.Name(rawValue: XBNotiRefreshHomeNavBar), object: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    // MARK: 导航栏隐藏与显示
    @objc func refreshNavBar(noti:Notification) {

        let isHidden : String = noti.userInfo!["isHidden"] as! String

        if isHidden == "true" {
            if isNavHidden {return}
            isNavHidden = true
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            UIView.animate(withDuration: 0.15) {
                self.pageTitleView.frame = CGRect(x: 0, y:kStatuHeight, width: kScreenW,height: kCateTitleH)
                let height : CGFloat = kScreenH - kStatuHeight - kCateTitleH - kTabBarHeight

                let frame = CGRect(x: 0, y: kCateTitleH+kStatuHeight, width: kScreenW, height: height)
                self.pageContenView.frame = frame
            self.pageContenView.refreshColllectionView(height:self.pageContenView.frame.size.height)



            }
        }
        else{
            if !isNavHidden{return}
            isNavHidden = false
            self.navigationController?.setToolbarHidden(false, animated: true)
            UIView.animate(withDuration: 0.5) {
                self.pageContenView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: kCateTitleH)
                let height : CGFloat = kScreenH - kStatuHeight - kNavigationBarHeight - kCateTitleH - kTabBarHeight
                let frame = CGRect(x: 0, y: kCateTitleH, width: kScreenW, height: height)
                
                self.pageContenView.frame = frame
                
            }
            
        }



    }


}
//MARK -配置子控件
extension HomeViewController{
    
    //配置UI
    func setUpAllView(){
        
        //调整scrollview的距离
        self.edgesForExtendedLayout = []

        //不然颜色显示不出来
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        //状态栏
        view.addSubview(statuView)
        
        //添加导航栏
        setUpNavigation()
        
        
        setUpPageTitleAndContenView()
    }
    
    func setUpPageTitleAndContenView(){
        view.addSubview(pageTitleView)
        
        view.addSubview(pageContenView)
    }
    
    
}
// MARK: - 遵守PageTitleViewDelegate,PageContentViewDelegate协议
extension HomeViewController : PageTitleViewDelegate,XBPageContentViewDelegate{
    //滚动菜单的下标，选择内容的下标进行切换
    func pageTitleView(titleView: XBPageTitleView, selectedIndex index: Int) {
        
        pageContenView.setCurrentIndex(currentIndex: index)
    }
    
    //内容代理方法，与标题进行联动切换
    func xb_pageContentView(contentView: XBPageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        
        pageTitleView.setPageTitleWithProgress(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
        
    }
    
    
}

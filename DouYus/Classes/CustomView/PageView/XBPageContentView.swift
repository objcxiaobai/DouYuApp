//
//  XBPageContentView.swift
//  DouYus
//
//  Created by 冼 on 2018/10/16.
//  Copyright © 2018 Null. All rights reserved.
//

import UIKit

//配合PageTitleViewDelegate代理方法进行实现
protocol XBPageContentViewDelegate : class {
    
    func xb_pageContentView(contentView : XBPageContentView,progress : CGFloat , sourceIndex : Int,targetIndex : Int)
    
}

// 自定义数据源协议 ,必须实现 zj_pageControlViewDataScoure 方法
@objc protocol XBPageConrolViewDataScoure : class{
    
    @objc func xb_pageControlViewDataScoure(contentView: XBPageContentView,cellForItemAt IndexPath: IndexPath) -> XBBaseCollectionViewCell
    
}

//指定全局cellid
private let ContentCellID = "ContentCellID"



class XBPageContentView: UIView {

    // 代理协议
    weak var delegate : XBPageContentViewDelegate?
    // 自定义数据源协议
    weak var dataScoure : XBPageConrolViewDataScoure?
    // 禁止点击的时候走代理的方法，如果不这样做的话，有可能冲突，有时候点标题切换不了。
    private var isForbidScrollDelegate : Bool = false
    // 滑动偏移量
    private var startOffSetX : CGFloat = 0
    
    //控制器数组
    private var childVCs : [UIViewController]
    //父控制器 weak修饰，防止循环引用
    private weak var parentViewController : UIViewController?
    
    private lazy var layout : UICollectionViewFlowLayout = {
        
        //
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self.bounds.size)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        return layout;
        
        
    }()
    
    //collectionView 容器
    private lazy var collectionView : UICollectionView = {
        [weak self] in
       
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.backgroundColor = kWhite
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ContentCellID)
        
        return collectionView
        
    }()
    
    
    //进行下来更新
    func refreshColllectionView(height:CGFloat){
        
        collectionView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: height)
        layout.itemSize = collectionView.frame.size
    }
    
    
    
    //构造器
    init(frame : CGRect, childVCs : [UIViewController],parentViewController : UIViewController?) {
        self.childVCs = childVCs
        self.parentViewController = parentViewController
        super.init(frame:frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - 对外暴露方法
extension XBPageContentView{
    
    // 切换控制器
    func setCurrentIndex(currentIndex : Int){
        // 记录是否需要禁止执行的代理方法

        isForbidScrollDelegate = true
        // 滚到正确的位置
        let offSetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offSetX, y: 0), animated: false)

    }
    
    
}


//设置UI扩展
extension XBPageContentView{
    
    private func setUpView(){
        // 将所有的子控制器添加到父控制器中
        for childVC in childVCs {
            //当将子视图控制器的视图嵌入到当前视图控制器的内容中时，这种关系是必要的。如果新的子视图控制器已经是容器视图控制器的子视图控制器，则在添加前将其从容器中删除。
            self.parentViewController?.addChildViewController(childVC)
        }
        
        addSubview(collectionView)
        
        collectionView.frame = bounds
        
        
    }
    
    
}
//设置UI代理协议数据源
//将要显示的时候就加载
extension XBPageContentView : UICollectionViewDataSource,UICollectionViewDelegate{
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVCs.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        /**数据源 **/
        if (dataScoure != nil) {
            // 自定义 cell 继承 ZJBasePageControlCell
            let item = dataScoure?.xb_pageControlViewDataScoure(contentView: self, cellForItemAt: indexPath)
            return item!
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCellID, for: indexPath)
        
        
        let childVC = childVCs[indexPath.item]
        
        childVC.view.frame = cell.contentView.bounds
        
        cell.contentView.addSubview(childVC.view)
        cell.backgroundColor = kWhite
        
        return cell
        
    }
    
    /**
     isForbidScrollDelegate是配合
     标题进行切换的,
     **/
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        
        //记录是否需要禁止执行的代理方法：
        isForbidScrollDelegate = false
        
        startOffSetX = scrollView.contentOffset.x
        
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        if isForbidScrollDelegate {
            return
        }
        
        //获取需要的数据资源
        var progress : CGFloat = 0
        //
        var sourceIndex : Int = 0
        //目标下标
        var targetIndex : Int = 0
        
        
        //判断左滑还是右滑
        let currentOffSetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        
        if currentOffSetX > startOffSetX {
            
            //左滑
            // 1.计算 progress
            progress = currentOffSetX / scrollViewW - floor(currentOffSetX / scrollViewW)
            // 2.计算 sourceIndex
            sourceIndex = Int(currentOffSetX / scrollViewW)
            // 3.计算 targetIndex
            targetIndex = sourceIndex + 1
            
            if targetIndex >= childVCs.count{
                targetIndex = childVCs.count - 1
            }
            
            // 4. 如果完全划过去了, progress = 1
            if currentOffSetX - startOffSetX == scrollViewW{
                progress = 1
                targetIndex = sourceIndex
            }
                
            }
        else{
                //右滑
            // 计算 progress
                progress = 1 - (currentOffSetX / scrollViewW - floor(currentOffSetX / scrollViewW))
            // 2.计算 targetIndex
                targetIndex = Int(currentOffSetX / scrollViewW)
            // 3.计算 sourceIndex
                sourceIndex = targetIndex + 1
                
                if sourceIndex >= childVCs.count{
                    sourceIndex = childVCs.count - 1
                    
                }
                
                
            }
            
        delegate?.xb_pageContentView(contentView: self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
            
        }
    
}


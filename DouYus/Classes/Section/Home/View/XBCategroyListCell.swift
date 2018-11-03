//
//  XBCategroyListCell.swift
//  DouYus
//
//  Created by 冼 on 2018/10/24.
//  Copyright © 2018 Null. All rights reserved.
//

import UIKit

class XBCategroyListCell: XBBaseTableCell {

    var cateTwoList : [XBRecomCateList]? {
        didSet{
            collectionView.reloadData()
        }
    }
    
    
    
    private lazy var  pageControl : UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = colorWithRGBA(236, 236, 236, 1.0)
        pageControl.currentPageIndicatorTintColor = colorWithRGBA(212, 212, 212, 1.0)
        return pageControl
        
    }()
    
    private lazy var layout : UICollectionViewFlowLayout = {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        //横向
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    private lazy var collectionView : UICollectionView = {
        
        let collectionView = UICollectionView(frame: CGRect.zero,collectionViewLayout: layout)
        collectionView.backgroundColor = kWhite
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(XBCategoryScrollitem.self, forCellWithReuseIdentifier: XBCategoryScrollitem.identifier())
        //分页
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        /**
         如果该属性的值为true，当滚动视图遇到内容边界时就会反弹。在视觉上跳跃表示滚动已经到达了内容的边缘。如果值为false，滚动将立即停止在内容边界，而不会反弹。默认值为true。
         */
        collectionView.bounces = false
        return collectionView
    }()
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //重写父类的方法
    override func xb_initWithView() {
        
        setUpAllView()
        layout.itemSize = CGSize(width: kScreenW, height: CateItemHeight * 2.0)
        pageControl.numberOfPages = 8

    }
    
    

}

//设置UI
extension XBCategroyListCell{
    
    private func setUpAllView(){
        addSubview(collectionView)
        addSubview(pageControl)
        collectionView.snp.makeConstraints { (make) in
            
            make.top.left.right.equalTo(0)
            make.height.equalTo(CateItemHeight * 2)
        }
        pageControl.snp.makeConstraints { (make) in
            make.top.equalTo(collectionView.snp.bottom)
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(150)
            make.height.equalTo(37)
        }
        
        
    }
    
}
//设置代理源
extension XBCategroyListCell : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if cateTwoList == nil{ return 0 }
        
        let pageNum = (cateTwoList!.count - 1) / 8 + 1
        pageControl.numberOfPages = pageNum
        
        if pageNum <= 1 {
            pageControl.isHidden = true
        }else{
            pageControl.isHidden = false
        }
        return pageNum
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: XBCategoryScrollitem.identifier(), for: indexPath) as! XBCategoryScrollitem
        
        let startIndex = indexPath.item * 8
        var endIndex = (indexPath.item + 1) * 8 - 1
        if endIndex > cateTwoList!.count - 1 {
            endIndex = cateTwoList!.count - 1
        }
        if (self.cateTwoList?.count)! > 0  {
            cell.dataArr = Array(cateTwoList![startIndex...endIndex])
        }

        
        return cell
        
    }
}

extension XBCategroyListCell : UICollectionViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.width + 0.5)
    }
}

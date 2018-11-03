//
//  XBCategoryScrollitem.swift
//  DouYus
//
//  Created by 冼 on 2018/10/24.
//  Copyright © 2018 Null. All rights reserved.
//

import UIKit
private let itemWH : CGFloat = kScreenW / 4

class XBCategoryScrollitem: XBBaseCollectionCell {
    var dataArr : [XBRecomCateList]?{
        didSet{
            collectionView.reloadData()
        }
    }
    
    
    
    private lazy var collectionView : UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width:itemWH , height: itemWH)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = kWhite
        collectionView.delegate = self
        collectionView.dataSource = self
        //自定义item
        collectionView.register(XBCategoryItem.self, forCellWithReuseIdentifier: XBCategoryItem.identifier())
        collectionView.isScrollEnabled = false
        return collectionView
        
    }()
    //重写父类的方法
    override func xb_initWithView() {
        addSubview(collectionView)
    }
}

extension XBCategoryScrollitem : UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataArr?.count ?? 0;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: XBCategoryItem.identifier(), for: indexPath) as!XBCategoryItem
        cell.contentView.layer.borderColor = klineColor.cgColor
        cell.contentView.layer.borderWidth = 0.5
        
        //model数据
        cell.model = dataArr?[indexPath.row]
        
        return cell
    }
    
    
}

//
//  ClassifyController.swift
//  DouYus
//
//  Created by 冼 on 2018/10/8.
//  Copyright © 2018 Null. All rights reserved.
//

import UIKit
import SwiftyJSON
import ESPullToRefresh
private let itemWH = kScreenW / 4
class ClassifyController: BaseViewController {

    //解析
    var cateOneList : Array<JSON> = []
    
    private var recommenCateData : XBRecomCateData?
    
    private var cateListData : [XBCateOneData] = [XBCateOneData]()
   
    /**-----------------------------**/
    private lazy var mainTable : UITableView = {
       
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH-kStatuHeight-kTabBarHeight-kNavigationBarHeight), style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        tableView.sectionFooterHeight = 0
        tableView.backgroundColor = kWhite
        tableView.register(XBCategroyListCell.self, forCellReuseIdentifier: XBCategroyListCell.identifier())
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = kWhite;
        setUpAllView()
        loadCateListData()
        
        XBProgressHUD.showProgress(supView: self.view, bgFrame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH - kStatuHeight - kTabBarHeight-kNavigationBarHeight), imagArr: getloadingImages(), timeMilliseconds: 90, bgCOlor: kWhite, scale: 0.8)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSetY = scrollView.contentOffset.y
        if offSetY > 120 {
            
        }else{
            
            
        }
        
    }
    

}
// - 获取分类页数据
extension ClassifyController{
    private func loadCateListData(){
        
       // 初始化信号量为1
        let semaphoreA = DispatchSemaphore(value: 1)
        let semaphoreB = DispatchSemaphore(value: 0)
        let semaphoreC = DispatchSemaphore(value: 0)
        
        
        let queue = DispatchQueue(label: "com.douyus.cate1.queue",qos: .utility, attributes: .concurrent)
        
        
        queue.async {
            semaphoreA.signal()
            
            XBNetWorkProvider.shared.requestDataWithTargetJSON(target: HomeAPI.liveCateList, successClosure: { (response) in
                guard let jsonDict = response.dictionaryObject else{
                    semaphoreB.signal()
                    return
                }
                //字典转模型
                let allData : XBCateAllData = XBCateAllData(JSON:jsonDict)!
                self.cateListData = allData.cate1_list
                semaphoreB.signal()
                
                
                
            }, failClosure: { _ in
                semaphoreB.signal()
            })
            
        }
        
        queue.async {
            semaphoreB.wait()
            
            XBNetWorkProvider.shared.requestDataWithTargetJSON(target: HomeAPI.recommendCategoryList, successClosure: { (response) in
                guard let jsonDict = response.dictionaryObject else{
                    semaphoreC.signal()
                    return
                }
                //字典转模型
                let cate : XBRecomCateData = XBRecomCateData(JSON: jsonDict)!
                self.recommenCateData = cate
                semaphoreC.signal()
                
        
            }, failClosure: { _ in
                semaphoreC.signal()
            })
            
        }
        
        queue.async {
            if semaphoreC.wait(wallTimeout: .distantFuture) == .success{
                DispatchQueue.main.async {
                    self.mainTable.es.stopPullToRefresh()
                    XBProgressHUD.hideAllHUD()
                    print("全部任务执行完成")
                    self.mainTable.reloadData()
                }
            }
        }
    }
    
}










//配置UI
extension ClassifyController{
    private func setUpAllView(){
        view.addSubview(mainTable)
        mainTable.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        var header: ESRefreshProtocol & ESRefreshAnimatorProtocol
        header = XBRefreshView(frame: CGRect.zero)
        
        self.mainTable.es.addPullToRefresh(animator: header) { [weak self] in
            self?.loadCateListData()
        }

        
    }
}
//配置代理
extension ClassifyController : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: XBCategroyListCell.identifier(), for: indexPath) as! XBCategroyListCell
        cell.selectionStyle = .none
        
        if indexPath.section == 0 {
            cell.cateTwoList = self.recommenCateData?.cate2_list
            
        }else{
            if self.cateListData.count != 0{
                let item : XBCateOneData = self.cateListData[indexPath.section - 1]
                cell.cateTwoList = item.cate2_list
                
            }
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 + (self.cateListData.count)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard self.cateListData.count != 0 else { return 0 }
        let maxItemCount = 8
        let pageControlHeight: CGFloat = 37
         //没有pageControl时添加
        let spaceHeight : CGFloat = 10
        // item的数量
        var dataCount = 0
        
        if indexPath.section == 0 {
            let model = self.recommenCateData?.cate2_list ?? []
            dataCount = model.count
            
        }else{
            let model = self.cateListData[indexPath.section - 1].cate2_list
            dataCount = model.count
        }
        
        //根据item个数计算cell高度
        if dataCount > maxItemCount {
            return CateItemHeight * 2 + pageControlHeight
        }else if dataCount > 4 && dataCount <= maxItemCount{
            return CateItemHeight * 2 + spaceHeight
        }else{
            return CateItemHeight + spaceHeight
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header  = XBCollectionReusableView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: Adapt(50)))
        
        if section == 0 {
            header.configTitle(title: "推荐分类")
        }else{
            
            if self.cateListData.count != 0 {
                let item : XBCateOneData = self.cateListData[section - 1]
                
                header.configTitle(title: item.cate_name ?? "55555")
            }
            
            
        }
        
        header.topLine.isHidden = true
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Adapt(50)
    }
    
    
}



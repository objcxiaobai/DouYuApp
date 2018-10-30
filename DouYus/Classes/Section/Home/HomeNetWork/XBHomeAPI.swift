//
//  XBHomeAPI.swift
//  DouYus
//
//  Created by 冼 on 2018/10/30.
//  Copyright © 2018 Null. All rights reserved.
//

import UIKit
import Moya

let HomeProvider = MoyaProvider<HomeAPI>()


public enum HomeAPI{
    case recommendCategoryList
    case liveCateList
}


extension HomeAPI : TargetType{
    

    
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    
    public var headers: [String : String]? {
        return nil
    }
    
    
    //服务器
    public var baseURL : URL{
        switch self {
        case .recommendCategoryList:
            return URL(string: "https://apiv2.douyucdn.cn")!
        case .liveCateList:
            return URL(string: "https://apiv2.douyucdn.cn")!
    }
    
  }
    
    //各个请求的具体路径
    public var path: String{
        switch self {
        case .recommendCategoryList:
            return "/live/cate/getLiveRecommendCate2"
        case .liveCateList:
            return "/live/cate/getLiveCate1List"
    }
 }
    public var method: Moya.Method{
        switch self {
        case .recommendCategoryList:
            return .get
        case .liveCateList:
            return .get
        }
        
    }
    
    //请求任务事件
    public var task: Task{
        switch self {
        case .recommendCategoryList:
            var params: [String: Any] = [:]
            params["client_sys"] = "ios"
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .liveCateList:
            var params: [String: Any] = [:]
            params["client_sys"] = "ios"
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }


}

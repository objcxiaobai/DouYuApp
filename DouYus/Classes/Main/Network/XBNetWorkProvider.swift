//
//  XBNetWorkProvider.swift
//  DouYus
//
//  Created by 冼 on 2018/10/29.
//  Copyright © 2018 Null. All rights reserved.
//

import UIKit
import Moya
import Result
import SwiftyJSON
import ObjectMapper

//成功
typealias SuccessStringClosure = (_ result: String) -> Void
typealias successModelClosure = (_ result: Mappable?) -> Void
typealias SuccessArrModelClosure = (_ result: [Mappable]?) -> Void
typealias SuccessJSONClosure = (_ result: JSON) -> Void

//失败
typealias FailClosure = (_ errorMsg: String?) -> Void


public class XBNetWorkProvider{
    //共享实例
    static let shared = XBNetWorkProvider()
    private init(){}
    private let failInfo = "数据解析失败"
    
    //请求JSON
    
    func requestDataWithTargetJSON<T:TargetType>(target : T,successClosure: @escaping SuccessJSONClosure, failClosure: @escaping FailClosure){
        
        let requestProvider = MoyaProvider<T>(requestClosure:requestTimeoutClosure(target: target))
        
        let _ = requestProvider.request(target) { (result) -> () in
            switch result{
            case let .success(reponse):
                do{
                    let mapison = try reponse.mapJSON()
                    let json = JSON(mapison)
                    guard let _ = json.dictionaryObject else{
                        failClosure(self.failInfo)
                        return
                    }
                    successClosure(json["data"])
                }catch{
                    failClosure(self.failInfo)
                }
            case let .failure(error):
                failClosure(error.errorDescription)
            }
        }
        
        
    }
    //请求数组对象JSON数据
    func requestDataWithTargetArrModelJSON<T:TargetType,M:Mappable>(target:T,model:M,successClosure:@escaping SuccessArrModelClosure,failClosure: @escaping FailClosure){
        
        let requestProvider = MoyaProvider<T>(requestClosure:requestTimeoutClosure(target: target))
        
        let _ = requestProvider.request(target) { (result) -> () in
            switch result{
            case let .success(response):
                do{
                    let json = try response.mapJSON()
                    let arr = Mapper<M>().mapArray(JSONObject: JSON(json).object)
                    successClosure(arr)
                    
                }catch{
                    failClosure(self.failInfo)
                }
            case let .failure(error):
                failClosure(error.errorDescription)
            }
        }
        
        
        
    }
    
    //请求对象JSON数据
    func requestDataWithTargetModelJSON<T:TargetType,M:Mappable>(target:T,model:M,successClosure:@escaping successModelClosure, failclosure: @escaping FailClosure){
        
        let requestProvider = MoyaProvider<T>(requestClosure:requestTimeoutClosure(target: target))
        
        let _ = requestProvider.request(target) { (result) -> () in
            switch result{
            case let .success(response):
                do{
                    let json = try response.mapJSON()
                    let model = Mapper<M>().map(JSONObject: JSON(json).object)
                    successClosure(model)
                    
                    
                }catch{
                    failclosure(self.failInfo)
                }
            case let .failure(error):
                failclosure(error.errorDescription)
            }
        }
    }
    
    //请求string数据
    func requestDataWithTaegetString<T:TargetType>(target:T,successClosure:@escaping SuccessStringClosure,failClosure: @escaping FailClosure){
        let requestProvider = MoyaProvider<T>(requestClosure:requestTimeoutClosure(target: target))
        let _ = requestProvider.request(target) { (result)->() in
            switch result{
            case let .success(response):
                do{
                    let str = try response.mapString()
                    successClosure(str)
                }catch{
                    failClosure(self.failInfo)
                }
            case let .failure(error):
                failClosure(error.errorDescription)
            }
            
        }
        
        
        
        
    }
    
    
    
    ///设置一个公共请求超时时间
    private func requestTimeoutClosure<T:TargetType>(target:T) -> MoyaProvider<T>.RequestClosure{
        let requestTimeoutClosure = { (endpoint:Endpoint, done:@escaping MoyaProvider<T>.RequestResultClosure) in
            
            do{
                var request = try endpoint.urlRequest()
                //设置请求超时时间
                request.timeoutInterval = 20
                done(.success(request))
            }catch{
                return
            }
            
        }
        
        return requestTimeoutClosure
        
    }
    
}

//
//  XBRecomCateData.swift
//  DouYus
//
//  Created by 冼 on 2018/10/29.
//  Copyright © 2018 Null. All rights reserved.
//

import UIKit
import ObjectMapper
class XBRecomCateData: Mappable {

    var total : Int?
    var cate2_list : [XBRecomCateList] = [XBRecomCateList]()
    var error : Int?
    init(){
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        total  <- map["total"]
        error  <- map["error"]
        cate2_list <- map["cate2_list"]
    }


}
class XBRecomCateList: Mappable {
    var cate2_name : String?
    var small_icon_url : String?
    var is_vertical : Int?
    var icon_url : String?
    var cate2_id : Int?
    var cate2_short_name : String?
    var push_nearby : Int?
    var square_icon_url : String?
    
    init(){
    }
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        cate2_name <- map["cate2_name"]
        small_icon_url <- map["small_icon_url"]
        is_vertical <- map["is_vertical"]
        icon_url <- map["icon_url"]
        cate2_id <- map["cate2_id"]
        cate2_short_name <- map["cate2_short_name"]
        push_nearby <- map["push_nearby"]
        square_icon_url <- map["square_icon_url"]
    }

}
class XBCateOneData: Mappable {
    var cate1_id : Int?
    var cate_name : String?
    var cate2_count : Int?
    var cate2_list : [XBRecomCateList] = [XBRecomCateList]()

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
    }
    
}

class XBCateAllData: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        cate1_list <- map["cate1_list"]
    }
    

    var cate1_list : [XBCateOneData] = [XBCateOneData]()
    
    
}

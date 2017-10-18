//
//  CityManager.swift
//  KoMovie
//
//  Created by Albert on 28/03/2017.
//  Copyright © 2017 Ariadne’s Thread Co., Ltd. All rights reserved.
//

import UIKit

class CityManager: NSObject {
    static let shareInstance = CityManager()
    
    var cityList = [City]()
    
    func getCity(cityId:Int16) -> City? {
        if cityList.count == 0 {
            return nil
        }
        
        let pre = NSPredicate(format: "cityId == %@", NSNumber(value: Int(cityId)))
        let result = (cityList as NSArray).filtered(using: pre)
        
        return result.first as? City
    }
    
    func getCity(name:String) -> City? {
        if cityList.count == 0 {
            return nil
        }
        
        let pre = NSPredicate(format: "cityname == %@", name)
        var result = (cityList as NSArray).filtered(using: pre)
        
        if result.count == 0 {
            result =  (cityList as NSArray).filtered(using: NSPredicate(format: "pinyin == %@", name))
        }
        
        return result.first as? City

    }
    
}

//
//  String.swift
//  FourSqaureSample
//
//  Created by mohamed on 7/8/20.
//  Copyright © 2020 mohamed. All rights reserved.
//

import Foundation
extension String {

    var parseJSONString: AnyObject? {

        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)

        if let jsonData = data {
            return try? JSONSerialization.jsonObject(with: jsonData) as AnyObject?
        } else {
            return nil
        }
    }
}

extension Data {
    
    func toString()-> String{
         return String(decoding: self , as: UTF8.self)
    }
                   
}

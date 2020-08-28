//
//  LocationMode.swift
//  FourSqaureSample
//
//  Created by mohamed on 7/11/20.
//  Copyright © 2020 mohamed. All rights reserved.
//

import Foundation



enum LocationMode : Int {
    case single
    case realTime = 1
    
    var title : String {
        switch self {
        case .single:
            return "Single Update"
        case .realTime :
            return "Realtime"
        }
    }
    
    init?(type : Int) {
        if type == 1 {
            self = .realTime
        }else{
            self = .single
        }
    }
    
}

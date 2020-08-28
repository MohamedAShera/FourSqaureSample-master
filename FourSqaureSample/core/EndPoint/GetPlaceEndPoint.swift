//
//  GetPlaceEndPoint.swift
//  FourSqaureSample
//
//  Created by mohamed on 7/8/20.
//  Copyright © 2020 mohamed. All rights reserved.
//

import Foundation

class GetPlaceEndPoint: Endpoint {
    var service: EndpointService = .search
    
    var url: String = ""
    
    var method: EndpointMethod = .get
    
    var auth: AuthorizationHandler = NoneAuthorizationHandler()
    
    var parameters: [String: Any] = [:]
    
    var encoding: EndpointEncoding = .query
    
    var headers: [String: String] = [:]
    init(lat: Double , lng : Double ) {
        url += "/recommendations?ll=\(lat),\(lng)&v=20190401&radius=300&intent=venues&client_id=\(Constants.client_id)&client_secret=\(Constants.client_secret)"
         }
    
      
}

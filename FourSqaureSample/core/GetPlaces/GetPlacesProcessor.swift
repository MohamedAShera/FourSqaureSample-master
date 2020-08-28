//
//  GetPlacesProcessor.swift
//  FourSqaureSample
//
//  Created by mohamed on 7/8/20.
//  Copyright © 2020 mohamed. All rights reserved.
//

import Foundation
import Promises
class GetPlacesProcessor:  NetworkProcessor<GetPlaceModel>  {
    var userRepo: UserRepo
     var lat: Double
    var lng: Double

    init(userRepo: UserRepo,    lat: Double,  lng: Double) {
        self.userRepo = userRepo
        self.lat = lat
        self.lng = lng
    }
    
    override func extract() {}
    
    override func validate() throws {
    }
    
    override func process() throws -> Promise<GetPlaceModel> {
        return userRepo.getPlaces(lat: lat, lng: lng)
        
    }
}

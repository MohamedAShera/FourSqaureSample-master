//
//  UserRepo.swift
//  FourSqaureSample
//
//  Created by mohamed on 7/8/20.
//  Copyright © 2020 mohamed. All rights reserved.
//

import Foundation
import Promises

protocol UserRepo {
    func getPlaces(lat:Double , lng : Double) -> Promise<GetPlaceModel>

}

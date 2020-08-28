//
//  UserRepoImpl.swift
//  FourSqaureSample
//
//  Created by mohamed on 7/8/20.
//  Copyright © 2020 mohamed. All rights reserved.
//


import Foundation
import Promises

class UserRepoImpl: UserRepo {
   
    
   
    private var network: NetworkService
    private var localData: LocalData
    
    init(network: NetworkService = NetworkServiceImpl(), localData: LocalData = LocalDataImpl()) {
        self.network = network
        self.localData = localData
    }
    
    func getPlaces(lat: Double, lng: Double) -> Promise<GetPlaceModel> {
        return network.callModel(GetPlaceModel.self, endpoint: GetPlaceEndPoint(lat: lat, lng: lng))

       }
}

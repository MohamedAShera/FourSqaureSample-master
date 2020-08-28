//
//  GetPlacesPresenter.swift
//  FourSqaureSample
//
//  Created by mohamed on 7/8/20.
//  Copyright © 2020 mohamed. All rights reserved.
//

import Foundation
import Bond
import CoreLocation

class GetPlacesPresenter:BasePresenter {
    
    var router: RouterManagerProtocol
  
    var userRepo: UserRepo
    var lat: Observable<Double?> = Observable(0.0)
    var lng: Observable<Double?> = Observable(0.0)
    var places: Dynamic<[Result]> = Dynamic([])
    var currentLocation:CLLocationCoordinate2D?

    init(router: RouterManagerProtocol, userRepo: UserRepo ) {
        self.router = router
        self.userRepo = userRepo
      
        
    }
    
    
    
    override func hydrate() {
        
        
    }
    
    func getPlaces(lat : Double , lng : Double) {
        showLoading()
        GetPlacesProcessor(userRepo: userRepo, lat: lat, lng: lng).execute()
            .then { (response) in
                
                self.hideLoading()
                self.places.value = response.response?.group?.results ?? []

                
        }.catch { (error) in
            self.hideLoading()
            self.showSystemError(error: error)}
    }
    func back() {
        router.dismiss()
    }
    
    
}


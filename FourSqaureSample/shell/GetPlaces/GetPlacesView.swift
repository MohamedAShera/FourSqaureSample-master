//
//  GetPlacesView.swift
//  FourSqaureSample
//
//  Created by mohamed on 7/8/20.
//  Copyright © 2020 mohamed. All rights reserved.
//

import UIKit
import CoreLocation

class GetPlacesView: BaseView<GetPlacesPresenter, BaseItem> ,CLLocationManagerDelegate{
    var firstLanche = true
    var typeMode : LocationMode?
    
    var currentLocation:CLLocationCoordinate2D?
    let locationManager = CLLocationManager()
    @IBOutlet weak var placesCollection: UICollectionView! {
        didSet {
            self.placesCollection.register(UINib(nibName: String(describing: PlacesCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: PlacesCollectionViewCell.self))
            
            self.placesCollection.register(UINib(nibName: String(describing: NoDataFoundCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: NoDataFoundCollectionViewCell.self))
            //NoDataFoundCollectionViewCell
        }
    }
    
    override func bindind() {
        presenter = GetPlacesPresenter(router: RouterManager(self), userRepo: UserRepoImpl())
        
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
            locationManager.distanceFilter = 500 // distance changes you want to be informed about (in meters)
            locationManager.desiredAccuracy = 100 // biggest approximation you tolerate (in meters)
            locationManager.activityType = .automotiveNavigation // .automotiveNavigation will stop the updates when the device is not moving
            
            
        }
        
        self.placesCollection.reloadData()
        //    locationManager.startUpdatingLocation()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.isNavigationBarHidden = false
        
        if let typeRawValue = UserDefaults.standard.object(forKey: Constants.DefaultLocationMode) as? Int ,
            let type = LocationMode.init(type: typeRawValue) {
            typeMode = type
            let rightBtn : UIBarButtonItem = UIBarButtonItem(title:type.title , style: .plain, target: self, action: #selector(onClickMethod(nabButton:)))
            
            self.navigationItem.rightBarButtonItem = rightBtn
            
        }
        locationManager.startUpdatingLocation()
        
        
    }
    @objc func onClickMethod(nabButton : UIBarButtonItem) {
        print("right bar button item")
        guard  let typeMode = typeMode  else {return}
        
        if typeMode == LocationMode.realTime {
            self.navigationItem.rightBarButtonItem?.title = "Single Update"
            UserDefaults.standard.set(LocationMode.single.rawValue, forKey: Constants.DefaultLocationMode)
            self.typeMode = .single
        } else {
            self.navigationItem.rightBarButtonItem?.title = "Realtime"
            UserDefaults.standard.set(LocationMode.realTime.rawValue, forKey: Constants.DefaultLocationMode)
            self.typeMode = .realTime
        }
        locationManager.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        if typeMode == LocationMode.single {
            manager.stopUpdatingLocation()
        }
        
        
        updatLocation(currentLocation: locValue)
        
        
        
    }
    func updatLocation(currentLocation : CLLocationCoordinate2D){
        
        
        
        presenter.getPlaces(lat: currentLocation.latitude, lng: currentLocation.longitude)
        presenter.places.bind { _ in
            self.placesCollection.reloadData()
        }
        
        
        
        
    }
    
}
extension GetPlacesView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if presenter.places.value.isEmpty {
            return 1
        }
        else{
            
            return presenter.places.value.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if presenter.places.value.isEmpty {
            let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: NoDataFoundCollectionViewCell.self), for: indexPath))  as! NoDataFoundCollectionViewCell
            
            return cell
        }else {
            let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PlacesCollectionViewCell.self), for: indexPath))  as! PlacesCollectionViewCell
            cell.configure(result: presenter.places.value[indexPath.row], index: indexPath.row)
            return cell
        }
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if  presenter.places.value.isEmpty {
            return CGSize( width: (collectionView.frame.width), height:collectionView.frame.height )
        }
        else {
            return CGSize( width: (collectionView.frame.width), height: 120 )
        }
        
    }
    
}



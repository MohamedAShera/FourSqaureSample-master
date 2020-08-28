//
//  PlacesCollectionViewCell.swift
//  FourSqaureSample
//
//  Created by mohamed on 7/8/20.
//  Copyright © 2020 mohamed. All rights reserved.
//

import UIKit
import moa

class PlacesCollectionViewCell: UICollectionViewCell {
    var itemIndex: Int = 0
    @IBOutlet weak var distance_lbl: UILabel!
    @IBOutlet weak var address_lbl: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var title_lbl: UILabel!
    
    func configure(result: Result, index: Int) {
        self.itemIndex = index
        title_lbl.text = result.venue?.name
        address_lbl.text = result.venue?.location?.address
        let distance = (Double(result.venue!.location!.distance!))/1000.0
        
        distance_lbl.text =  String(format: "%.2f KM", distance)
        if let photo = result.photo ,let suffix = photo.suffix ,let _ = URL(string:NetworkConstant.photoBaseUrl + suffix){
            img.moa.url = NetworkConstant.photoBaseUrl + result.photo!.suffix!
        }
            
            
        else{
            
            img.image = #imageLiteral(resourceName: "placeholder.png")
            img.contentMode = .scaleToFill
            
        }
        
    }
}

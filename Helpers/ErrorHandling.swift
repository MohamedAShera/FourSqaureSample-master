//
//  ErrorHandling.swift
//  FourSqaureSample
//
//  Created by mohamed on 7/8/20.
//  Copyright © 2020 mohamed. All rights reserved.
//


import Foundation
import SwiftyJSON

class ServerError: Codable, Error, LocalizedError {
    var message: String?
    var errors: [String]?
    
    init() {
        message = "Something went wrong, please try again later"
    }
    
    init(message: String) {
        self.message = message
    }
    
    public var errorDescription: String? {
        return errors?.count ?? 0 > 0 ? errors?[0] : message
    }
}

class NoInternetConnectionError: Error, LocalizedError {
    
    public var errorDescription: String? {
        return "Please check your internet connection"
    }
}

class FailToCallNetworkError: Error, LocalizedError {
    public var errorDescription: String? {
        return "Something went wrong, please try again later"
    }
}

class FailToMapResponseError: Error, LocalizedError {
    
    init(data: Data) {
        do {
            try print("😱😱 FailToMapResponse: ", String(describing: JSON(data: data)))
        } catch let error {
            print(error)
        }
        
    }
    public var errorDescription: String? {
        return "Something went wrong, please try again later"
    }
}

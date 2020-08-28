//
//  NetworkProcessor.swift
//  FourSqaureSample
//
//  Created by mohamed on 7/8/20.
//  Copyright © 2020 mohamed. All rights reserved.
//

import Foundation
import Promises

class NetworkProcessor<T: Codable> {
    
    func execute() -> Promise<T> {
        do {
            extract()
            try validate()
            return try process()
        } catch let error {
            return Promise<T>.init(error)
        }
    }
    
    func extract() { }
    
    func validate() throws { }
    
    func process() throws -> Promise<T> {
        throw NSError(domain: "Un Implemented Processor", code: 100, userInfo: nil)
    }
}

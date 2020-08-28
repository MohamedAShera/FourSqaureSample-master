//
//  AuthorizationHandler.swift
//  FourSqaureSample
//
//  Created by mohamed on 7/8/20.
//  Copyright © 2020 mohamed. All rights reserved.
//

import Foundation

protocol AuthorizationHandler {
    var tokenHeader: [String: String] { get }

}

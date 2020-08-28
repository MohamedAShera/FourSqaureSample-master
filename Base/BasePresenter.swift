//
//  BasePresenter.swift
//  FourSqaureSample
//
//  Created by mohamed on 7/8/20.
//  Copyright © 2020 mohamed. All rights reserved.
//

import Foundation


class BasePresenter {
    
    init() {
        hydrate()
    }
    
    func hydrate() {}
    
    private var errorMessage: Dynamic<String> = Dynamic("")
    private var alertMessage: Dynamic<String> = Dynamic("")
    var isLoading: Dynamic<Bool> = Dynamic(false)
    var alertDone: Dynamic<String> = Dynamic("")
    
    func showSystemError(error: Error) {
        errorMessage.value = error.localizedDescription
    }
    
    func showSystemAlert(alert: String) {
        alertMessage.value = alert
    }
    func handleAlert(_ message: String) {
        alertDone.value = message
    }
    
    func implementErrorMessage(_ listener: @escaping (String) -> Void) {
        errorMessage.bind(listener)
    }
    
    func implementAlert(_ listener: @escaping (String) -> Void) {
        alertMessage.bind(listener)
    }
    
    func implementAlertAction(_ listener: @escaping (String) -> Void) {
           alertDone.bind(listener)
       }
    
    func showLoading() {
        isLoading.value = true
    }
    
    func hideLoading() {
        isLoading.value = false
    }
    

}

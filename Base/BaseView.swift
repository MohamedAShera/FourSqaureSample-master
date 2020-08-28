//
//  BaseView.swift
//  FourSqaureSample
//
//  Created by mohamed on 7/8/20.
//  Copyright © 2020 mohamed. All rights reserved.
//


import UIKit
import JGProgressHUD

class BaseView<Presenter: BasePresenter, Item: BaseItem>: UIViewController {
    let frame = UIScreen.main.bounds
    var item: Item!
    let hud = JGProgressHUD(style: .dark)
    var alertDone: Dynamic<Bool> = Dynamic(false)
    
    var presenter: Presenter! {
        didSet {
            presenter.implementAlert { (alert) in
                self.showAlert(title: "", message: alert, actions: [("ok", .default)])
            }
            
            presenter.implementErrorMessage { (error) in
                self.showAlert(title: "", message: error, actions: [("ok", .default)])
            }
            
            presenter.isLoading.bindAndFire { (loading) in
                if loading {
                    self.hud.show(in: self.view)
                } else {
                    self.hud.dismiss()
                }
            }
        }
        
    }
    
    private func showAlert(title: String, message: String, actions: [(String, UIAlertAction.Style)]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alert.addAction(UIAlertAction(title: action.0, style: action.1, handler: { (alert: UIAlertAction!) -> Void in
                     self.presenter.handleAlert(message)
                
            }))
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationItem.backBarButtonItem?.title = ""
        bindind()
    }
    
    func bindind() {}
}

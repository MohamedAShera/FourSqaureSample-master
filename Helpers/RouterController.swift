//
//  RouterController.swift
//  FourSqaureSample
//
//  Created by mohamed on 7/8/20.
//  Copyright © 2020 mohamed. All rights reserved.
//

import Foundation

import Foundation
import UIKit

enum Storyboard: String {
    case main = "Main"
   
}

enum View: String {
    case startScreen = "StartScreenView"

    private var storyboard: Storyboard {
        switch self {
     
        case .startScreen: return .main
        }
    }
    
    func controller<Presenter: BasePresenter, Item: BaseItem>(presenterType: Presenter.Type, item: Item) -> BaseView<Presenter, Item> {
        let controller = UIStoryboard.init(name: storyboard.rawValue, bundle: Bundle.main).instantiateViewController(withIdentifier: rawValue)
            as! BaseView<Presenter, Item> //swiftlint:disable:this force_cast
        controller.item = item
        return controller
    }
}

protocol RouterManagerProtocol {
    func push<Presenter: BasePresenter, Item: BaseItem>(view: View, presenter: Presenter.Type, item: Item )
    func present<Presenter: BasePresenter, Item: BaseItem>(view: View, presenter: Presenter.Type, item: Item)
    func popBack()
    func dismiss()
}

class RouterManager: RouterManagerProtocol {
    
    var currentViewController: UIViewController
    
    init(_ currentViewController: UIViewController) {
        self.currentViewController = currentViewController
    }
    
    func present<Presenter: BasePresenter, Item: BaseItem>(view: View, presenter: Presenter.Type, item: Item) {
        let viewController = view.controller(presenterType: presenter, item: item)
        viewController.modalPresentationStyle = .overFullScreen
        currentViewController.present(viewController, animated: true)
        
    }
    
    func push<Presenter: BasePresenter, Item: BaseItem>(view: View, presenter: Presenter.Type, item: Item ) {
        let viewController = view.controller(presenterType: presenter, item: item)
        currentViewController.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func popBack() {
        _ = currentViewController.navigationController?.popViewController(animated: true)
    }
    func dismiss() {
        _ = currentViewController.dismiss(animated: true, completion: nil)
    }
    
}

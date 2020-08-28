//
//  AlamofireService.swift
//  FourSqaureSample
//
//  Created by mohamed on 7/8/20.
//  Copyright © 2020 mohamed. All rights reserved.
//

import Foundation
import Alamofire
import Promises
import SwiftyJSON
import KeychainSwift
import Security


class AlamofireService: EndpointExecuter {
    private let manager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringCacheData
        return SessionManager(configuration: configuration)
    }()
    
    func execute(_ endpoint: Endpoint) -> Promise<NetworkServiceResponse> {
        return Promise<NetworkServiceResponse>(on: .global()) { fulfill, reject in
            self.request(by: endpoint)
                .responseData(completionHandler: { (response) in
                    switch response.result {
                    case .success(let data):
                        print("Enter In Success ❤️")
                        if response.response?.statusCode == 401 {
                        }else{
                           fulfill(NetworkServiceResponse(data: data,
                            statusCode: response.response?.statusCode,
                            headers: response.response?.allHeaderFields))
                        }
                        
                    case .failure(let error):
                        print("Enter Failur ❤️")
                        reject(error)
                    }
                })
        }
    }
    
    func uploadMultipart(_ endpoint: Endpoint) -> Promise<NetworkServiceResponse> {
        return Promise<NetworkServiceResponse>(on: .global()) { fulfill, reject in
            self.upload(by: endpoint, completionHandler: { (response) in
                switch response {
                case .success(let upload, _, _):
                    upload.uploadProgress(closure: { (progress) in
                        print("😂😂😂😂\(progress.fractionCompleted)")
                        let progressValue: [String: Int] = ["progress": Int(progress.fractionCompleted*100)]
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "inProgress"), object: nil, userInfo: progressValue)
                    })
                    upload.response { response in
                        if response.response?.statusCode == 401 {
                            }
                        else {
                        fulfill(NetworkServiceResponse(data: response.data!,
                                                       statusCode: response.response?.statusCode,
                                                       headers: response.response?.allHeaderFields))
                        }
                        
                    }
                    
                case .failure(let error):
                    print("Enter Failur ❤️")
                    reject(error)
                }
            })
        }
        
    }

    private func routeTo<ViewController: UIViewController>(storyBoard: Storyboard, idintifier: String , controller: ViewController.Type){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
           let storyboard = UIStoryboard(name: storyBoard.rawValue, bundle:nil)
        appDelegate.window?.rootViewController =  UINavigationController.init(rootViewController: (storyboard.instantiateViewController(withIdentifier: idintifier) as? ViewController)! )
       }
    private func request(by endpoint: Endpoint) -> DataRequest {
        print("😱😱 Endpoint URL : \(endpoint.service.url + endpoint.url)")
        print("😱😱 Method : \(endpoint.method.alamofireEndpoint)")
        print("😱😱 Parameters : \(endpoint.parameters.filter({($0.value as? String) != ""}))")
        print("😱😱 Headers : \(concatenateHeaders(for: endpoint))")
        
        return manager.request(endpoint.service.url + endpoint.url,
                               method: endpoint.method.alamofireEndpoint,
                               parameters: endpoint.parameters.filter {($0.value as? String) != ""},
                               encoding: endpoint.encoding.alamofireEncoding,
                               headers: concatenateHeaders(for: endpoint))
    }
    
    private func upload(by endpoint: Endpoint, completionHandler: @escaping (SessionManager.MultipartFormDataEncodingResult) -> Void ) {
        print("😱😱 Method : \(endpoint.method.alamofireEndpoint)")
        print("😱😱 Parameters : \(endpoint.parameters.filter({($0.value as? String) != "" && (($0.value as? Data)?.toString() != "") }))")
        print("😱😱 Headers : \(concatenateHeaders(for: endpoint))")
        print("😱😱 url : \(endpoint.service.url + endpoint.url)")
        
        manager.upload(multipartFormData: { multipartFormData in
            for (key, value) in endpoint.parameters.filter({($0.value as? String) != "" && (($0.value as? Data)?.toString() != "")  }) {
                if key == "profile_photo" || key == "company_logo" {
                    if (key == "profile_photo" ){
                        let val = value as?(Data,Bool)
                        if val?.1 == true {
                            let item = MultiPartModel(data: val?.0 ?? Data(),
                                                     fileName: "comprofile_pic\(Date().getCurrentSecond()).png",
                                                                        mimeType: "image/png",
                                                                        keyName: key)
                            multipartFormData.append(item.data, withName: item.keyName, fileName: item.fileName, mimeType: item.mimeType)
                        }
                        else{
                            let item = MultiPartModel(data: val?.0 ?? Data(),
                                                     fileName: "\(key) \(Date().getCurrentSecond()).png",
                                                                        mimeType: "image/png",
                                                                        keyName: key)
                            multipartFormData.append(item.data, withName: item.keyName, fileName: item.fileName, mimeType: item.mimeType)
                        }
                        
                    }
                    else{
                        let item = MultiPartModel(data: value as? Data ?? Data(),
                                                                   fileName: "\(key) \(Date().getCurrentSecond()).png",
                                                                   mimeType: "image/png",
                                                                   keyName: key)
                         multipartFormData.append(item.data, withName: item.keyName, fileName: item.fileName, mimeType: item.mimeType)
                    }
                 
                   
                } else {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                }
            }
        },
                       usingThreshold: UInt64.init(),
                       to: endpoint.service.url + endpoint.url,
                       method: endpoint.method.alamofireEndpoint,
                       headers: concatenateHeaders(for: endpoint),
                       encodingCompletion: { result in
                       completionHandler(result)
        })
        
    }
    
    private func concatenateHeaders(for endpoint: Endpoint) -> [String: String] {
        var headers = endpoint.headers.filter{$0.value != ""}
        headers.updateValue("application/json", forKey: "Content-Type")
      headers.updateValue("application/json", forKey: "Accept")
        for (key, value) in endpoint.auth.tokenHeader {
            print("😂😂😂😂😂😂Header\(value)")
            headers.updateValue(value, forKey: key)
            
        }
        return headers
    }
}

extension EndpointEncoding {
    var alamofireEncoding: ParameterEncoding {
        switch self {
        case .json: return JSONEncoding.default
        case .query: return URLEncoding.queryString
        }
    }
}

extension EndpointMethod {
    var alamofireEndpoint: HTTPMethod {
        switch self {
        case .get: return .get
        case .post: return .post
        case .delete: return .delete
        case .put: return .put
        }
    }
}

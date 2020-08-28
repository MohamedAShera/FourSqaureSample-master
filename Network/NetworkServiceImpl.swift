//
//  NetworkServiceImpl.swift
//  FourSqaureSample
//
//  Created by mohamed on 7/8/20.
//  Copyright © 2020 mohamed. All rights reserved.
//


import Foundation
import Promises
import Reachability
import SwiftyJSON

protocol EndpointExecuter {
    func execute(_ endpoint: Endpoint) -> Promise<NetworkServiceResponse>
    func uploadMultipart(_ endpoint: Endpoint) -> Promise<NetworkServiceResponse>
}

protocol ReachabilityProtocol {
    func connection() -> Reachability.Connection?
}

class NetworkServiceImpl: NetworkService {
    
    var endpointExecuter: EndpointExecuter = AlamofireService()
    var reachability: ReachabilityProtocol = ReachabilityImpl()
    
    func callModel<Model: Codable>(_ model: Model.Type, endpoint: Endpoint) -> Promise<Model> {
        return Promise<Model>(on: .main) { fulfill, reject in
            self.call(endpoint: endpoint)
                .then({ (data) in
                    guard let response = try? JSONDecoder().decode(Model.self, from: data) else {
                        reject(FailToMapResponseError(data: data))
                        return
                    }
                    fulfill(response)})
                .catch({ (error) in
                    reject(error) })
        }
    }
    
    func uploadModel<Model: Codable>(_ model: Model.Type, endpoint: Endpoint) -> Promise<Model> {
        
        return Promise<Model>(on: .main) { fulfill, reject in
            
            self.upload(endpoint: endpoint)
                .then({ (data) in
                    guard let response = try? JSONDecoder().decode(Model.self, from: data) else {
                        reject(FailToMapResponseError(data: data))
                        return
                    }
                    print("☠️☠️ After Codable : \(response)")
                    fulfill(response)})
                .catch({ (error) in
                    reject(error) })
        }
    }
    
    func call(endpoint: Endpoint) -> Promise<Data> {
        return Promise<Data>(on: .main) { fulfill, reject in
            self.endpointExecuter.execute(endpoint)
                .then ({ (response) in
                    self.networkSuccess(data: response.data, statusCode: response.statusCode).then({ (data) in
                        let header = response.headers as? [String: Any]
                        let headerResponse =  header?.decode( HeaderResponse.self)
                        print("🥎🥎🥎🥎\(headerResponse!)")
                        fulfill(data)
                    }).catch({ (error) in
                        
                        reject(error)
                    })
                }).catch ({ (_) in
                    reject(self.networkFail())
                })
        }
    }
    
    func upload(endpoint: Endpoint) -> Promise<Data> {
        return Promise<Data>(on: .main) { fulfill, reject in
            self.endpointExecuter.uploadMultipart(endpoint)
                .then({ (response) in
                    self.networkSuccess(data: response.data, statusCode: response.statusCode).then({ (data) in
                        let header = response.headers as? [String: Any]
                        let headerResponse =  header?.decode( HeaderResponse.self)
                        print("🥎🥎🥎🥎\(headerResponse!)")
                        fulfill(data)
                    }).catch({ (error) in
                        reject(error)
                    })
                }).catch({ _ in
                    reject(self.networkFail())
                })
        }
    }
    
    private func networkSuccess(data: Data, statusCode: Int?) -> Promise<Data> {
        print("Response Data 🤪🤪🤪🤪  \(JSON(data))")
        return Promise<Data>(on: .main) { fulfill, reject in
            if (200...299).contains(statusCode ?? 0) {
                fulfill(data)
            } else {
                guard let error = try? JSONDecoder().decode(ServerError.self, from: data) else {
                    reject(ServerError())
                    return
                }
                reject(error)
            }
        }
    }
    
//    private func saveHeaders( _ header: HeaderResponse) {
//
//        UserAuthoriationHandler().setAuthManually(authToken: header.token ?? "")
//        UserAuthoriationHandler().setUidManually(uid: header.uid ?? "")
//        UserAuthoriationHandler().setClientManually(client :  header.client ?? "" )
//    }
    
    private func networkFail() -> Error {
        return isConnectedToInternet ? FailToCallNetworkError() : NoInternetConnectionError()
    }
    
    private var isConnectedToInternet: Bool {
        return reachability.connection() != Reachability.Connection.none
    }
}

struct NetworkServiceResponse {
    var data: Data
    var statusCode: Int?
    
    var headers: [AnyHashable: Any]?
}

struct HeaderResponse: Codable {
    var token: String?
    var client: String?
    var uid: String?
    
    enum CodingKeys: String, CodingKey {
        case token = "access-token"
        case client, uid
    }
}

class ReachabilityImpl: ReachabilityProtocol {
    
    func connection() -> Reachability.Connection? {
        return Reachability()?.connection
    }
}

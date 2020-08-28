//
//  Codable+Helpers.swift
//  FourSqaureSample
//
//  Created by mohamed on 7/8/20.
//  Copyright © 2020 mohamed. All rights reserved.
//

import Foundation

extension Encodable {
    func asDictionary() -> [String: Any] {
        if (self is SignUpModel){
        }
        let serialized = (try? JSONSerialization.jsonObject(with: self.encode(), options: .mutableContainers)) ?? nil
        return serialized as? [String: Any] ?? [String: Any]()
    }
    
    func encode() -> Data {
        return (try? JSONEncoder().encode(self)) ?? Data()
    }
    func decode<T: Codable>(_ type: T.Type) -> T? {
        return (try? JSONDecoder().decode(T.self, from: self.encode()))
    }
}

extension Data {
    func decode<T: Codable>(_ type: T.Type) -> T? {
        return (try? JSONDecoder().decode(T.self, from: self))
    }
}

extension Dictionary {
    
    func encode() -> Data {
        return ((( try? JSONSerialization.data(withJSONObject: self, options: .fragmentsAllowed)) ?? nil) ?? nil)!
    }
    func decode<T: Codable>(_ type: T.Type) -> T? {
        return (try? JSONDecoder().decode(T.self, from: self.encode()))
    }
}
struct SignUpModel: Codable{
    
}

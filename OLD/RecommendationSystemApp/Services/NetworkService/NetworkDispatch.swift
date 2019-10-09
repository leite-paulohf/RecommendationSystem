//
//  NetworkDispatch.swift
//  RSystemApp
//
//  Created by Paulo Henrique Leite on 08/12/2017.
//  Copyright © 2017 RSystemApp. All rights reserved.
//

import Foundation
import ObjectMapper

class NetworkDispatch: NetworkBaseService {
    
    static let shared = NetworkDispatch()

    typealias MappableHandler <T: Mappable> = (NetworkResult<T, NetworkError, Int>) -> Void
    
    typealias MappableArrayHandler <T: Mappable> = (NetworkResult<[T], NetworkError, Int>) -> Void
    
    func post<T: Mappable>(service: NetworkService, key: String? = nil, handler: @escaping MappableHandler<T>) {
        Network.post(service: service).resume { (result) in
            switch result {
            case .success(let data, let code):
                if let key = key {
                    handler(self.handleModelObject(data: data, key: key, code: code))
                } else {
                    handler(self.handleModelObject(data: data, code: code))
                }
            case .failure(let error, let code):
                handler(self.handleError(error: error, code: code))
            }
        }
    }

    func post<T: Mappable>(service: NetworkService, key: String? = nil, handler: @escaping MappableArrayHandler<T>) {
        Network.post(service: service).resume { (result) in
            switch result {
            case .success(let data, let code):
                if let key = key {
                    handler(self.handleModelArray(data: data, key: key, code: code))
                } else {
                    handler(self.handleModelArray(data: data, code: code))
                }
            case .failure(let error, let code):
                handler(self.handleError(error: error, code: code))
            }
        }
    }

    func get<T: Mappable>(service: NetworkService, key: String? = nil, handler: @escaping MappableHandler<T>) {
        Network.get(service: service).resume { (result) in
            switch result {
            case .success(let data, let code):
                if let key = key {
                    handler(self.handleModelObject(data: data, key: key, code: code))
                } else {
                    handler(self.handleModelObject(data: data, code: code))
                }
            case .failure(let error, let code):
                handler(self.handleError(error: error, code: code))
            }
        }
    }
    
    func get<T: Mappable>(service: NetworkService, key: String? = nil, handler: @escaping MappableArrayHandler<T>) {
        Network.get(service: service).resume { (result) in
            switch result {
            case .success(let data, let code):
                if let key = key {
                    handler(self.handleModelArray(data: data, key: key, code: code))
                } else {
                    handler(self.handleModelArray(data: data, code: code))
                }
            case .failure(let error, let code):
                handler(self.handleError(error: error, code: code))
            }
        }
    }

    func put<T: Mappable>(service: NetworkService, key: String? = nil, handler: @escaping MappableHandler<T>) {
        Network.put(service: service).resume { (result) in
            switch result {
            case .success(let data, let code):
                if let key = key {
                    handler(self.handleModelObject(data: data, key: key, code: code))
                } else {
                    handler(self.handleModelObject(data: data, code: code))
                }
            case .failure(let error, let code):
                handler(self.handleError(error: error, code: code))
            }
        }
    }
    
    func put<T: Mappable>(service: NetworkService, key: String? = nil, handler: @escaping MappableArrayHandler<T>) {
        Network.put(service: service).resume { (result) in
            switch result {
            case .success(let data, let code):
                if let key = key {
                    handler(self.handleModelArray(data: data, key: key, code: code))
                } else {
                    handler(self.handleModelArray(data: data, code: code))
                }
            case .failure(let error, let code):
                handler(self.handleError(error: error, code: code))
            }
        }
    }

    func delete<T: Mappable>(service: NetworkService, key: String? = nil, handler: @escaping MappableHandler<T>) {
        Network.delete(service: service).resume { (result) in
            switch result {
            case .success(let data, let code):
                if let key = key {
                    handler(self.handleModelObject(data: data, key: key, code: code))
                } else {
                    handler(self.handleModelObject(data: data, code: code))
                }
            case .failure(let error, let code):
                handler(self.handleError(error: error, code: code))
            }
        }
    }
    
    func delete<T: Mappable>(service: NetworkService, key: String? = nil, handler: @escaping MappableArrayHandler<T>) {
        Network.delete(service: service).resume { (result) in
            switch result {
            case .success(let data, let code):
                if let key = key {
                    handler(self.handleModelArray(data: data, key: key, code: code))
                } else {
                    handler(self.handleModelArray(data: data, code: code))
                }
            case .failure(let error, let code):
                handler(self.handleError(error: error, code: code))
            }
        }
    }

}

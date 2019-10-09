//
//  NetworkService.swift
//  RSystemApp
//
//  Created by Paulo Henrique Leite on 20/07/17.
//  Copyright © 2017 RSystemApp. All rights reserved.
//

import Foundation

enum NetworkResult<T, NetworkError, Int> {
    case success(T, Int)
    case failure(NetworkError, Int)
}

enum NetworkError: Error {
    case undefined
    case withError(error: Error)
    case withDescription(description: String)

    func message() -> String {
        let undefined = "Algo de inesperado aconteceu e isso foi notificado!"
        switch self {
        case .undefined:
            return undefined
        case .withDescription(let description):
            return description
        case .withError(let error):
            return error.localizedDescription
        }
    }
    
    func code() -> Int {
        let undefined = -1
        switch self {
        case .withError(let error):
            return (error as NSError).code
        default:
            return undefined
        }
    }
    
}

enum NetworkResponse {
    case success(data: Data, code: Int)
    case failure(error: Error, code: Int)
}

enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

enum Service: String {
    case local = ""
    case mockv2 = "v2"
}

struct NetworkService {
    
    var api: Service = .mockv2
    var base: String = ""
    var path: String = ""
    var url: URL = URL(fileURLWithPath: "")
    var parameters: [String : Any]? = nil
    
    init(api: Service, path: String, parameters: [String : Any]? = nil) {
        switch api {
        case .local:
            self.base = "http://127.0.0.1:5000"
        case .mockv2:
            self.base = "http://www.mocky.io"
        }
        
        self.api = api
        self.path = path
        self.parameters = [:]
        
        if let url = URL(string: self.base) {
            self.url = url.appendingPathComponent(api.rawValue).appendingPathComponent(self.path)
        }
    }
    
}

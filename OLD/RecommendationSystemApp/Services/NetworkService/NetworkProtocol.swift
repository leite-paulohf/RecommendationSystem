//
//  NetworkDelegate.swift
//  RSystemApp
//
//  Created by Paulo Henrique Leite on 19/07/17.
//  Copyright © 2017 RSystemApp. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

protocol NetworkDelegate {
    typealias Handler = (NetworkResponse) -> Void
    func resume(handler: @escaping Handler)
}

enum Network: NetworkDelegate {
    case get(service: NetworkService)
    case post(service: NetworkService)
    case put(service: NetworkService)
    case delete(service: NetworkService)

    func resume(handler: @escaping Handler) {
        var request: URLRequest!

        switch self {
        case .get(let service):
            request = self.request(service: service, httpMethod: .get)
        case .post(let service):
            NVActivityIndicatorView.activity.show()
            request = self.request(service: service, httpMethod: .post)
        case .put(let service):
            NVActivityIndicatorView.activity.show()
            request = self.request(service: service, httpMethod: .put)
        case .delete(let service):
            NVActivityIndicatorView.activity.show()
            request = self.request(service: service, httpMethod: .delete)
        }

        URLSession.shared.configuration.timeoutIntervalForRequest = 36000
        URLSession.shared.configuration.timeoutIntervalForResource = 36000
        URLSession.shared.configuration.allowsCellularAccess = true

        if #available(iOS 11.0, *) {
            URLSession.shared.configuration.waitsForConnectivity = true
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async() {
                NVActivityIndicatorView.activity.hide()
                let response = response as? HTTPURLResponse ?? HTTPURLResponse()
                let data = data ?? Data()
                let code = response.statusCode

                switch code {
                case 200 ... 299:
                    Log.shared.show(info: "\(code)")
                    let JSON = String(data: data, encoding: String.Encoding.utf8) ?? ""
                    Log.shared.show(info: "\(JSON)")
                    handler(NetworkResponse.success(data: data, code: code))
                default:
                    Log.shared.show(error: "\(code)")
                    let JSON = String(data: data, encoding: String.Encoding.utf8) ?? ""
                    Log.shared.show(error: "\(JSON)")
                    let error = error as NSError? ?? NSError.from(code: code, data: data)
                    handler(NetworkResponse.failure(error: error, code: code))
                }
            }
        }

        URLSession.shared.getAllTasks { tasks in
            let contains = tasks.contains(where: {
                $0.originalRequest?.hashValue == task.originalRequest?.hashValue
            })

            if !contains {
                task.resume()
            }
        }
    }

    private func request(service: NetworkService, httpMethod: HTTPMethod) -> URLRequest {
        var request = URLRequest(url: service.url)
        request.httpMethod = httpMethod.rawValue
        let parameters = service.parameters ?? [:]
        request = NetworkEncoding().encode(request, with: parameters)
        let curl = self.curl(request: request, pretty: true)
        Log.shared.show(info: curl)
        return request
    }

    private func curl(request: URLRequest, pretty: Bool = false) -> String {
        let complement = pretty ? "\\\n" : ""
        let method = "-X \(request.httpMethod ?? "GET") \(complement)"
        let str = request.url?.absoluteString ?? ""
        let url = "\"" + str + "\""
        let body = String(data: request.httpBody ?? Data(), encoding: .utf8) ?? ""
        let data = "-d \"\(body)\" \(complement)"

        var header = ""
        request.allHTTPHeaderFields?.forEach {
            header += "-H \"\($0.key): \($0.value)\" \(complement)"
        }

        let command = "curl " + complement + method + header + data + url

        return command + " | python -mjson.tool"
    }

}

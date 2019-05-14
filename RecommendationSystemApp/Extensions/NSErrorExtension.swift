//
//  NSErrorExtension.swift
//  RSystemApp
//
//  Created by Paulo Henrique Leite on 27/02/19.
//  Copyright © 2019 RSystemApp. All rights reserved.
//

import Foundation

extension NSError {
    
    class func from(code: Int, data: Data) -> NSError {
        let domain = Bundle.main.bundleIdentifier ?? "undefined"
        let description = self.description(code)
        let userInfo = [NSLocalizedDescriptionKey : description]
        let error = NSError(domain: domain, code: code, userInfo: userInfo)
        return error
    }

    class func description(_ code: Int) -> String {
        switch code {
        case 0:
            return "A conexão da internet parece estar desligada."
        case 400:
            return "[400]: Solicitação está incorreta."
        case 401:
            return "[401]: Solicitação não autorizada. É necessário entrar com sua conta."
        case 403:
            return "[403]: Solicitação não permitida."
        case 404:
            return "[404]: Solicitação não encontrada."
        case 408, -1001:
            return "O tempo limite da solicitação expirou."
        case 410:
            return "[410]: Solicitação perdida."
        case 501:
            return "[501]: Solicitação não implementada."
        case 503:
            return "[503]: Serviço indisponível no momento."
        case 550:
            return "[550]: Permissão negada."
        default:
            return "[\(code)]: Algo de inesperado aconteceu e isso foi notificado!"
        }
    }
    
}

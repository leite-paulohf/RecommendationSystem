//
//  Enum.swift
//  RSystemApp
//
//  Created by Paulo Henrique Leite on 13/12/2017.
//  Copyright © 2017 RSystemApp. All rights reserved.
//

import Foundation

enum TabbarType: String {
    case home, search, validations, profile
    
    var index: Int {
        switch self {
        case .home:
            return 0
        case .search:
            return 1
        case .validations:
            return 2
        case .profile:
            return 3
        }
    }
}

enum ProfileItemType: String {
    case favourites, promocode, logout, tutorial, faq, zendesk, concierge, none
    case subscriptionDetail = "subscription_detail"
    case personalDetail     = "personal_detail"
    case getMember          = "get_member"
    case requestRestaurant  = "request_restaurant"
}

enum StoryboardType: String {
    case authentication, availabilities, usage, filter, home, launch, main, onboarding, profile, restaurant, search, validations, web
    
    var name: String {
        return self.rawValue.capitalized
    }
}

enum AuthenticationType: String {
    case email, cpf, facebook, google, deeplink, none
}

enum FilterType: String {
    case none, order, seats, date, hours, cuisine, city, neighborhood
    case price  = "price_range"
    case offers = "available_offer"
    
    var title: String {
        switch self {
        case .city:
            return "Cidades"
        case .order:
            return "Odernação"
        case .seats:
            return "Número de pessoas"
        case .date:
            return "Data"
        case .hours:
            return "Hora"
        case .cuisine:
            return "Cozinhas"
        case .neighborhood:
            return "Bairros"
        default:
            return "Filtros"
        }
    }    
}

enum OfferType: String {
    case checkin, booking, delivery
    
    var value: String {
        switch self {
        case .checkin:
            return "check-in"
        case .booking:
            return "reserva"
        default:
            return self.rawValue
        }
    }
}

enum OrderType: String {
    case newest, nearest, ranking, recommended
    
    var title: String {
        switch self {
        case .recommended:
            return "Recomendados"
        case .ranking:
            return "Destaques"
        case .newest:
            return "Novidades"
        case .nearest:
            return "Mais próximos"
        }
    }
}

enum TimeType: String {
    case all            = "Todos"
    case lunch          = "Almoço"
    case dinner         = "Jantar"
    case search_next    = "Agora"
    case hour           = ""
}

enum HighlightsType: String {
    case grid = "restaurant_grid"
    case banner
    case none
}

enum PhotoType: String {
    case profile, cover, gallery
}

enum GalleryType: String {
    case thumb, photo
}

enum AvailabilityType: String {
    case seats, dates, hours
}

enum Controller: String {
    case webview, map, list, favourite, validations
}

enum DeepLinkType: String {
    case push = "push"
    case link = "deeplink"
}

enum ContextType: String {
    case search, restaurant, webview, tabbar, none
    case profileItem = "profile_item"
}

enum SegmentType: String {
    case detail, gallery, feedback
}

enum SolverType: String {
    case none, authentication, profile, facebook, google
}

enum AKMaskFieldType: String {
    case name, birthdate, phone, cep, number, complement, none
}

enum EmptyTable: String {
    case search, favourites, none
}

enum TipsType: Int {
    case list, restaurant, none
}

enum SubscriptionStatus: String {
    case valid, expired, none
}

enum GenderType: String {
    case M, F, none
    
    var title: String {
        switch self {
        case .M:
            return "Masculino"
        case .F:
            return "Feminino"
        default:
            return "Não definido"
        }
    }
}

enum ValidationStatusType {
    case canceled, rating, confirm
}

enum FromContextType: String {
    case home, list, search, map, favourite, history, push, deeplink, none
}

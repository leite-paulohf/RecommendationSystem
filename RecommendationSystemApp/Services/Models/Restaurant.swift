//
//  Restaurant.swift
//  RSystemApp
//
//  Created by Paulo Henrique Leite on 03/04/2018.
//  Copyright © 2018 RSystemApp. All rights reserved.
//

import Foundation
import ObjectMapper

class Restaurant: Mappable {
  
    var uuid: String?
    var name: String?
    var slug: String?
    var priceRange: Int?
    var website: String?
    var formattedPhoneNumber: String?
    var availableOffers: [OfferType]?
    var cuisine: String?
    var cuisines: [String]?
    var amenities: [String]?
    var averageRating: Double?
    var reviewCount: Int?
    
    required init?(map: Map) {}

    init() {}
    
    func mapping(map: Map) {
        self.uuid <- map["uuid"]
        self.name <- map["name"]
        self.slug <- map["slug"]
        self.priceRange <- map["price_range"]
        self.website <- map["website"]
        self.formattedPhoneNumber <- map["formatted_phone_number"]
        self.availableOffers <- map["available_offers"]
        self.cuisine <- map["main_cuisine"]
        self.cuisines <- map["cuisines"]
        self.amenities <- map["amenities"]
        self.averageRating <- map["average_rating"]
        self.reviewCount <- map["review_count"]
    }
    
}

extension Int {
    
    var dollar: String {
        if self <= 1 {
            return "$"
        } else {
            var value: String = ""
            (1...self).forEach { _ in value.append("$") }
            return value
        }
    }
    
}

//
//  TravelPicker.swift
//  maptest
//
//  Created by Admin on 29.01.2023.
//

import SwiftUI

struct coords : Codable {
    var lat : Double
    var lng : Double
}

struct transportation : Codable {
    var type : String
    var walking_time : Int = 900
}

struct range : Codable {
    var enabled : Bool = true
    var width : Int = 1
}
struct Search : Codable {
    var id : String
    var coords : coords
    var departure_time : String
    var travel_time : Int
    var transportation : transportation
    var range : range
}

let samplesearch = Search(id: "Prague" ,coords: coords(lat: 50.11, lng: 14.444), departure_time: "2023-01-24T13:00:00Z", travel_time: 1500, transportation: transportation(type: "public_transport"), range: range())

struct DepartureSearches : Codable{
    var departure_searches : [Search]
}

func ISO8601fromDate (date: Date) -> String{
    let dateformatter = DateFormatter()
    dateformatter.locale = Locale(identifier: "en_US_POSIX")
    dateformatter.timeZone = TimeZone(abbreviation: "UTC")
    dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    
    return dateformatter.string(from: date)
}

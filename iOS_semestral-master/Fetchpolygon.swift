//
//  Fetchpolygon.swift
//  maptest
//
//  Created by Admin on 06.02.2023.
//

import Foundation
import MapKit


class FetchPolygon : ObservableObject{
    func getmultipolygon(search: Search) async -> MKMultiPolygon? {
        let url_string = "https://api.traveltimeapp.com/v4/time-map"
        
        guard let url = URL(string: url_string) else {
            print("Invalid URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
       
        var searches : [Search] = []
        searches.append(search)
        let DepartureSearches = DepartureSearches(departure_searches: searches)

        request.httpBody = try? JSONEncoder().encode(DepartureSearches)
        
        request.allHTTPHeaderFields = [
            "Content-Type" : "application/json",
            "Accept" : "application/geo+json",
            "X-Application-Id" : "b2642f74", //b2642f74  b74146dd
            "X-Api-Key" : "2fb5d724f697a57da43afda6cb32aa5d" //2fb5d724f697a57da43afda6cb32aa5d  2b1d3be707d2d21868855636cf7a65ef
        ]
        do{
            let(data,response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else{ return nil }
            
            if response.statusCode == 200{
                    var geoJson = [MKGeoJSONObject]()
                    geoJson = try MKGeoJSONDecoder().decode(data)
                    
                for item in geoJson {
                    if let feature = item as? MKGeoJSONFeature{
                        for geo in feature.geometry {
                            if let multipol = geo as? MKMultiPolygon {
                                return multipol
                            }
                        }
                    }
                }
            }
            else{
                print("Bad response code, something went wrong.")
                return nil
            }
        }
        catch {
            print("Unable to decode geojson")
            return nil
        }
        return nil
    }
}

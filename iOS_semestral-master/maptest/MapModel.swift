//
//  MapModel.swift
//  maptest
//
//  Created by Admin on 28.01.2023.
//

import Foundation
import MapKit

struct Address: Codable {
    let data: [Datum]
}

struct Datum: Codable{
    let latitude, longitude: Double
    let name: String?
}

struct Location: Identifiable{
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

class MapAPI: ObservableObject{
    private let BASE_URL = "http://api.positionstack.com/v1/forward"
    private let API_KEY = "492f58d18cf9e9c5b9a49ae9cf58a1ed"
    
    let delta = 0.1
    @Published var region: MKCoordinateRegion
    @Published var coordinates : [Double] = []
    @Published var latitude : Double = 0
    @Published var longditude : Double = 0
    @Published var locations: [Location] = []
    
    init() {
        self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.50, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta))
        
        self.locations.insert(Location(name: "Pin", coordinate: CLLocationCoordinate2D(latitude: 51.50, longitude: -0.1275)), at: 0)
    }
    func findnearbyplaces(text: String, region: MKCoordinateRegion){
        self.locations = []
        let searchrequest = MKLocalSearch.Request()
        searchrequest.naturalLanguageQuery = text
        
        searchrequest.region = region
        
        let search = MKLocalSearch(request: searchrequest)
        search.start{ (response,error)  in
            guard let response = response else {
                print("Bad response.")
                return
            }
            
            for item in response.mapItems{
                self.locations.append(
                    Location(name: item.name!, coordinate: item.placemark.coordinate))
            }
        }
    }
    
    func getLocation(address: String){
        let pAddress = address.replacingOccurrences(of: " ", with: "%20")
        let url_string = "\(BASE_URL)?access_key=\(API_KEY)&query=\(pAddress)"
        
        guard let url = URL(string: url_string) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error)  in
            guard let data = data else {
                print(error!.localizedDescription)
                return
            }
            
            guard let newCoordinates = try? JSONDecoder().decode(Address.self, from: data) else { return }
            
            if newCoordinates.data.isEmpty{
                print("Could not find the address...")
                return
            }
            
            DispatchQueue.main.async{
                let details = newCoordinates.data[0]
                let lat = details.latitude
                let lon = details.longitude
                let name = details.name
                
                self.coordinates = [lat,lon]
                self.latitude = lat
                self.longditude = lon
                self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lon), span: MKCoordinateSpan(latitudeDelta: self.delta, longitudeDelta: self.delta))
                
                let new_location = Location(name: name ?? "Pin", coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
                self.locations.removeAll()
                self.locations.insert(new_location, at: 0)
                
                print("Successfully loaded the location!")
                
            }
        }
        .resume()
    }
}

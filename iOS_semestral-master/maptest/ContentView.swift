//
//  ContentView.swift
//  maptest
//
//  Created by Admin on 28.01.2023.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject private var mainmapAPI = MapAPI()
    @State private var text = ""
    @State private var place = ""
    @State private var lat = ""
    @State private var lng = ""
    @State private var selectedPlace: Location?
    @State private var search : Search = samplesearch
    
    var body: some View {
        NavigationStack{
        VStack{
            TextField("Enter an address", text: $text)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            TextField("Enter a place you are looking for", text: $place)
                .onChange(of: place){ _ in
                    mainmapAPI.findnearbyplaces(text: place, region: mainmapAPI.region)}
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
//            Text(lat)
//            Text(lng)
            
            Button("Find address"){
                mainmapAPI.getLocation(address: text)
                mainmapAPI.findnearbyplaces(text: place, region: mainmapAPI.region)
            }.onChange(of: mainmapAPI.latitude) {
                _ in
                lng = String(format: "%f", mainmapAPI.longditude )
                lat = String(format: "%f", mainmapAPI.latitude )
            }
        
            if let place = selectedPlace{
                NavigationLink(destination: TravelPickerView(search: search)){
                    Text(place.name)
                }
            }
                
                
            Map(coordinateRegion: $mainmapAPI.region, annotationItems: mainmapAPI.locations){  location in                MapAnnotation(coordinate: location.coordinate){
                    VStack{
                        Image(systemName: "star.circle")
                            .resizable()
                            .foregroundColor(.blue)
                            .frame(width: 44, height: 44)
                            .background(.white)
                            .clipShape(Circle())
                    }.onTapGesture {
                        selectedPlace = location
                        search.id = location.name
                        search.coords.lat = location.coordinate.latitude
                        search.coords.lng = location.coordinate.longitude
                    }
                }

            }
            .onAppear(){
                lng = String(format: "%f", mainmapAPI.longditude )
                lat = String(format: "%f", mainmapAPI.latitude )
            }
            .onChange(of: mainmapAPI.region.center.latitude
            ){ newValue in
                if let latitude = Double(lat) {
                    let delta = abs(newValue - latitude)
                    if delta > 0.01{
                        mainmapAPI.findnearbyplaces(text: place, region: mainmapAPI.region)
                    }
                }
            }
            .ignoresSafeArea()
        }
        }.navigationDestination(for: String.self) {string in Text(string)}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

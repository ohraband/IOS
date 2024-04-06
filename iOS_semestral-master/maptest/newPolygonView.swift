//
//  PolygonView.swift
//  maptest
//
//  Created by Admin on 28.01.2023.
//

import SwiftUI
import MapKit


struct newPolygonView: View {
    @State var multipolygon: MKMultiPolygon?
    @State var updatepolygon = true
    
    @StateObject var mapAPI = MapAPI()
    @Binding var search : Search
    
    //@State private var text : String = ""
    @State private var place = ""
    @State private var saved = false
    
    @StateObject var fetchpolygon: FetchPolygon
    @StateObject var favouritesLoader = FavouritesLoader()
    
    var body: some View {
        VStack{
            TextField("Enter an address", text: $search.id)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            TextField("Enter a place", text: $place)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            HStack{
                Button(action: {
                    self.saved = true
                    favouritesLoader.departuresearches.departure_searches.append(search)
                    favouritesLoader.save()
                }){
                    Text("Save search")
                    
                }.foregroundColor(saved ? .green : .blue)
                    .onChange(of: mapAPI.region.center.latitude){_ in self.saved = false}
                
                Spacer()
                
                Button("Find address"){
                    mapAPI.getLocation(address: search.id)
                }.onChange(of: mapAPI.region.center.latitude){ _ in
//                    search.id = text
                    search.coords.lat = mapAPI.latitude
                    search.coords.lng = mapAPI.longditude
                    Task{
                        let newpolygon = await fetchpolygon.getmultipolygon(search: search)
                        if newpolygon != nil {
                            multipolygon = newpolygon
                            updatepolygon = true
                        }
                    }
                                    }
            }.padding(20)
            Text("\(mapAPI.region.center.latitude)")
            Text("\(mapAPI.region.center.longitude)")
            MapView(multipolygon: $multipolygon, mapAPI: mapAPI, mapViewDelegate: MapViewDelegate(message: place, centerCoord: mapAPI.region.center), centerCoord: $mapAPI.region.center, message: $place, updatepolygon: $updatepolygon)
                .onAppear {
                mapAPI.getLocation(address: search.id)
                Task{
                    let newpolygon = await fetchpolygon.getmultipolygon(search: search)
                    if newpolygon != nil {
                        multipolygon = newpolygon
                        updatepolygon = true
                    }
                }
                            }
            .ignoresSafeArea()
            
        }.onAppear{
            favouritesLoader.load()
        }
    }
}

struct newPolygonView_Previews: PreviewProvider {
    static var previews: some View {
        newPolygonView(search: .constant(samplesearch), fetchpolygon: FetchPolygon())
    }
}

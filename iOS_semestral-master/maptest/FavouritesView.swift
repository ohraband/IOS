//
//  FavouritesView.swift
//  maptest
//
//  Created by Admin on 31.01.2023.
//

import SwiftUI

struct FavouritesView: View {
    @StateObject var mapAPI = MapAPI()
    @State private var text : String = ""
    @State var departuresearches = DepartureSearches(departure_searches: [])
    @StateObject var favouritesLoader = FavouritesLoader()
    
    
    var body: some View {
        
        NavigationStack{
            List {
                ForEach(0 ..< favouritesLoader.departuresearches.departure_searches.count, id: \.self){ index in
                        NavigationLink(destination: TravelPickerView(search: favouritesLoader.departuresearches.departure_searches[index])){
                            VStack{
                                HStack{
                                    Image(systemName: "map.fill").foregroundColor(.orange).imageScale(.large)
                                    Text(favouritesLoader.departuresearches.departure_searches[index].id).fontWeight(.bold)
                                    Spacer()
                                }
                                HStack{
                                    Text("\(favouritesLoader.departuresearches.departure_searches[index].transportation.type)").foregroundColor(.secondary)
                                    Text("\(favouritesLoader.departuresearches.departure_searches[index].travel_time / 60) min." ).foregroundColor(.secondary)
                                    Spacer()
                                }
                            }
                        }.listRowBackground(Color.white.opacity(0.85))
                }.onDelete(perform: favouritesLoader.delete)
                            
            }.scrollContentBackground(.hidden)
               

            .navigationDestination(for: String.self) {string in
                Text(string)
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .navigationTitle(Text("Favourites"))
            
            .background(.linearGradient(colors: [.gray, .white, .gray], startPoint: .top, endPoint: .bottom))
            
        }.onAppear{
            favouritesLoader.load()}
        .refreshable {
            favouritesLoader.load()}
    }
}

struct FavouritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavouritesView()
    }
}

//
//  FavouritesLoader.swift
//  maptest
//
//  Created by Admin on 06.02.2023.
//

import Foundation

class FavouritesLoader : ObservableObject {
    @Published var departuresearches = DepartureSearches(departure_searches: [])
    
    init(){
        load()
    }
    func save() {
        do{
            let jsonURL = URL.documentsDirectory.appending(path: "FavouriteLoactions.json")
            let parentsData = try JSONEncoder().encode(departuresearches)
            try parentsData.write(to: jsonURL)
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    func load(){
        let jsonURL = URL.documentsDirectory.appending(path: "FavouriteLoactions.json")
        if FileManager().fileExists(atPath: jsonURL.path) {
            do{
                let jsonData = try Data(contentsOf: jsonURL)
                departuresearches = try JSONDecoder().decode(DepartureSearches.self, from: jsonData)
            }
            catch{
                print(error.localizedDescription)
            }
        }
    }
    
    func delete(at offsets : IndexSet){
        departuresearches.departure_searches.remove(atOffsets: offsets)
        self.save()
    }

}

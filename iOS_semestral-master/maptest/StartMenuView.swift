//
//  StartMenuView.swift
//  maptest
//
//  Created by Admin on 29.01.2023.
//

import SwiftUI

struct StartMenuView: View {
    var body: some View {
        NavigationStack {
            List{
                NavigationLink(destination: TravelPickerView() ){
                    HStack{
                        Image(systemName: "hexagon.fill")
                            .font(.title)
                        Text("Make an isochrone polygon")
                            .fontWeight(.semibold)
                    } .padding()
                    .foregroundColor(.black)
                    .cornerRadius(40)
                }.listRowBackground(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.white]), startPoint: .leading, endPoint: .trailing))
                
               
                
                NavigationLink(destination: FavouritesView() ){
                    HStack{
                        Image(systemName: "star.fill")
                            .font(.title)
                        Text("Favourite locations")
                            .fontWeight(.semibold)
                    } .padding()
                    .foregroundColor(.black)
                    .cornerRadius(40)

                }.listRowBackground(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.white]), startPoint: .leading, endPoint: .trailing))
                
                
                NavigationLink(destination: ContentView() ){
                    HStack{
                        Image(systemName: "map.fill")
                            .font(.title)
                        Text("Browse maps")
                            .fontWeight(.semibold)
                    } .padding()
                    .foregroundColor(.black)
                    .cornerRadius(40)

                }.listRowBackground(LinearGradient(gradient: Gradient(colors: [Color.gray, Color.white]), startPoint: .leading, endPoint: .trailing))
                
                    
                    

            }.padding(.top, 80)
            .scrollContentBackground(.hidden)
            .background(.linearGradient(colors: [Color.yellow, .gray, Color.white], startPoint: .top, endPoint: .bottomTrailing))
            .navigationDestination(for: String.self) {string in
                Text(string)
            }
            .toolbar{
                ToolbarItem(placement: . principal){
                    Text("Start Menu")
                        .font(.largeTitle)
                        .accessibilityAddTraits(.isHeader)
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle(Text("Start menu"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct StartMenuView_Previews: PreviewProvider {
    static var previews: some View {
        StartMenuView()
    }
}

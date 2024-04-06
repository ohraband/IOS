//
//  TravelPickerView.swift
//  maptest
//
//  Created by Admin on 29.01.2023.
//

import SwiftUI
struct TravelPickerView: View {
    @State var search = samplesearch
    @State private var selectedDate = Date()

    
    var body: some View {
        VStack{
        NavigationStack{
                VStack{
                    Text("\(search.id)").font(.largeTitle)
                    
                    Text("Choose your travel parameters").padding(50)
                    
                    Picker("Transportation type", selection: $search.transportation.type){
                        Text("walking").tag("walking")
                        Text("public transport").tag("public_transport")
                        Text("driving").tag("driving")
                        Text("cycling").tag("cycling")
                        Text("train").tag("train")
                        Text("bus").tag("bus")
                    }
                    ZStack(){
                        Text("Travel time: \(String(search.travel_time / 60)) minutes")
                        Stepper("", value: $search.travel_time, in:1...14400,
                                step: 60)
                    }

                    ZStack(){
                        Text("Walking time: \(String(search.transportation.walking_time / 60)) minutes")
                        Stepper("", value:
                                    $search.transportation.walking_time, in:0...search.travel_time,
                                step: 60)
                        .onChange(of: search.travel_time) {
                            newValue in
                            if search.transportation.walking_time > search.travel_time {
                                search.transportation.walking_time = search.travel_time
                            }
                        }
                    }
                    ZStack(){
                        Text("Exit window: \(String(search.range.width / 60)) minutes").lineLimit(2)
                        Stepper("", value: $search.range.width, in:1...43200,
                                step: 600)
                    }
                    Text(" Departure time:")

                    DatePicker("", selection: $selectedDate).onSubmit {
                        search.departure_time = ISO8601fromDate(date: selectedDate)
                    }.labelsHidden()

                    }.padding(.bottom,150)
                .fontWeight(.semibold)

                NavigationLink(destination: newPolygonView(search: $search, fetchpolygon: FetchPolygon() )){
                    HStack{
                        Image(systemName: "hexagon.fill")
                            .font(.title)
                        Text("Make an isochrone polygon")
                            .fontWeight(.semibold)
                    } .padding()
                    .foregroundColor(.white)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.yellow]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(40)

                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: String.self) {string in
                    Text(string)
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct TravelPickerView_Previews: PreviewProvider {
    static var previews: some View {
        TravelPickerView()
    }
}

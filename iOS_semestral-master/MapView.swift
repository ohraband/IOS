//
//  MapView.swift
//  maptest
//
//  Created by Admin on 29.01.2023.
//

import Foundation
import MapKit
import SwiftUI


struct MapView: UIViewRepresentable {
    @Binding var multipolygon: MKMultiPolygon?
    @ObservedObject var mapAPI = MapAPI()
    let mapViewDelegate : MapViewDelegate
    @Binding var centerCoord: CLLocationCoordinate2D
    @Binding var message : String
    @Binding var updatepolygon : Bool
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        view.delegate = mapViewDelegate
        view.translatesAutoresizingMaskIntoConstraints = false
        
        (view.delegate as? MapViewDelegate)?.message = message
        (view.delegate as? MapViewDelegate)?.centerCoord = centerCoord

        if updatepolygon == true {
            addmultipolygon(to: view)
            updatepolygon = false
        }
    }
}

private extension MapView {
    func addmultipolygon(to view: MKMapView){
        //delete previous polygons
        if !view.overlays.isEmpty {
            view.removeOverlays(view.overlays)
            
        }
    
        guard let multipolygon = multipolygon else { return }
        
        let mapRect = multipolygon.boundingMapRect
        view.setVisibleMapRect(mapRect, edgePadding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), animated: true)
        view.addOverlay(multipolygon)
    }
}

class MapViewDelegate: NSObject, MKMapViewDelegate {
    var message : String
    var centerCoord : CLLocationCoordinate2D

    init(message: String, centerCoord: CLLocationCoordinate2D){
        self.message = message
        self.centerCoord = centerCoord
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let multipolygon = overlay as? MKMultiPolygon {
            let renderer = MKMultiPolygonRenderer(multiPolygon: multipolygon)
            renderer.fillColor = UIColor(red: 1, green: 0.45, blue: 0, alpha: 0.15)
            renderer.strokeColor = UIColor.orange.withAlphaComponent(0.8)
            return renderer
        }
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.fillColor = UIColor.red.withAlphaComponent(0.5)
        renderer.strokeColor = UIColor.red.withAlphaComponent(0.8)
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //deprecated but it looks better than the new one
        let annotationview = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "id")
        annotationview.canShowCallout = true
        if annotation.coordinate.latitude == centerCoord.latitude && annotation.coordinate.longitude == centerCoord.longitude {
            annotationview.pinTintColor = .red
        }
        else{
            annotationview.pinTintColor = .green
        }
        //annotationview.animatesDrop = true
        return annotationview
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let searchrequest = MKLocalSearch.Request()
        searchrequest.naturalLanguageQuery = message
        
        searchrequest.region = MKCoordinateRegion(center: mapView.centerCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        
        let search = MKLocalSearch(request: searchrequest)
        search.start{ (response,error)  in
            guard let response = response else {
                print("Error in search response.")
                return
            }
            mapView.removeAnnotations(mapView.annotations)
            for item in response.mapItems{
                let annotation = MKPointAnnotation(__coordinate: item.placemark.coordinate)
                if item.placemark.name != nil {
                    annotation.title = item.placemark.name
                }
                if item.placemark.title != nil {
                    annotation.subtitle = item.placemark.title
                }
                mapView.addAnnotation(annotation)
            }
            mapView.addAnnotation(MKPointAnnotation(__coordinate: self.centerCoord))
        }
    }
    
}

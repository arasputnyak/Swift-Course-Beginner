//
//  ShowMapController.swift
//  Lesson5Task
//
//  Created by Анастасия Распутняк on 20.08.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

import UIKit
import MapKit

class ShowMapController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    fileprivate let locationManager = CLLocationManager()
    var currentLocation : CLLocationCoordinate2D!
    var destination = CLLocationCoordinate2D(latitude: 59.799520  , longitude: 30.271164)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "Map"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show airport", style: .plain, target: self, action: #selector(actionShow))
        
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        mapView.showsUserLocation = true
        mapView.delegate = self
        
    }
    

    @objc func actionShow(sender: UIBarButtonItem) {
        
        let coordinates = destination
        let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        
        let airportPin = CustomAnnotation(title: "Pulkovo Airport", locationName: nil, coordinate: coordinates)
        
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            guard error == nil else {
                return
            }
            
            let placemark = placemarks?.first
            let adress = "country: \(placemark?.country ?? "")\ncity: \(placemark?.locality ?? "")\nstreet: \(placemark?.thoroughfare ?? "") \(placemark?.subThoroughfare ?? "")"
            
            airportPin.locationName = adress
        }
        
        mapView.addAnnotation(airportPin)
        
        let region = MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
    }

}


extension ShowMapController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            currentLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: currentLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapView.setRegion(region, animated: true)
        }
    }
}


extension ShowMapController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? CustomAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
            annotationView!.pinTintColor = MKPinAnnotationView.purplePinColor()
            annotationView!.animatesDrop = true
            annotationView!.canShowCallout = true
            
            let routeButton = UIButton(type: .contactAdd)
            routeButton.addTarget(self, action: #selector(actionGetRoute), for: .touchUpInside)
            annotationView!.rightCalloutAccessoryView = routeButton
            
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = UIColor.green
        polylineRenderer.lineWidth = 5
        
        return polylineRenderer
        
    }
    
    @objc func actionGetRoute(sender: UIButton) {
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: currentLocation))
        directionRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { response, error in
            guard error == nil else {
                return
            }
            
            guard let response = response else {
                return
            }
            
            if let route = response.routes.first {
                self.mapView.addOverlay(route.polyline, level: .aboveRoads)
                
                let rect = route.polyline.boundingMapRect
                self.mapView.region = MKCoordinateRegion(rect)
            }
        }
    }
}

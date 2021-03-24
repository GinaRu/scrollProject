//
//  MapaVC.swift
//  scrollProject
//
//  Created by Georgina Rubira Pairó on 23/03/2021.
//

import UIKit
import MapKit
import CoreLocation

class MapaVC: UIViewController {

    @IBOutlet var mapaView: MKMapView!
    
    let locationManager = CLLocationManager()
    var userCoordinates = [CLLocation]()
    var currentPolyline: MKPolyline? = nil
    var isFollowingUserLocation: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        mapaView.delegate = self
        checkLocationServices()
    }
    
    func checkLocationServices () {
        if CLLocationManager.locationServicesEnabled() {
            checkLocationAuthoritzation()
        }
    }
    func checkLocationAuthoritzation()  {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
        case .authorizedWhenInUse:
            mapaView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        case .restricted:
            mapaView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        case .denied:
            break
        case .authorizedAlways:
            mapaView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    
    func updatePolyline() {
//        var coordinates: [CLLocationCoordinate2D]
//        for userLocation in userCoordinates {
//            coordinates.append(userLocation.coordinate)
//        }
        // Lo mismo que:
        let coordinates: [CLLocationCoordinate2D] = userCoordinates.map{$0.coordinate}
        let newPolyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapaView.addOverlay(newPolyline)
        
        if let currentPolyline = currentPolyline {
            mapaView.removeOverlay(currentPolyline)
        }
        currentPolyline = newPolyline

    }
}

extension MapaVC: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {

            let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                userCoordinates.append(location)
                updatePolyline()
                mapaView.setRegion(region, animated: true)
            }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("HI HA HAGUT UN ERROR: \(error)")
    }
    
    
}

extension MapaVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let routePolyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: routePolyline)
                renderer.strokeColor = UIColor.magenta.withAlphaComponent(0.8)
                renderer.lineWidth = 7
                return renderer
            }
            return MKOverlayRenderer()
        }
}

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


    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
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
}

extension MapaVC: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {

            let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                mapaView.setRegion(region, animated: true)
            }
        


    }

    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("HI HA HAGUT UN ERROR: \(error)")
    }
    
    
}

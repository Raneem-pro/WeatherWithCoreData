//
//  LocationManager.swift
//  WeatherWithCoreData
//
//  Created by رنيم القرني on 14/10/1445 AH.
//

import Foundation
import Foundation
import CoreLocation


class LocationManager: NSObject , ObservableObject , CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var location : CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestLocation(){
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations location: [CLLocation]) {
        guard let location = location.last else {return}
        self.location = location
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error:  Error) {
        print(error.localizedDescription)
    }
}

//
//  LocationManager.swift
//  SimpleFinance
//
//  Created by Marcos Salas on 18/12/24.
//

import Foundation

import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
    }

    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
}

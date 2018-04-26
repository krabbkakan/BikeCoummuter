//
//  StartViewController.swift
//  BikeCoummuter
//
//  Created by Erik Hede on 2018-04-10.
//  Copyright © 2018 Erik Hede. All rights reserved.
//

import Foundation
import UIKit
import MBCircularProgressBar
import CoreLocation
import ChameleonFramework
import MapKit

class StartViewController: UIViewController {

    
//   let locationManager : CLLocationManager = CLLocationManager()

    
//    let geoFenceRegion : CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(59.274697,  -18.127080), radius: 10, identifier: "Hem")
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var launchPromptStackView: UIStackView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var dataStackView: UIStackView!
    @IBOutlet weak var progressView: MBCircularProgressBarView!
    
    private var bikeRide : BikeRide?
    private let locationManager = LocationManager.shared
    private var seconds = 0
    private var timer: Timer?
    private var progressCircleTimer: Timer?
    private var distance = Measurement(value: 0, unit: UnitLength.meters)
    private var locationList: [CLLocation] = []
    private var locationListProgressCicle: [CLLocation] = []
    var kilometersBiked : Int = 0
    var kilometersGoal : Int = 10
    private var distanceBiked : Double = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        locationManager.requestWhenInUseAuthorization()
        
        progressView.value = CGFloat(0) // Uppdatera till sparat värde från firebase
        progressView.maxValue = CGFloat(kilometersGoal) // Uppdatera till sparat värde från firebase
        
//        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
//            self.kilometersBiked += 10
//        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        locationManager.stopUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        progressCircleTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            self.updateProgressCircle()
        }
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        var lastLocation : CLLocation = locations[0]
//        for currentLocation in locations {
//            print("\(index): \(currentLocation)")
//            self.kilometersBiked = measureDistance(start: lastLocation, stop: currentLocation)
//            lastLocation = currentLocation
//            self.locationListProgressCicle.append(currentLocation)
//        }
//
//        for newLocation in locations {
//            let howRecent = newLocation.timestamp.timeIntervalSinceNow
//            guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
//
//            if let lastLocation = locationList.last {
//                let delta = newLocation.distance(from: lastLocation)
//                distance = distance + Measurement(value: delta, unit: UnitLength.meters)
//                let coordinates = [lastLocation.coordinate, newLocation.coordinate]
//                mapView.add(MKPolyline(coordinates: coordinates, count: 2))
//                let region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 500, 500)
//                mapView.setRegion(region, animated: true)
//            }
//
//            locationList.append(newLocation)
//        }
//
//    }
    
    
    
    private func startBikeRide() {
        mapView.removeOverlays(mapView.overlays)
        seconds = 0

        locationList.removeAll()
        distance = Measurement(value: 0, unit: UnitLength.meters)
        launchPromptStackView.isHidden = true
        dataStackView.isHidden = false
        startButton.isHidden = true
        stopButton.isHidden = false
        updateDisplay()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.eachSecond()
        }
        startLocationUpdates()
        mapView.isHidden = false
    }
    
    private func stopBikeRide() {
        stopLocationUpdates()
        launchPromptStackView.isHidden = false
        dataStackView.isHidden = true
        startButton.isHidden = false
        stopButton.isHidden = true
    }
    
    func eachSecond() {
        seconds += 1
        updateDisplay()
    }
    
    private func updateDisplay() {
        let formattedDistance = FormatDisplay.distance(distance)
        let formattedTime = FormatDisplay.time(seconds)
        let formattedPace = FormatDisplay.pace(distance: distance,
                                               seconds: seconds,
                                               outputUnit: UnitSpeed.minutesPerMile)
        
        distanceLabel.text = "Distance:  \(formattedDistance)"
        timeLabel.text = "Time:  \(formattedTime)"
        paceLabel.text = "Pace:  \(formattedPace)"
    }


    
    private func startLocationUpdates() {
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
//        locationManager.startMonitoring(for: geoFenceRegion)
    }
    
    private func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
    }
    
    private func saveBikedDistance() {
        // spara den cyklade distansen till firebase
    }
    
    func goalReached() {
        progressView.value = CGFloat(kilometersGoal)
        UIView.animate(withDuration: 5.0) {
            self.progressView.progressColor = UIColor.flatWatermelonColorDark()
            self.progressView.progressLineWidth = CGFloat(25)
            self.progressView.progressStrokeColor = UIColor.flatWatermelon()
        }
    }
    
    func updateKilometersBiked() {
//        self.kilometersBiked = distance + Measurement(value: delta, unit: UnitLength.meters)
        if FormatDisplay.distanceInt(distance) != nil {
            self.kilometersBiked = FormatDisplay.distanceInt(distance)!
        }
    }
    
    func measureDistance(start: CLLocation, stop: CLLocation) -> Int {
        
        if let start = locationList.last {
            let delta = stop.distance(from: start)
            distance = distance + Measurement(value: delta, unit: UnitLength.meters)
        }
        let convertedDistance = distance.converted(to: UnitLength.kilometers)
        
        let kilometersBiked : Int = Int(convertedDistance.value)

        print("hej \(kilometersBiked)")


        return Int(kilometersBiked)
    }
    
    func updateProgressCircle() {
        UIView.animate(withDuration: 2.0) {
            self.progressView.value = CGFloat(self.kilometersBiked)
        }
        checkForReachedGoal()
    }
    
    func checkForReachedGoal() {
        if Int(self.progressView.value) >= self.kilometersGoal {
            goalReached()
        }
    }
    
    func updateProgressCircleKilometers(locations: [CLLocation]) {
        var lastLocation : CLLocation = locations[0]
        for currentLocation in locations {
            print("\(index): \(currentLocation)")
            self.kilometersBiked = measureDistance(start: lastLocation, stop: currentLocation)
            lastLocation = currentLocation
            self.locationListProgressCicle.append(currentLocation)
        }
    }
    
    //Geofencing
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print(region.identifier)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print(region.identifier)
    }
    
    private func saveRun() {
        let newBikeRide = BikeRide(context: CoreDataStack.context)
        newBikeRide.distance = distance.value
        newBikeRide.duration = Int16(seconds)
        newBikeRide.timestamp = Date()
        
        for location in locationList {
            let locationObject = Location(context: CoreDataStack.context)
            locationObject.timestamp = location.timestamp
            locationObject.latitude = location.coordinate.latitude
            locationObject.longitude = location.coordinate.longitude
            newBikeRide.addToLocations(locationObject)
        }
        
        CoreDataStack.saveContext()
        
        bikeRide = newBikeRide
    }
    
    @IBAction func startTapped(_ sender: UIButton) {
        startBikeRide()
    }
    
    @IBAction func stopTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "End bike ride?",
                                                message: "Do you wish to end your bike ride?",
                                                preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Save", style: .default) { _ in
            self.stopBikeRide()
            self.saveRun()
            self.performSegue(withIdentifier: .details, sender: nil)
        })
        alertController.addAction(UIAlertAction(title: "Discard", style: .destructive) { _ in
            self.stopBikeRide()
            _ = self.navigationController?.popToRootViewController(animated: true)
        })
        
        present(alertController, animated: true)
    }
    
}

extension StartViewController: SegueHandlerType {
    enum SegueIdentifier: String {
        case details = "goToBikeRideCompleted"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifier(for: segue) {
        case .details:
            let destination = segue.destination as! BikeRideCompletedViewController
            destination.bikeRide = bikeRide
        }
    }
}

extension StartViewController: CLLocationManagerDelegate {

     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for newLocation in locations {
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }

            if let lastLocation = locationList.last {
                let delta = newLocation.distance(from: lastLocation)
                distance = distance + Measurement(value: delta, unit: UnitLength.meters)
                let coordinates = [lastLocation.coordinate, newLocation.coordinate]
                mapView.add(MKPolyline(coordinates: coordinates, count: 2))
                let region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 500, 500)
                mapView.setRegion(region, animated: true)
            }

            locationList.append(newLocation)
        }
        updateProgressCircleKilometers(locations: locations)
    }
}

extension StartViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .blue
        renderer.lineWidth = 3
        return renderer
    }
}




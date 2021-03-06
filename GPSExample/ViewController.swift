//
//  ViewController.swift
//  GPSExample
//
//  Created by sherriff on 10/29/15.
//  Copyright © 2015 Mark Sherriff. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import CoreMotion

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    
    lazy var motionManager = CMMotionManager()
    var xDir: Double!
    var yDir: Double!
    var zDir: Double!
    
    // MARK: Properties
    
    @IBOutlet weak var lat: UILabel!
    @IBOutlet weak var lon: UILabel!
    @IBOutlet weak var xLabel: UILabel!
    @IBOutlet weak var yLabel: UILabel!
    @IBOutlet weak var zLabel: UILabel!
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.count == 0{
            //handle error here
            return
        }
        
        let newLocation = locations[0]
        
        print("Latitude = \(newLocation.coordinate.latitude)")
        print("Longitude = \(newLocation.coordinate.longitude)")
        lat.text = String(newLocation.coordinate.latitude)
        lon.text = String(newLocation.coordinate.longitude)
        
    }
    
    func locationManager(_ manager: CLLocationManager,
        didFailWithError error: Error){
            print("Location manager failed with error = \(error)")
    }
    
    private func locationManager(manager: CLLocationManager,
        didChangeAuthorizationStatus status: CLAuthorizationStatus){
            
            print("The authorization status of location services is changed to: ", terminator: "")
            
            switch CLLocationManager.authorizationStatus(){
            case .authorizedAlways:
                print("Authorized")
            case .authorizedWhenInUse:
                print("Authorized when in use")
            case .denied:
                print("Denied")
            case .notDetermined:
                print("Not determined")
            case .restricted:
                print("Restricted")
            }
            
    }
    
    func displayAlertWithTitle(title: String, message: String){
        let controller = UIAlertController(title: title,
            message: message,
            preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(title: "OK",
            style: .default,
            handler: nil))
        
        present(controller, animated: true, completion: nil)
        
    }
    
    func createLocationManager(startImmediately: Bool){
        locationManager = CLLocationManager()
        if let manager = locationManager{
            print("Successfully created the location manager")
            manager.delegate = self
            if startImmediately{
                manager.startUpdatingLocation()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /* Are location services available on this device? */
        if CLLocationManager.locationServicesEnabled(){
            
            /* Do we have authorization to access location services? */
            switch CLLocationManager.authorizationStatus(){
            case .authorizedAlways:
                /* Yes, always */
                createLocationManager(startImmediately: true)
            case .authorizedWhenInUse:
                /* Yes, only when our app is in use */
                createLocationManager(startImmediately: true)
            case .denied:
                /* No */
                displayAlertWithTitle(title: "Not Determined",
                    message: "Location services are not allowed for this app")
            case .notDetermined:
                /* We don't know yet, we have to ask */
                createLocationManager(startImmediately: false)
                if let manager = self.locationManager{
                    manager.requestWhenInUseAuthorization()
                }
            case .restricted:
                /* Restrictions have been applied, we have no access
                to location services */
                displayAlertWithTitle(title: "Restricted",
                    message: "Location services are not allowed for this app")
            }
            
            
        } else {
            /* Location services are not enabled.
            Take appropriate action: for instance, prompt the
            user to enable the location services */
            print("Location services are not enabled")
        }
    }
    
    // function to allow for detecting a shake
    override func motionEnded(_ motion: UIEventSubtype,
        with: UIEvent?) {
            
            if motion == .motionShake{
                let controller = UIAlertController(title: "Shake",
                    message: "The device is shaken",
                    preferredStyle: .alert)
                
                controller.addAction(UIAlertAction(title: "OK",
                    style: .default,
                    handler: nil))
                
                present(controller, animated: true, completion: nil)
                
            }
            
    }
    @IBAction func startAccel(sender: UIButton) {
        if motionManager.isAccelerometerAvailable{
            let queue = OperationQueue()
            motionManager.startAccelerometerUpdates(to: queue, withHandler:
                {data, error in
                    
                    guard let data = data else{
                        return
                    }
                    
                    print("X = \(data.acceleration.x)")
                    print("Y = \(data.acceleration.y)")
                    print("Z = \(data.acceleration.z)")
                    self.xDir = data.acceleration.x
                    self.yDir = data.acceleration.y
                    self.zDir = data.acceleration.z

                    
                }
            )
        } else {
            print("Accelerometer is not available")
        }
        
        
    }
    @IBAction func checkDeviceRotation(sender: UIButton) {
        xLabel.text = "x = " + String(xDir)
        yLabel.text = "y = " + String(yDir)
        zLabel.text = "z = " + String(zDir)

    }
    
    
    
}


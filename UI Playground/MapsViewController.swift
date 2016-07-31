//
//  MapsViewController.swift
//  UI Playground
//
//  Created by Dror Ben-Gai on 30/07/2016.
//  Copyright © 2016 Dror Ben-Gai. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class UIPGAnnotation: NSObject, MKAnnotation {
    
    var latitude: CLLocationDegrees = 91
    var longitude: CLLocationDegrees = 181
    
    var location: CLLocation?
    
    var coordinate: CLLocationCoordinate2D {
        set {
            latitude = newValue.latitude
            longitude = newValue.longitude
        }
        get {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
    
    var title: String? { return "Click for details" }
    
    var subtitle: String? { return "Or don't click, I could care less.." }
    
}

class MapsViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var btnToggleUpdateLocation: UIBarButtonItem!
    
    private var locationManager = CLLocationManager()
    
    private var isUpdating: Bool = false
    
    private let ANNOTATION_NAME = "Annotation"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
    }
    
    override func viewDidDisappear(animated: Bool) {
        locationManager.stopUpdatingLocation()
    }
    
    @IBAction func toggleUpdating(sender: UIBarButtonItem) {
        isUpdating = !isUpdating
        if isUpdating {
            locationManager.startUpdatingLocation()
            btnToggleUpdateLocation.title = "Stop"
        } else {
            locationManager.stopUpdatingLocation()
            btnToggleUpdateLocation.title = "Start"
        }
    }
    
    @IBAction func setCurrentLocation(sender: UIBarButtonItem) {
        locationManager.requestLocation()
    }
    
    @IBAction func clearAnnotations(sender: UIBarButtonItem) {
        mapView.removeAnnotations(mapView.annotations)
    }
    
    // MARK: CLLocationManager
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        setLocation(locations[0], annotate: true)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error reported: \(error)")
    }
    
    // MARK: MapViewDelegate
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var view: MKAnnotationView! = mapView.dequeueReusableAnnotationViewWithIdentifier(ANNOTATION_NAME)
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: ANNOTATION_NAME)
            view.canShowCallout = true
        } else {
            view.annotation = annotation
        }
        view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        return view
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.startAnimating()
        view.leftCalloutAccessoryView = activityIndicator
        showLocationDetails((view.annotation! as! UIPGAnnotation).location!)
    }
    
    private func showLocationDetails(location: CLLocation) {
        // get some details about this location
        var message: String = ""
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(
            location,
            completionHandler: {
                (placemarks: [CLPlacemark]?, error: NSError?) in
                if let placemark = placemarks?[0] {
                    message = "You're in \(placemark.country!)!"
                } else {
                    message = "No data at this time. Sorry!"
                }

                let alert = UIAlertController(
                    title: "Location Details",
                    message: message,
                    preferredStyle: .Alert)
                let closeAction = UIAlertAction(
                    title: "OK",
                    style: .Default,
                    handler: nil)
                alert.addAction(closeAction)
                self.presentViewController(
                    alert,
                    animated: true,
                    completion: nil)
            }
        )
    }
    
    private func setLocation(location: CLLocation, annotate: Bool) {
        mapView.setRegion(
            MKCoordinateRegionMake(
                CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude),
                MKCoordinateSpanMake(0.001, 0.001)),
            animated: true)
        if annotate {
            let annotation = UIPGAnnotation()
            annotation.coordinate = location.coordinate
            annotation.location = location
            mapView.addAnnotation(annotation)
        }
    }

}

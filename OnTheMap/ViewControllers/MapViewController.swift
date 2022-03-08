//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Dilip Agheda on 27/2/22.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
       
        mapView.delegate = self
        
        self.refresh()
    }
    
    public func refresh() {
       
        ViewModel.results = []
        
        NetworkService.getStudentLocations(){
            (results, error) in
            guard let results = results else {
                ViewModel.results = []
                Alerts.setParentView(parentView: self)
                    .showError(errorMessage: "Error while fetching student locations!")
                return
            }
            
            ViewModel.results = results
            self.configureMapView()
        }
    }
    
    private func configureMapView() {
        // The "locations" array is an array of dictionary objects that are similar to the JSON
        // data that you can download from parse.
        let locations = ViewModel.results
        
        // We will create an MKPointAnnotation for each dictionary in "locations". The
        // point annotations will be stored in this array, and then provided to the map view.
        var annotations = [MKPointAnnotation]()
        
        for location in locations {

            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            let lat = CLLocationDegrees(location.latitude)
            let long = CLLocationDegrees(location.longitude)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = location.firstName
            let last = location.lastName
            let mediaURL = location.mediaURL
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
        
        let region = MKCoordinateRegion( center: annotations[0].coordinate, latitudinalMeters: CLLocationDistance(exactly: 10000)!, longitudinalMeters: CLLocationDistance(exactly: 10000)!)
        self.mapView.setRegion(mapView.regionThatFits(region), animated: true)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            
            guard let annotation = view.annotation else {
                return
            }
            
            let subtitle: String = annotation.subtitle! ?? ""
            let url = URL(string: subtitle)
            
            guard let url = url else {
                
                Alerts.setParentView(parentView: self).showError(errorMessage: "Invalid URL!")
                return
            }
            
            app.open(url) {
                (isSuccessful) in
                if(!isSuccessful) {
                    Alerts.setParentView(parentView: self)
                          .showError(errorMessage: "Invalid URL")
                }
            }
        }
    }
}


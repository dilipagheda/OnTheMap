//
//  AddLocation.swift
//  OnTheMap
//
//  Created by Dilip Agheda on 5/3/22.
//

import Foundation
import UIKit
import MapKit

class AddLocationViewController : UIViewController {
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var urlTextField: UITextField!
    
    @IBOutlet weak var findLocationButton: UIButton!
    
    @IBOutlet weak var finishButton: UIButton!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var studentLocationRequest: StudentLocationRequest = StudentLocationRequest(firstName: "", lastName: "", longitude: 0, latitude: 0, mapString: "", mediaURL: "", uniqueKey: "1dc539f8-64ee-43f7-b424-e5b4bd2d7c6d")
    
    func getCoordinates(completion: @escaping (Double?, Double?) -> Void) {
        
        guard let location = locationTextField.text else {
            completion(nil, nil)
            return
        }
        
        let trimmedLocation = location.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if(trimmedLocation.isEmpty) {
            
            completion(nil, nil)
            return
        }
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(location) {
            placemarks, error in
            guard let placemarks = placemarks else {
                completion(nil, nil)
                return
            }
            
            let placemark = placemarks[0]
            
            let longitude =  placemark.location?.coordinate.longitude
            let latitude = placemark.location?.coordinate.latitude
            
            guard let longitude = longitude, let latitude = latitude else {
                completion(nil, nil)
                return
            }
            self.studentLocationRequest.latitude = latitude
            self.studentLocationRequest.longitude = longitude
            completion(longitude, latitude)
        }
    }
    
    private func updateUI(showMapView: Bool) {
        
        mapView.isHidden = !showMapView
        finishButton.isHidden = !showMapView
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        updateUI(showMapView: false)
    }
    
    @IBAction func onFinishButtonTap(_ sender: Any) {
        
        activityIndicator.startAnimating()
        
        self.studentLocationRequest.firstName = ViewModel.firstName
        self.studentLocationRequest.lastName = ViewModel.lastName
        
        NetworkService.postStudentLocation(studentLocationRequest: self.studentLocationRequest) {
            (isSuccessful, message) in
            self.activityIndicator.stopAnimating()
            if(!isSuccessful) {
                let msg = message ?? "Sorry, Something went wrong!"
                Alerts.setParentView(parentView: self)
                    .showError(errorMessage: msg)
                return
            }
            self.dismiss(animated: true, completion: nil)
        }


    }
    
    
    @IBAction func onCancelTap(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onFindLocationTap(_ sender: Any) {
        
        guard let location = self.locationTextField.text, let url = self.urlTextField.text else {
            
            Alerts.setParentView(parentView: self)
                .showError(errorMessage: "Please enter location and URL")
        
            return
        }
        
        if(location.isEmpty || url.isEmpty) {
            
            Alerts.setParentView(parentView: self)
                .showError(errorMessage: "Please enter location and URL")
        
            return
        }
        
        studentLocationRequest.mapString = location
        studentLocationRequest.mediaURL = url
        
        self.activityIndicator.startAnimating()
        
        self.getCoordinates() {
            (longitude, latitude) in
            
            self.activityIndicator.stopAnimating()
            
            guard let longitude = longitude, let latitude = latitude else {
                
                Alerts.setParentView(parentView: self)
                    .showError(errorMessage: "Location is not found!")
                return
            }
            
            let lat = CLLocationDegrees(latitude)
            let long = CLLocationDegrees(longitude)
            
            self.updateUI(showMapView: true)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            self.mapView.addAnnotation(annotation)
            
            let region = MKCoordinateRegion( center: annotation.coordinate, latitudinalMeters: CLLocationDistance(exactly: 10000)!, longitudinalMeters: CLLocationDistance(exactly: 10000)!)
            self.mapView.setRegion(self.mapView.regionThatFits(region), animated: true)
        }
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

}

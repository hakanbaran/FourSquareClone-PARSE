//
//  MapVC.swift
//  FoursquareClone-PARSE
//
//  Created by Hakan Baran on 2.10.2022.
//

import UIKit
import MapKit
import CoreLocation
import Parse

class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "SAVE", style: UIBarButtonItem.Style.done, target: self, action: #selector(saveButtonclicked))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "BACK", style: UIBarButtonItem.Style.done, target: self, action: #selector(backButtonClicked))
        
        
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(choosenLocation(gestureRecognizer: )))
        recognizer.minimumPressDuration = 3
        mapView.addGestureRecognizer(recognizer)

        
    }
    
    @objc func choosenLocation(gestureRecognizer: UIGestureRecognizer) {
        
        if gestureRecognizer.state == .began {
            
            let touches = gestureRecognizer.location(in: mapView)
            let coordinates = self.mapView.convert(touches, toCoordinateFrom: self.mapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            
            annotation.title = PlaceModel.sharedInstance.placeName
            annotation.subtitle = PlaceModel.sharedInstance.placeType
            
            self.mapView.addAnnotation(annotation)
            
            PlaceModel.sharedInstance.placeLatitude = String(annotation.coordinate.latitude)
            PlaceModel.sharedInstance.placeLongitude = String(annotation.coordinate.longitude)
            
        }
        
        
    }
    
    @objc func saveButtonclicked() {
        
        let placeModel = PlaceModel.sharedInstance
        
        let object = PFObject(className: "Places")
        
        object["Name"] = placeModel.placeName
        object["Type"] = placeModel.placeType
        object["Comment"] = placeModel.placeComment
        object["Latitude"] = placeModel.placeLatitude
        object["Longitude"] = placeModel.placeLongitude
        
        
        if let imageData = placeModel.placeImage.jpegData(compressionQuality: 0.5) {
            
            object["Image"] = PFFileObject(name: "image.jpg", data: imageData)
            
        }
        
        object.saveInBackground { Success, Error in
            
            if Error != nil {
                let alert = UIAlertController(title: "Error!", message: "Error Baby!!!", preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                alert.addAction(okButton)
                self.present(alert, animated: true)
                
            } else {
                
                self.performSegue(withIdentifier: "fromMapVCtoPlacesVC", sender: nil)
            }
            
            
        }
        
        
        
        
    }
    
    
    @objc func backButtonClicked() {
        
        self.dismiss(animated: true)
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        
        let region = MKCoordinateRegion(center: location, span: span)
        
        mapView.setRegion(region, animated: true)
        
        
        
    }
    

    

}

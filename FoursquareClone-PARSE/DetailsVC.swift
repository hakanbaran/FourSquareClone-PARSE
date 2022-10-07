//
//  DetailsVC.swift
//  FoursquareClone-PARSE
//
//  Created by Hakan Baran on 3.10.2022.
//

import UIKit
import MapKit
import Parse

class DetailsVC: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate {
    @IBOutlet weak var detailsImage: UIImageView!
    
    @IBOutlet weak var detailsNameLabel: UILabel!
    @IBOutlet weak var detailsTypeLabel: UILabel!
    @IBOutlet weak var detailsCommentLabel: UILabel!
    @IBOutlet weak var detailsMapView: MKMapView!
    
    var chosenPlacesID = ""
    
    
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        getDataFromParse()
        
    }
    
    func getDataFromParse() {
        
        let quary = PFQuery(className: "Places")
        quary.whereKey("objectId", equalTo: chosenPlacesID)
        
        quary.findObjectsInBackground { [self] objects, error in
            
            
            if error == nil {
                if objects!.count > 0 {
                    
                    let chosenPlaceObject = objects![0]
                    
                    
                    if let placeName = chosenPlaceObject.object(forKey: "Name") as? String {
                        
                        self.detailsNameLabel.text = placeName
                        
                    }
                    
                    if let placeType = chosenPlaceObject.object(forKey: "Type") as? String {
                        
                        self.detailsTypeLabel.text = placeType
                        
                    }
                    
                    if let placeComment = chosenPlaceObject.object(forKey: "Comment") as? String {
                        
                        
                        self.detailsCommentLabel.text = placeComment
                    }
                    
                    if let placeLatitude = chosenPlaceObject.object(forKey: "Latitude") as? String {
                        
                        if let placeDoubleLatitude = Double(placeLatitude) {
                            
                            self.chosenLatitude = placeDoubleLatitude
                            
                        }
                        
                        if let placeLongitude = chosenPlaceObject.object(forKey: "Longitude") as? String {
                            if let placeDoubleLongitude = Double(placeLongitude) {
                                self.chosenLongitude = placeDoubleLongitude
                            }
                                }
                        if let imageData = chosenPlaceObject.object(forKey: "Image") as? PFFileObject {
                            imageData.getDataInBackground { data, error in
                                if error == nil {
                                    self.detailsImage.image = UIImage(data: data!)
                                }
                            }
                        }
                    }
                    
                    
                    let location = CLLocationCoordinate2D(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
                    let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    let region = MKCoordinateRegion(center: location, span: span)
                    
                    self.detailsMapView.setRegion(region, animated: true)
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = location
                    annotation.title = self.detailsNameLabel.text!
                    annotation.subtitle = self.detailsTypeLabel.text!
                    
                    self.detailsMapView.addAnnotation(annotation)
                    
                }
            }
        }
    }
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation{
            return nil
        }
        
        let reuseID = "MyAnnotation"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        
        if pinView == nil {
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView?.canShowCallout = true
            
            let button = UIButton(type: UIButton.ButtonType.detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
            
        } else {
            
            pinView?.annotation = annotation
            
        }
        
        return pinView
        
        
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if self.chosenLatitude != 0.0 && self.chosenLongitude != 0.0 {
            
            let requestLocation = CLLocation(latitude: chosenLatitude, longitude: chosenLongitude)
            
            CLGeocoder().reverseGeocodeLocation(requestLocation) { placemarks, Error in
                
                if let placemark = placemarks {
                    
                    if placemark.count > 0 {
                        
                        let newPlacemark = MKPlacemark(placemark: placemark[0])
                        
                        let item = MKMapItem(placemark: newPlacemark)
                        item.name = self.detailsNameLabel.text!
                        
                        
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                        
                        item.openInMaps(launchOptions: launchOptions)
                        
                    }
                    
                }
                
            }
            
        }
        
        
    }
    
    
    
    
}

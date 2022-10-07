//
//  PlacesVC.swift
//  FoursquareClone-PARSE
//
//  Created by Hakan Baran on 1.10.2022.
//

import UIKit
import Parse

class PlacesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var PlaceNameArray = [String]()
    var placeIDArray = [String]()
    
    var selectedPlaceID = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: UIBarButtonItem.Style.done, target: self, action: #selector(logOutButtonClicked))

        
        getDataFromParse()
        
        
    }
    
    
    func getDataFromParse() {
        
        let query = PFQuery(className: "Places")
        query.findObjectsInBackground { (objects, Error) in
            
            if Error != nil {
                self.makeAlert(titleImput: "Error", messageImput: "Error!!!!!")
                
            } else {
                
                if objects?.count != nil {
                    
                    self.PlaceNameArray.removeAll(keepingCapacity: false)
                    self.placeIDArray.removeAll(keepingCapacity: false)
                    for object in objects! {
                        
                        if let placeName = object.object(forKey: "Name") as? String{
                            
                            if let placeID = object.objectId {
                                self.PlaceNameArray.append(placeName)
                                self.placeIDArray.append(placeID)
                            }
                        }
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    
    
    
    
    @objc func logOutButtonClicked() {
        
        PFUser.logOutInBackground { (Error4) in
            
            if Error4 != nil {
                
                self.makeAlert(titleImput: "Error", messageImput: "Error!!!")
                
            }
            
        }
        
        performSegue(withIdentifier: "toSignUpVC", sender: nil)
        
    }
    
    @objc func addButtonClicked() {
        
        //Segue
        performSegue(withIdentifier: "toAddPlacesVC", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlaceNameArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = PlaceNameArray[indexPath.row]
        cell.contentConfiguration = content
        return cell
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toResultVC" {
            
            let destinationVC = segue.destination as! DetailsVC
            
            destinationVC.chosenPlacesID = selectedPlaceID
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedPlaceID = placeIDArray[indexPath.row]
        self.performSegue(withIdentifier: "toResultVC", sender: nil)
        
        
        
    }
    
    
    
    
    
    
    func makeAlert(titleImput: String, messageImput: String){
        
        let alert = UIAlertController(title: titleImput, message: messageImput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        
        
    }
}

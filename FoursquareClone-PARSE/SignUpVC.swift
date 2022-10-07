//
//  ViewController.swift
//  FoursquareClone-PARSE
//
//  Created by Hakan Baran on 30.09.2022.
//

import UIKit
import Parse

class SignUpVC: UIViewController {
    
    @IBOutlet weak var tittleLabel: UILabel!
    
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    @IBAction func signInClicked(_ sender: Any) {
        
        
        if userNameText.text != "" && passwordText.text != "" {
            
            PFUser.logInWithUsername(inBackground: userNameText.text!, password: passwordText.text!) { user, error3 in
                
                if error3 != nil {
                    
                    self.makeAlert(tittleImput: "Error", messageImput: error3?.localizedDescription ?? "Error3")
                    
                    
                } else {
                    // Segue
                    
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                    
                    
                }
                
                
            }
            
            
        } else {
            
            makeAlert(tittleImput: "Error", messageImput: "Username/Password ???")
            
        }
        
        
    }
    
    
    @IBAction func signUpClickedeeee(_ sender: Any) {
        
        if userNameText.text! != "" && passwordText.text! != "" {
            
            let user = PFUser()
            
            user.username = userNameText.text!
            user.password = passwordText.text!
            
            
            
            user.signUpInBackground { successful, Error in
                
                if Error != nil {
                    self.makeAlert(tittleImput: "Error1", messageImput: Error?.localizedDescription ?? "Error1")
                } else {
                    
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)

                }
            }
            
        } else {
            self.makeAlert(tittleImput: "Error2", messageImput: "Username/Password ???")
        }
    }
    
    func makeAlert(tittleImput: String, messageImput: String) {
        
        let alert = UIAlertController(title: tittleImput, message: messageImput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
}


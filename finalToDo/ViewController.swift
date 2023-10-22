//
//  ViewController.swift
//  finalToDo
//
//  Created by Necati Alperen IŞIK on 13.09.2023.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var subWelcomeLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        passwordTextField.isSecureTextEntry = true
    }

    
    @IBAction func loginClicked(_ sender: Any) {
        if emailTextField.text != "" && passwordTextField.text  != "" {
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) {(authdata,error) in
                
                if error != nil{
                    self.makeAlert(titleInput: "error", messageInput: error?.localizedDescription ?? "error")
                }else{
                    self.performSegue(withIdentifier: "toTableVC", sender: nil)
                }
            }
        }
    }
    
    
    @IBAction func registerClicked(_ sender: Any) {
        if emailTextField.text != "" && passwordTextField.text != "" {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authdata,error )in
                
                if error != nil {
                    self.makeAlert(titleInput: "error", messageInput: error?.localizedDescription ?? "error")
                }else{
                    self.performSegue(withIdentifier: "toTableVC", sender: nil)
                }
            }
        }else{
            makeAlert(titleInput: "error", messageInput: "username/password?")
        }
        
    }
    

    func makeAlert(titleInput:String, messageInput:String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true,completion: nil)
    }
    
    
    
}


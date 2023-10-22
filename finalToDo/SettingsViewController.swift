//
//  SettingsViewController.swift
//  finalToDo
//
//  Created by Necati Alperen IŞIK on 14.09.2023.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func homeButtonClicked(_ sender: Any) {
        
        performSegue(withIdentifier: "toTodosVC", sender: nil)
    }
    
    
    @IBAction func logOutButtonClicked(_ sender: Any) {
        
        do{
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toViewController", sender: nil)
        }catch{
            print("error")
        }
    }
    
    
    
    
    
    
    
    

}

//
//  TablePageController.swift
//  finalToDo
//
//  Created by Necati Alperen IŞIK on 14.09.2023.
//

import UIKit
import Firebase
import FirebaseFirestore


class TablePageController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var addButtonClicked: UIButton!
    
    @IBOutlet weak var settingsButtonClicked: UIButton!
    
    
    
    @IBOutlet weak var tableView: UITableView!
    var optionsList : [String] = []
    
    
    override func viewDidLoad() {
           super.viewDidLoad()

           tableView.delegate = self
           tableView.dataSource = self

           

           
           if Auth.auth().currentUser != nil {
               
               uploadData()
           }
       }
    
    func uploadData() {
            let firestoreDatabase = Firestore.firestore()
            if let kullaniciID = Auth.auth().currentUser?.uid {
                firestoreDatabase.collection("options").whereField("kullaniciID", isEqualTo: kullaniciID).getDocuments { [weak self] (querySnapshot, error) in
                    if let error = error {
                        print("Hata: \(error.localizedDescription)")
                    } else {
                        if let documents = querySnapshot?.documents {
                            self?.optionsList = documents.compactMap { document in
                                if let optionName = document["optionName"] as? String {
                                    return optionName
                                }
                                return nil
                            }
                            self?.tableView.reloadData()
                        }
                    }
                }
            }
        }
    
    
    
    @IBAction func settingsButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "toSettingsVC", sender: nil)
    }
    
    
    
    @IBAction func addButtonClicked(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "NEW TASK", message: "ADD NEW OPTION", preferredStyle: .alert)
                alertController.addTextField { textField in
                    textField.placeholder = "NEW OPTION"
                }

                let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
                    if let textField = alertController.textFields?.first, let newOption = textField.text, !newOption.isEmpty {
                        // add new data to firestore
                        let firestoreDatabase = Firestore.firestore()
                        if let kullaniciID = Auth.auth().currentUser?.uid {
                            firestoreDatabase.collection("options").addDocument(data: ["optionName": newOption, "kullaniciID": kullaniciID]) { error in
                                if let error = error {
                                    print("Hata: \(error.localizedDescription)")
                                } else {
                                    print("data upload succesfully.")
                                }
                            }
                        }

                        self?.optionsList.append(newOption)
                        self?.tableView.reloadData()
                    }
                }

                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

                alertController.addAction(addAction)
                alertController.addAction(cancelAction)

                present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionsList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        var content = cell.defaultContentConfiguration()
        content.text = optionsList[indexPath.row]
        
        cell.contentConfiguration = content
        return cell
        
        
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
                    if let kullaniciID = Auth.auth().currentUser?.uid {
                        let firestoreDatabase = Firestore.firestore()
                        let optionToDelete = optionsList[indexPath.row]
                        
                        
                        firestoreDatabase.collection("options")
                            .whereField("kullaniciID", isEqualTo: kullaniciID)
                            .whereField("optionName", isEqualTo: optionToDelete)
                            .getDocuments { (querySnapshot, error) in
                                if let error = error {
                                    print("error: \(error.localizedDescription)")
                                } else {
                                    if let documents = querySnapshot?.documents {
                                        for document in documents {
                                            firestoreDatabase.collection("options").document(document.documentID).delete { error in
                                                if let error = error {
                                                    print("error: \(error.localizedDescription)")
                                                } else {
                                                    print("data deleted succesfully.")
                                                }
                                            }
                                        }
                                    }
                                }
                        }
                    }

                    optionsList.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .middle)
                }
            }
        
        
    }
    
    




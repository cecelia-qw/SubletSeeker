//
//  HouseDetailTableViewController.swift
//  SubletSeeker
//
//  Created by Qingwan Cheng.
//

import UIKit
import MapKit

class HouseDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var roomAvailableField: UITextField!
    @IBOutlet weak var houseLayoutField: UITextField!
    @IBOutlet weak var fullyFurnituredField: UITextField!
    @IBOutlet weak var parkingField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var contactField: UITextField!
    @IBOutlet weak var commentTextView: UITextView!
    
    var house: House!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide keyboard if we tap outside of a field
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        if house == nil {
            house = House()
        }
        updateUserInterface()
    }
    
    func updateUserInterface() {
        addressField.text = house.address
        roomAvailableField.text = house.roomAvailable
        houseLayoutField.text = house.houseLayout
        fullyFurnituredField.text = house.fullyFurnitured
        parkingField.text = house.parking
        contactField.text = house.contact
        commentTextView.text = house.comment
    }
    
    func updateFromUserInterface() {
        house.address = addressField.text!
        house.roomAvailable = roomAvailableField.text!
        house.houseLayout = houseLayoutField.text!
        house.fullyFurnitured = fullyFurnituredField.text!
        house.parking = parkingField.text!
        house.contact = contactField.text!
        house.comment = commentTextView.text!
    }
    
    
    @IBAction func findLocationButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        updateFromUserInterface()
        house.saveData() { success in
            if success {
                // Return to previous view controller
                // We can use the "Cancel" code here because don't need to explicitly
                //pass back data. We'll instead use a Firebase feature that "listens" for updates to on the earlier view controller and reloads these changes into the table view, automatically.
                self.leaveViewController()
            } else {
                print("Can't segue because of the error")
            }
        }
    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    
}

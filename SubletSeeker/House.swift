//
//  House.swift
//  SubletSeeker
//
//  Created by Qingwan Cheng on 4/27/22.
//

import Foundation
import CoreLocation
import Firebase

class House {
    var address: String
    var houseLayout: String
    var roomAvailable: String
    var coordinate: CLLocationCoordinate2D
    var fullyFurnitured: String
    var price: String
    var parking: String
    var startDate: Date
    var endDate: Date
    var contact: String
    var comment: String
    var postingUserID: String
    var documentID: String

    
    var latitude: CLLocationDegrees {
        return coordinate.latitude
    }
    
    var longitude: CLLocationDegrees {
        return coordinate.longitude
    }
    
    var dictionary: [String: Any] {
        let startTimeIntervalDate = startDate.timeIntervalSince1970
        let endTimeIntervalDate = endDate.timeIntervalSince1970
        return ["address": address, "houseLayout": houseLayout, "roomAvailable": roomAvailable, "longitude": longitude, "latitude": latitude, "fullyFurnitured": fullyFurnitured, "price": price, "parking": parking, "startDate": startTimeIntervalDate, "endDate": endTimeIntervalDate, "contact": contact, "comment": comment, "postingUserID": postingUserID, "documentID": documentID]
    }

    init(address: String, houseLayout: String, roomAvailable: String, coordinate: CLLocationCoordinate2D,fullyFurnitured: String, price: String, parking: String, startDate: Date, endDate: Date, contact: String, comment: String, postingUserID: String, documentID: String) {
        self.address = address
        self.houseLayout = houseLayout
        self.roomAvailable = roomAvailable
        self.coordinate = coordinate
        self.fullyFurnitured = fullyFurnitured
        self.price = price
        self.parking = parking
        self.startDate = startDate
        self.endDate = endDate
        self.contact = contact
        self.comment = comment
        self.postingUserID = postingUserID
        self.documentID = documentID
    }
    
    convenience init(dictionary: [String: Any]) {
        let address = dictionary["address"] as! String? ?? ""
        let houseLayout = dictionary["houseLayout"] as! String? ?? ""
        let latitude = dictionary["latitude"] as! CLLocationDegrees? ?? 0.0
        let longitude = dictionary["longitude"] as! CLLocationDegrees? ?? 0.0
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let roomAvailable = dictionary["roomAvailable"] as! String? ?? ""
        let fullyFurnitured = dictionary["fullyFurnitured"] as! String? ?? ""
        let price = dictionary["price"] as! String? ?? ""
        let parking = dictionary["parking"] as! String? ?? ""
        let contact = dictionary["contact"] as! String? ?? ""
        let comment = dictionary["comment"] as! String? ?? ""
        let startTimeIntervalDate = dictionary["startDate"] as! TimeInterval? ?? TimeInterval()
        let endTimeIntervalDate = dictionary["endDate"] as! TimeInterval? ?? TimeInterval()
        let startDate = Date(timeIntervalSince1970: startTimeIntervalDate)
        let endDate = Date(timeIntervalSince1970: endTimeIntervalDate)
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        let documentID = dictionary["documentID"] as! String? ?? ""
        self.init(address: address, houseLayout: houseLayout, roomAvailable: roomAvailable, coordinate: coordinate, fullyFurnitured: fullyFurnitured, price: price, parking: parking, startDate: startDate, endDate: endDate, contact: contact, comment: comment, postingUserID: postingUserID, documentID: "")
    }
    
    convenience init() {
        self.init(address: "", houseLayout: "", roomAvailable: "", coordinate: CLLocationCoordinate2D(), fullyFurnitured: "", price: "", parking: "", startDate: Date(), endDate: Date(), contact: "", comment: "", postingUserID: "", documentID: "")
    }
    
    func saveData(completion: @escaping (Bool) -> ())  {
        let db = Firestore.firestore()
        // Grab the user ID
        guard let postingUserID = (Auth.auth().currentUser?.uid) else {
            print("*** ERROR: Could not save data because we don't have a valid postingUserID")
            return completion(false)
        }
        self.postingUserID = postingUserID
        // Create the dictionary representing data we want to save
        let dataToSave: [String: Any] = self.dictionary
        // if we HAVE saved a record, we'll have an ID
        if self.documentID != "" {
            let ref = db.collection("houses").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("ERROR: updating document \(error.localizedDescription)")
                    completion(false)
                } else { // It worked!
                    completion(true)
                }
            }
        } else { // Otherwise create a new document via .addDocument
            var ref: DocumentReference? = nil // Firestore will create a new ID for us
            ref = db.collection("houses").addDocument(data: dataToSave) { (error) in
                if let error = error {
                    print("ERROR: adding document \(error.localizedDescription)")
                    completion(false)
                } else { // It worked! Save the documentID in Spot’s documentID property
                    self.documentID = ref!.documentID
                    completion(true)
                }
            }
        }
    }
}

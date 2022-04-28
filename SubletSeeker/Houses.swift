//
//  Houses.swift
//  SubletSeeker
//
//  Created by Qingwan Cheng on 4/28/22.
//

import Foundation
import Firebase

class Houses {
    var houseArray: [House] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ())  {
        db.collection("houses").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("*** ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.houseArray = []
            // there are querySnapshot!.documents.count documents in the snapshot
            for document in querySnapshot!.documents {
                let house = House(dictionary: document.data())
                house.documentID = document.documentID
                self.houseArray.append(house)
            }
            completed()
        }
    }
}

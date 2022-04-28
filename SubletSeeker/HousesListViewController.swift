//
//  HousesViewController.swift
//  SubletSeeker
//
//  Created by Qingwan Cheng.
//

import UIKit

class HousesListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var houses: Houses!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        houses = Houses()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        houses.loadData {
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowHouse" {
            let destination = segue.destination as! HouseDetailTableViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.house = houses.houseArray[selectedIndexPath.row]
        } else {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
    }

    
}

extension HousesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return houses.houseArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = houses.houseArray[indexPath.row].address
        return cell
    }
    
    
}

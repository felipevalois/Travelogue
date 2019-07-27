//
//  TripsTableViewController.swift
//  Travelogue
//
//  Created by Felipe Costa on 7/23/19.
//  Copyright © 2019 Felipe Costa. All rights reserved.
//

import UIKit
import CoreData

class TripsTableViewController: UITableViewController {

    @IBOutlet var tripsTableView: UITableView!
    @IBOutlet weak var addBtn: UIBarButtonItem!
    
    var trips: [Trip]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tripsTableView.reloadData()
    }


    override func viewWillAppear(_ animated: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest : NSFetchRequest<Trip> = Trip.fetchRequest()
        do{
            trips = try managedContext.fetch(fetchRequest)
            tripsTableView.reloadData()
        }catch{
            print("Could not fetch categories")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips?.count ?? 0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tripsTableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath)
        let trip = trips?[indexPath.row]
        cell.textLabel?.text = trip?.title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            deleteTrip(at: indexPath)
            
        }
    }
    
    func deleteTrip(at indexPath:IndexPath){
        let trip = trips?[indexPath.row]
        
        guard let managedContext = trip?.managedObjectContext else{
            return
        }
        managedContext.delete(trip!)
        do{
            try managedContext.save()
            trips?.remove(at: indexPath.row)
            tripsTableView.deleteRows(at: [indexPath], with: .automatic)
        }catch{
            print("Could not delete Trip")
            tripsTableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }

    @IBAction func addTrip(_ sender: Any) {
        let alert = UIAlertController(title: "Add Trip", message: "Enter the name of the trip", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Submit", style: UIAlertAction.Style.default, handler: {
            (alertAction)->Void in
            if let textField = alert.textFields?[0], let name = textField.text{
                let tripName = name.trimmingCharacters(in: .whitespaces)
                if(tripName == ""){
                    print("Trip not created")
                    return
                }
                let trip = Trip(title: tripName)
                do{
                    try trip?.managedObjectContext?.save()
                    self.viewWillAppear(true)
                }catch{
                    print("Could not save trip")
                }
            }
        }))
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "trip name"
            textField.isSecureTextEntry = false
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? EntriesViewController,
            let selectedRow = self.tripsTableView.indexPathForSelectedRow?.row
            else{
                return
        }

        if let trips = trips {
            print("trip exists")
            destination.trip = trips[selectedRow]
        }
        destination.entries = trips?[selectedRow].entries
    }
}

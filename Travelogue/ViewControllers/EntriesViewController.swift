//
//  EntriesViewController.swift
//  Travelogue
//
//  Created by Felipe Costa on 7/23/19.
//  Copyright © 2019 Felipe Costa. All rights reserved.
//

import UIKit

class EntriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var trip : Trip?
    var entries : [Entry]?
    var dateFormatter = DateFormatter()
    
    @IBOutlet weak var entriesTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.timeStyle = .medium
        dateFormatter.dateStyle = .medium
    }
    override func viewWillAppear(_ animated: Bool) {
        entriesTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trip?.entries?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)
        
        if let cell = cell as? EntriesTableViewCell {
            let entry = trip?.entries?[indexPath.row]
            cell.titleLabel.text = entry?.name
            cell.contentLabel.text = entry?.content
            cell.entryImageView.image = entry?.image
            if let modifiedDate = entry?.date {
                cell.dateLabel.text = "Modified: " + dateFormatter.string(from: modifiedDate)
            } else {
                cell.dateLabel.text = "unknown"
            }
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? EntryViewController
            else{
                print("returning early")
                return
        }
        
        if let selectedRow = self.entriesTableView.indexPathForSelectedRow?.row {
            destination.entry = trip?.entries?[selectedRow]
        }
        
        destination.trip = trip
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteEntry(at: indexPath)
        }
    }
    
    func deleteEntry(at indexPath: IndexPath){
        guard let entry = trip?.entries?[indexPath.row], let managedContext = entry.managedObjectContext else{
            return
        }
        managedContext.delete(entry)
        do{
            try managedContext.save()
            entriesTableView.deleteRows(at: [indexPath], with: .automatic)
        }catch{
            print("Entry could not be deleted")
            entriesTableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    

}

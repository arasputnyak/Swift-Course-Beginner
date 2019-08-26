//
//  FlightsTVController.swift
//  Lesson5Task
//
//  Created by Анастасия Распутняк on 16.08.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

import UIKit
import CoreData

class FlightsTVController: UITableViewController {
    
    var context = CoreDataManager.instance.persistentContainer.viewContext
    var fetchedResultsController : NSFetchedResultsController<NSFetchRequestResult>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setFetchResultsController()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(actionAdd(sender:)))
    }
    
    func setFetchResultsController() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Flight.self))
        
        let numberDescriptor = NSSortDescriptor(key: "number", ascending: true)
        request.sortDescriptors = [numberDescriptor]   //, airlineDescriptor]
        
        request.fetchBatchSize = 10
        
        fetchedResultsController = NSFetchedResultsController.init(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "airline.name", cacheName: "Master")
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
        
    }
    
    // MARK: - Actions -
    
    @objc func actionAdd(sender: UIBarButtonItem) {
        if let addController = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddFlightController") as? AddFlightController {
            self.navigationController?.pushViewController(addController, animated: true)
        }
    }
    
    // MARK: - UITableViewDataSource -
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController.sections else {
            return 0
        }
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
            return 0
        }
        return sections[section].numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = fetchedResultsController.sections else {
            return nil
        }
        return sections[section].name
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "Cell"
        let flight = fetchedResultsController.object(at: indexPath) as! Flight
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! FlightCell
        configureCell(cell, withObject: flight)
        
        return cell
    }
    
    
    // MARK: - UITableViewDelegate -
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(fetchedResultsController.object(at: indexPath) as! NSManagedObject)
        }
        
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }

}

extension FlightsTVController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            self.tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .left)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .right)
        case .update:
            configureCell(tableView.cellForRow(at: indexPath!) as! FlightCell, withObject: anObject as! Flight)
        case .move:
            configureCell(tableView.cellForRow(at: indexPath!) as! FlightCell, withObject: anObject as! Flight)
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

extension FlightsTVController {
    func configureCell(_ cell: FlightCell, withObject flight: Flight) {
        cell.flightNumberLabel.text = flight.number
        cell.flightAirlineLabel.text = flight.airline?.name
    }
}

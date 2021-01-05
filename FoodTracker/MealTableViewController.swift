//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by NeppsStaff on 2021/01/04.
//

import UIKit
import os.log

class MealTableViewController: UITableViewController {
    
    //MARK: Proparties
    var meals = [Meal]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem

        //Load the sample data
        if let savedMeals = loadMeals() {
            meals += savedMeals
        } else {
            loadSampleMeals()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return meals.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "MealTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell else {
            fatalError("The dequeued cell is not instance of MealTableViewCell.")
        }
        
        let meal = meals[indexPath.row]
        
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating

        // Configure the cell...

        return cell
    }
    
    //MARK: Action
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? MealDetailViewController, let meal = sourceViewController.meal {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                meals[selectedIndexPath.row] = meal
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                let newIndexPath = IndexPath(row: meals.count, section: 0)
                meals.append(meal)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            saveMeals()
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            meals.remove(at: indexPath.row)
            saveMeals()
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        
        switch segue.identifier ?? "" {
        case "AddItem":
            os_log("Adding a new meal.", log: .default, type: .debug)
        case "ShowDetail":
            guard let MealDetailViewController = segue.destination as? MealDetailViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedMealCell = sender as? MealTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                fatalError("The selected cell is not begin displayed by the table")
            }
            let selectedMeal = meals[indexPath.row]
            MealDetailViewController.meal = selectedMeal
        default:
            fatalError("Unexpected Segue identifier: \(String(describing: segue.identifier))")
        }
    }
    
    // MARK: Private Methods
    private func loadSampleMeals() {
        let photo1 = #imageLiteral(resourceName: "meal1")
        let photo2 = #imageLiteral(resourceName: "meal2")
        let photo3 = #imageLiteral(resourceName: "meal3")
        guard let meal1 = Meal(name: "Humberger", photo: photo1, rating: 4) else {
            fatalError("Unable to instance meal1")
        }
        guard let meal2 = Meal(name: "Sushi Bento", photo: photo2, rating: 5) else {
            fatalError("Unable to instance meal2")
        }
        guard let meal3 = Meal(name: "Grilled Beef", photo: photo3, rating: 3) else {
            fatalError("Unable to instance meal3")
        }
        
        meals += [meal1, meal2, meal3]
    }
    
    private func saveMeals() {
        guard let archiveData = try? NSKeyedArchiver.archivedData(withRootObject: meals, requiringSecureCoding: false) else {
            fatalError("Unable to archive meals")
        }
        
        do {
            try archiveData.write(to: Meal.ArchiveURL)
            os_log("Meals successfully saved", log: OSLog.default, type: .debug)
        } catch {
            os_log("Failed to save meal...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadMeals() -> [Meal]? {
        do {
            let data = try Data.init(contentsOf: Meal.ArchiveURL)
            if let loadedData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Meal] {
                os_log("Meals successfully loaded", log: OSLog.default, type: .debug)
                return loadedData
            }
        } catch {
            os_log("Failed to save meal...", log: OSLog.default, type: .error)
        }
        return nil
    }


}

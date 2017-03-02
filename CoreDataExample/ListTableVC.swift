//
//  ListTableVC.swift
//  CoreDataExample
//
//  Created by Kariniemi, Wade (NE) on 03/02/17.
//  Copyright © 2017 wade. All rights reserved.
//

import UIKit
import CoreData

class ListTableVC: UITableViewController {
    
    let appDelegateObj : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var dataArray = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Places"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchData()
    }
    
    func fetchData() {
        let entityDescription = NSEntityDescription.entity(forEntityName: kEntityStr, in: appDelegateObj.managedObjectContext)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entityDescription
        
        do {
            dataArray = try appDelegateObj.managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
            self.tableView.reloadData()
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ContactCell
        cell.lblName.text = dataArray[indexPath.row].value(forKey: kNameStr) as? String
        cell.lblContactNo.text = dataArray[indexPath.row].value(forKey: kDescStr) as? String
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "SegueAdd", sender: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            appDelegateObj.managedObjectContext.delete(dataArray[indexPath.row])
            do {
                try appDelegateObj.managedObjectContext.save()
                dataArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch {
                let saveError = error as NSError
                print(saveError)
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueAdd" {
            let vc : AddVC = segue.destination as! AddVC
            vc.dataArray = dataArray
            vc.editRecNo = sender as! Int
            
        }
    }
    
    @IBAction func btnAddTapped(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "SegueAdd", sender: -1)
    }
}

class ContactCell : UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblContactNo: UILabel!
    
}

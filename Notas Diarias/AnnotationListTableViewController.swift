//
//  AnotationListTableViewController.swift
//  Notas Diarias
//
//  Created by Jefferson Oliveira Araujo on 26/03/1401 AP.
//

import UIKit
import CoreData

class AnnotationListTableViewController: UITableViewController {
    
    var context: NSManagedObjectContext!
    var annotationList: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.getAnnotation()
    }
    
    func getAnnotation() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Anotacao")
        request.sortDescriptors = [orderList(key: "data", ascending: false)]
        
        do {
            let getAnnotation = try context.fetch(request)
            self.annotationList = getAnnotation as! [NSManagedObject]
            self.tableView.reloadData()
            
        } catch {
            print("Erro ao recuperar anotacoes: \(error.localizedDescription)")
        }
        
    }
    
    func orderList(key: String, ascending: Bool) -> NSSortDescriptor {
        let order = NSSortDescriptor(key: key, ascending: ascending)
        return order
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.annotationList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let annotation = self.annotationList[indexPath.row]
        
        let textAnnotation = annotation.value(forKey: "texto")
        let dataAnnotation = annotation.value(forKey: "data")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy - hh:mm"
        
        let newData = dateFormatter.string(from: dataAnnotation as! Date)
        
        cell.textLabel?.text = textAnnotation as? String
        cell.detailTextLabel?.text = newData

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let annotation = self.annotationList[indexPath.row]
        self.performSegue(withIdentifier: "openAnnotation", sender: annotation)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openAnnotation" {
            let viewDestination = segue.destination as! AnnotationViewController
            viewDestination.annotation = sender as? NSManagedObject
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            let annotation = self.annotationList[indexPath.row]
            self.context.delete(annotation)
            
            self.annotationList.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            do {
                try context.save()
            } catch {
                print("Erro ao salvar: \(error.localizedDescription)")
            }
            
        }
        
    }
    
}

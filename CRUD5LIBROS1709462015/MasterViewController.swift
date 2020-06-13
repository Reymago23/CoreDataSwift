// Joscelyn Beatriz Guido Martinez
// 17-0946-2015

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate, BookStoreDelegate {

    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext!

    var books: [AnyObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext as NSManagedObjectContext
        
        loadData()

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func insertNewObject(_ sender: Any) {
        self.performSegue(withIdentifier: "addBookSegue", sender: nil)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let book: Libro = books[indexPath.row] as! Libro
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = book
                controller.delegate = self                
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
        else if segue.identifier == "addBookSegue" {
            let vc = segue.destination as! AddBookViewController
            vc.delegate = self
        }
    }

    func loadData(){
        let fetchRequest: NSFetchRequest<Libro> = Libro.fetchRequest()
        
        do{
            books = try managedObjectContext.fetch(fetchRequest)
        }catch let error as NSError{
            NSLog("Error: %@", error)
        }
    }
    
    
    func newBook(_ controller:AnyObject,newBook:BookModel) {
        
        let book: Libro = NSEntityDescription.insertNewObject(forEntityName: "Libro", into: managedObjectContext) as! Libro
        
        book.title = newBook.title
        book.author = newBook.author
        book.pages = newBook.pages
        book.publicationYear = newBook.publicationYear
        
        do {
            try managedObjectContext.save()
            self.loadData()
            tableView.reloadData()
            _ = navigationController?.popViewController(animated: true)
        }catch let error as NSError {
            NSLog("Error: %@", error)
        }
        
    }
    
    
    
    func deleteBook(_ controller:AnyObject){
        let indexPath = tableView.indexPathForSelectedRow
        let row = (indexPath as NSIndexPath?)?.row
        
        self.managedObjectContext.delete(self.books[row!] as! NSManagedObject)
        
        do {
            try managedObjectContext.save()
            self.loadData()
            tableView.reloadData()
            _ = navigationController?.popViewController(animated: true)
        }catch let error as NSError {
            NSLog("Error: %@", error)
        }
        
    }
    
    
    
    func editBook(_ controller:AnyObject, editBook:BookModel){
        let indexPath = tableView.indexPathForSelectedRow
        let row = (indexPath as NSIndexPath?)?.row
        let book = books[row!] as! NSManagedObject
        
        book.setValue(editBook.author, forKey: "author")
        book.setValue(NSNumber(value:editBook.pages), forKey: "pages")
        book.setValue(NSNumber(value:editBook.publicationYear), forKey: "publicationYear")
        book.setValue(editBook.title, forKey: "title")
        
        do {
            try managedObjectContext.save()
            self.loadData()
            tableView.reloadData()
            _ = navigationController?.popViewController(animated: true)
        }catch let error as NSError {
            NSLog("Error: %@", error)
        }
    }
    
    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = books[indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //let context = self.fetchedResultsController.managedObjectContext
            // context.delete(self.fetchedResultsController.object(at: indexPath))
            
            let alertControler = UIAlertController(title: "Atencion", message: "Borrar este libro permanentemente?", preferredStyle: .alert)
            let noAction = UIAlertAction(title: "No", style: .cancel, handler: {
                (action) in print("cancel")
            })
            
            alertControler.addAction(noAction)
            
            let yesAction = UIAlertAction(title: "Si", style: .destructive, handler: {
                (action) in
                
                self.managedObjectContext.delete(self.books[indexPath.row] as! NSManagedObject)
                
                do {
                    //try context.save()
                    try self.managedObjectContext.save()
                    self.loadData()
                    tableView.reloadData()
                    _ = self.navigationController?.popViewController(animated: true)
                    
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            })
            
            alertControler.addAction(yesAction)
            
            present(alertControler, animated: false, completion: nil)
            
        }
    }

    func configureCell(_ cell: UITableViewCell, withEvent event: Event) {
        cell.textLabel!.text = event.timestamp!.description
    }

    // MARK: - Fetched results controller

    var fetchedResultsController: NSFetchedResultsController<Event> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
             // Replace this implementation with code to handle the error appropriately.
             // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             let nserror = error as NSError
             fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }    
    var _fetchedResultsController: NSFetchedResultsController<Event>? = nil

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
            case .insert:
                self.tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
            case .delete:
                self.tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
            default:
                return
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            case .insert:
                tableView.insertRows(at: [newIndexPath!], with: .fade)
            case .delete:
                tableView.deleteRows(at: [indexPath!], with: .fade)
            case .update:
                self.configureCell(tableView.cellForRow(at: indexPath!)!, withEvent: anObject as! Event)
            case .move:
                tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }

    /*
     // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
     
     func controllerDidChangeContent(controller: NSFetchedResultsController) {
         // In the simplest, most efficient, case, reload the table view.
         self.tableView.reloadData()
     }
     */

}


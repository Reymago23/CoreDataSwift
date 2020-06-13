// Joscelyn Beatriz Guido Martinez
// 17-0946-2015

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var pagesLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    var delegate: BookStoreDelegate? = nil
    
    var bookModel = BookModel()

    func configureView() {
        if let book = self.detailItem {
            titleLabel.text = book.title!
            authorLabel.text = book.author!
            pagesLabel.text = String(book.pages)
            yearLabel.text = String(book.publicationYear)
            
            bookModel.author = book.author!
            bookModel.publicationYear = book.publicationYear
            bookModel.pages = book.pages
            bookModel.title = book.title!
        }
    }

    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editDetail" {
            let vc = segue.destination as! AddBookViewController
            vc.editBook = true
            vc.delegate = delegate
            vc.bookModel = bookModel
        }
    }
    
    
    @IBAction func deleteBookAction(_ sender: AnyObject) {
        let alertControler = UIAlertController(title: "Atencion", message: "Borrar el libro permanentemente?", preferredStyle: .alert)
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: {
            (action) in print("cancel")
        })
        
        alertControler.addAction(noAction)
        
        let yesAction = UIAlertAction(title: "Si", style: .destructive, handler: {
            (action) in
            self.delegate!.deleteBook(self)
        })
        
        alertControler.addAction(yesAction)
        
        present(alertControler, animated: false, completion: nil)
    }
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    var detailItem: Libro? {
        didSet {

        }
    }
    
    
}


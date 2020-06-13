
// Joscelyn Beatriz Guido Martinez
// 17-0946-2015

import UIKit

protocol BookStoreDelegate {
    func newBook(_ controller: AnyObject, newBook: BookModel)
    func editBook(_ controller: AnyObject, editBook: BookModel)
    func deleteBook(_ controller: AnyObject)
}


class AddBookViewController: UIViewController {
    
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var authorField: UITextField!
    @IBOutlet weak var pagesField: UITextField!
    @IBOutlet weak var yearField: UITextField!
    
    @IBOutlet weak var titleErrorLabel: UILabel!
    @IBOutlet weak var authorErrorLabel: UILabel!
    @IBOutlet weak var pagesErrorLabel: UILabel!
    @IBOutlet weak var yearErrorLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var mainLabel: UILabel!
    
    var delegate: BookStoreDelegate?
    var bookModel = BookModel()
    var editBook = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        titleErrorLabel.isHidden = true
        authorErrorLabel.isHidden = true
        pagesErrorLabel.isHidden = true
        yearErrorLabel.isHidden = true
        
        if editBook {
            self.title = "Editar Libro"
            saveButton.setTitle("Actualizar", for: .normal)
            mainLabel.text = "Actualice los datos del libro"
            titleField.text = bookModel.title
            authorField.text = bookModel.author
            pagesField.text = String(bookModel.pages)
            yearField.text = String(bookModel.pages)
        }
        
    }

   
    @IBAction func saveBookAction(_ sender: AnyObject) {
        
        if  isValidInput() {
            
            self.bookModel.title = titleField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            self.bookModel.author = authorField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            self.bookModel.pages = Int32(pagesField.text!)!
            self.bookModel.publicationYear = Int32(yearField.text!)!
            print("\(self.bookModel.title), \(self.bookModel.author), \(self.bookModel.pages), \(self.bookModel.publicationYear) ")
            
           if editBook {
                delegate!.editBook(self, editBook: self.bookModel)
            }else {
                delegate!.newBook(self, newBook: self.bookModel)
            }
            
        }
    }
    
    
    func isValidInput() -> Bool {
        
        var validInputs = true
        
        if titleField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" {
            setErrorFeedBack(textField: self.titleField, label: titleErrorLabel)
            validInputs = false
        }else{
            removeErrorFeedBack(textField: self.titleField, label: titleErrorLabel)
        }
        
        if authorField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" {
            setErrorFeedBack(textField: self.authorField, label: authorErrorLabel)
            validInputs = false
        }else{
            removeErrorFeedBack(textField: self.authorField, label: authorErrorLabel)
        }
        
        if pagesField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" || Int32(pagesField.text!) == nil {
            setErrorFeedBack(textField: self.pagesField, label: pagesErrorLabel)
            validInputs = false
        }else{
            removeErrorFeedBack(textField: self.pagesField, label: pagesErrorLabel)
        }
        
        if yearField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" || Int32(yearField.text!) == nil {
            setErrorFeedBack(textField: self.yearField, label: yearErrorLabel)
            validInputs = false
        }else{
            removeErrorFeedBack(textField: self.yearField, label: yearErrorLabel)
        }
        
        return validInputs
    }
    
    
    func  setErrorFeedBack(textField: UITextField, label: UILabel) {
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5.0
        label.isHidden = false
    }
    
    func  removeErrorFeedBack(textField: UITextField, label: UILabel) {
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 0.25
        textField.layer.cornerRadius = 5.0
        label.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//
//  AnnotationViewController.swift
//  Notas Diarias
//
//  Created by Jefferson Oliveira Araujo on 26/03/1401 AP.
//

import UIKit
import CoreData

class AnnotationViewController: UIViewController {
    
    @IBOutlet weak var buttonSave: UIBarButtonItem!
    @IBOutlet weak var newText: UITextView!
    var context: NSManagedObjectContext!
    var annotation: NSManagedObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if annotation != nil {
            newText.text = annotation.value(forKey: "texto") as? String
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        newText.becomeFirstResponder() // MARK: abre o teclado autom.
    }
    
    // MARK: fecha o teclado ao ser clicado fora dele
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    var verifyText: Bool {
        guard let newText = newText.text, let annotation = annotation else { return false }
        return true
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        buttonSave.isEnabled = verifyText
        
        if annotation != nil {
            self.saveAnnotation(update: true)
        } else {
            self.saveAnnotation(update: false)
        }
        
//        self.navigationController?.popToRootViewController(animated: true)
        self.navigationController?.popViewController(animated: true)
    }

    func saveAnnotation(update: Bool) {
        
        if update {
            annotation.setValue(self.newText.text, forKey: "texto")
            annotation.setValue( Date(), forKey: "data" )
        } else {
            let newAnnotation = NSEntityDescription.insertNewObject(forEntityName: "Anotacao", into: context)
            newAnnotation.setValue( self.newText.text, forKey: "texto" )
            newAnnotation.setValue( Date(), forKey: "data" )
        }
        
        do {
            try context.save()
            print("Sucesso ao salvar a anotação.")
        } catch {
            print("Erro ao salvar: \(error.localizedDescription)")
        }
    }

}

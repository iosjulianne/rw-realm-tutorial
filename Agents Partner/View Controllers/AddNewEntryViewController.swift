/**
 * Copyright (c) 2018 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import RealmSwift

//
// MARK: - Add New Entry View Controller
//
class AddNewEntryViewController: UIViewController {
  @IBOutlet weak var categoryTextField: UITextField!
  @IBOutlet weak var descriptionTextField: UITextView!
  @IBOutlet weak var nameTextField: UITextField!
    
    var selectedCategory: Category!
    var specimen: Specimen!
  
  //
  // MARK: - Variables And Properties
  //
  var selectedAnnotation: SpecimenAnnotation!
  
  //
  // MARK: - IBActions
  //
  @IBAction func unwindFromCategories(segue: UIStoryboardSegue) {
    if segue.identifier == "CategorySelectedSegue" {
        let categoriesController = segue.source as! CategoriesTableViewController
        selectedCategory = categoriesController.selectedCategory
        categoryTextField.text = selectedCategory.name
    }
  }
  
  //
  // MARK: - Private Methods
  //
  func validateFields() -> Bool {
    if nameTextField.text!.isEmpty ||
        descriptionTextField.text!.isEmpty ||
        selectedCategory == nil {
      let alertController = UIAlertController(title: "Validation Error",
                                              message: "All fields must be filled",
                                              preferredStyle: .alert)
      
      let alertAction = UIAlertAction(title: "OK", style: .destructive) { alert in
        alertController.dismiss(animated: true, completion: nil)
      }
      
      alertController.addAction(alertAction)
      
      present(alertController, animated: true, completion: nil)
      
      return false
    } else {
      return true
    }
  }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if validateFields(){
            addNewSpecimen()
            
            return true
        } else {
            return false
        }
    }
  
  //
  // MARK: - View Controller
  //
  override func viewDidLoad() {
    super.viewDidLoad()
  }
    
    
    func addNewSpecimen(){
        let realm = try! Realm() // 1
        
        try! realm.write { // 2
            let newSpecimen = Specimen() // 3
            
            newSpecimen.name = nameTextField.text! // 4
            newSpecimen.category = selectedCategory
            newSpecimen.specimenDescription = descriptionTextField.text!
            newSpecimen.latitude = selectedAnnotation.coordinate.latitude
            newSpecimen.longitude = selectedAnnotation.coordinate.longitude
            
            realm.add(newSpecimen) // 5
            specimen = newSpecimen // 6
        }
    }
/*
     1. First, get a Realm instance, like before.
     2. Start the write transaction to add your new Specimen.
     3. Create a new Specimen instance.
     4. Assign the Specimen values. The values come from the input text fields in the user interface, the selected categories and the coordinates from the map annotation.
     5. Add the new Specimen to the realm.
     6. Assign the new Specimen to your specimen property.
*/
    
}

//
// MARK: - Text Field Delegate
//
extension AddNewEntryViewController: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    performSegue(withIdentifier: "Categories", sender: self)
  }
}

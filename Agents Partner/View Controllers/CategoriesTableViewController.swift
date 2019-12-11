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
// MARK: - Categories Table View Controller
//
class CategoriesTableViewController: UITableViewController {
//
// MARK: - Variables And Properties
//
// First create a realm instance, then populate categories by calling objects(_:) on it, and pass in the class name of the model you want
// **In my own code, should be using try/do/catch instead of try!**
    let realm = try! Realm()
    lazy var categories: Results<Category> = { self.realm.objects(Category.self) }()
    var selectedCategory: Category!
    
    private func populateDefaultCategories() {
        if categories.count == 0 { // 1
            try! realm.write() { // 2
                let defaultCategories =
                    ["Birds", "Mammals", "Flora", "Reptiles", "Arachnids"] // 3
                
                for category in defaultCategories { // 4
                    let newCategory = Category()
                    newCategory.name = category
                    
                    realm.add(newCategory)
                }
            }
            
            categories = realm.objects(Category.self) // 5
        }
    }
  
/*
     1. If count is equal to 0, this means the database has no Category records. This is the case the first time you run the app
     2. This starts a transaction on realm, and you’re now ready to add some records to the database.
     3. Here, you create the list of default category names and then iterate through them.
     4. For each category name, you create a new instance of Category, populate name and add the object to realm.
     5. You fetch all of the categories you created and store them in categories.
*/
    
  //
  // MARK: - View Controller
  //
  override func viewDidLoad() {
    super.viewDidLoad()
    populateDefaultCategories()
  }
}

//
// MARK: - Table View Data Source
//
extension CategoriesTableViewController {
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
    let category = categories[indexPath.row]
    cell.textLabel?.text = category.name
    return cell
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categories.count
  }
  
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    selectedCategory = categories[indexPath.row]
    return indexPath
  }
}

//
//  CategoryViewController.swift
//  Expense Tracker
//
//  Created by Josh Tai on 11/27/23.
//

import UIKit
import CoreData

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var catPageTitle: UILabel!
    private var tableView: UITableView!
    public var accEmail: String = ""
    
    private var expensesByCategory = [CategoryData]()
    
    // Add a property for the managed object context
    private var context: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.accEmail = Global.accEmail
        
        // Get the managed object context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError(NSLocalizedString("Unable to access AppDelegate", comment: "Error message"))
        }
        context = appDelegate.persistentContainer.viewContext
        
        setupUI()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Reload the data every time the view appears
        fetchData()
    }
    
    private func setupUI() {
        // Initialize Expenses by Category Page Title Label
        self.catPageTitle = UILabel()
        self.catPageTitle.text = NSLocalizedString("Expenses by Category", comment: "Category view page title")
        self.catPageTitle.font = UIFont.systemFont(ofSize: 28)
        self.catPageTitle.numberOfLines = 0
        self.catPageTitle.lineBreakMode = .byWordWrapping
        self.catPageTitle.textAlignment = .center
        self.catPageTitle.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(catPageTitle)
        
        // Contraints for catPageTitle
        NSLayoutConstraint.activate([
            self.catPageTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.catPageTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            self.catPageTitle.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            self.catPageTitle.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
        
        // Initialize and setup Table View
        self.tableView = UITableView()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        
        // Constraints for tableView
        NSLayoutConstraint.activate([
            self.tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.tableView.topAnchor.constraint(equalTo: catPageTitle.bottomAnchor, constant: 20),
            self.tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            self.tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            self.tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
    }
    
    @objc private func fetchData() {
        let fetchRequest: NSFetchRequest<ExpenseEntity> = ExpenseEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "accemail == %@", accEmail)
        print("Showing expenses for accEmail: \(accEmail)")
        
        do {
            let expenses = try context.fetch(fetchRequest)
            let groupedExpenses = Dictionary(grouping: expenses, by: { $0.category ?? "" })
            expensesByCategory = groupedExpenses.map { (category, expenses) in
                CategoryData(category: category, expenses: expenses)
            }
        } catch {
            print("Error fetching data from context \(error)")
            
            let alert = UIAlertController(
                title: NSLocalizedString("Error: Failed to retrieve expenses.", comment: "Error title"),
                message: String(format: NSLocalizedString("Failed to retrieve expenses for the account %@", comment: "Error message"), accEmail),
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        self.tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return expensesByCategory.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let categoryData = expensesByCategory[section]
        return categoryData.expenses.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let categoryData = expensesByCategory[section]
        return "\(categoryData.category) - Subtotal: \(categoryData.subtotal)"

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let categoryData = expensesByCategory[indexPath.section]
        let expense = categoryData.expenses[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = NSLocalizedString("MM/dd/yyyy", comment: "Date format") // Adjust the date format as needed
        let dateString = dateFormatter.string(from: expense.date ?? Date())
        
        cell.textLabel?.text = "\(expense.title ?? "")\n    \(dateString) - \(expense.amount)"
        cell.textLabel?.numberOfLines = 0 // Allow for multiple lines
        
        return cell
    }
        
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Retrieve the category and the expense to be deleted
            let categoryData = expensesByCategory[indexPath.section]
            let expenseToDelete = categoryData.expenses[indexPath.row]
            
            // Delete from Core Data
            context.delete(expenseToDelete)
            
            do {
                try context.save()
                // Update your data source array
                expensesByCategory[indexPath.section].expenses.remove(at: indexPath.row)
                
                // Check if the entire section should be deleted
                if expensesByCategory[indexPath.section].expenses.isEmpty {
                    expensesByCategory.remove(at: indexPath.section)
                    tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
                } else {
                    // Delete the row from the table view
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            } catch {
                // Handle the error, e.g., show an alert
                print("Error deleting expense: \(error)")
            }
        }
        fetchData()
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle selection for detail view if necessary
    }
}

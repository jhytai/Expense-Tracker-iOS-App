//
//  CategoryViewController.swift
//  Expense Tracker
//
//  Created by Josh Tai on 11/27/23.
//

import UIKit
import CoreData

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var catPageTitle : UILabel!
    private var tableView    : UITableView!
    public  var accEmail     : String = ""
    
    private var expensesByCategory = [String: [ExpenseEntity]]()
    
    // Add a property for the managed object context
    private var context : NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the managed object context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Unable to access AppDelegate")
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
        self.catPageTitle.text = "Expenses by Category"
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
    
    private func fetchData() {
        // Fetch data from Core Data and group by category
        let fetchRequest: NSFetchRequest<ExpenseEntity> = ExpenseEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "accemail == %@", accEmail)
        
        do {
            let expenses = try context.fetch(fetchRequest)
            self.expensesByCategory = Dictionary(grouping: expenses, by: { $0.category ?? "" })
            self.tableView.reloadData()
        } catch {
            print("Error fetching data from context \(error)")
            
            let alert = UIAlertController(title: "Error: Failed to retrieve expenses.",
                message: "Failed to retrieve expenses for the account \(accEmail).",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - UITableViewDataSource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return expensesByCategory.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let category = Array(expensesByCategory.keys)[section]
        return expensesByCategory[category]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(expensesByCategory.keys)[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let category = Array(expensesByCategory.keys)[indexPath.section]
        if let expenses = expensesByCategory[category] {
            let expense = expenses[indexPath.row]
            cell.textLabel?.text = "\(expense.title ?? "") - \(expense.amount)"
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle selection for detail view if necessary
    }
    
}

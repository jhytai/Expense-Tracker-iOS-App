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
    
    private var expensesByCategory = [CategoryData]()
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchData), name: NSNotification.Name("NewExpenseAdded"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Ensure the accEmail is set correctly getting it from ExpensesViewController
        if let tabBarControllers = tabBarController?.viewControllers {
            for viewController in tabBarControllers {
                if let expensesVC = viewController as? ExpensesViewController {
                    self.accEmail = expensesVC.accEmail
                }
            }
        }
        
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
            
            let alert = UIAlertController(title: "Error: Failed to retrieve expenses.",
                message: "Failed to retrieve expenses for the account \(accEmail).",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
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
        dateFormatter.dateFormat = "MM/dd/yyyy" // Adjust the date format as needed
        let dateString = dateFormatter.string(from: expense.date ?? Date())
        
        cell.textLabel?.text = "\(expense.title ?? "")\n    \(dateString) - \(expense.amount)"
        cell.textLabel?.numberOfLines = 0 // Allow for multiple lines
        
        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle selection for detail view if necessary
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

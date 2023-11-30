//
//  HistoryViewController.swift
//  Expense Tracker
//
//  Created by Josh Tai on 11/26/23.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var histPageTitle    : UILabel!
    private var exportButton     : UIButton!
    private var historyTableView : UITableView!
    
    public  var accEmail     : String = ""
    private var historyFiles : [String] = []
    
    private var context: NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Unable to access AppDelegate")
        }
        return appDelegate.persistentContainer.viewContext
    }
    
    //private var expense = [ExpenseData]()
    
    // Add a property for the managed object context
    //private var context : NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.accEmail = Global.accEmail
        
        setupUI()
        loadHistoryFiles()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Reload files every time the view appears
        loadHistoryFiles()
    }
    
    private func setupUI() {
        // Initialize Expenses History Page Title Label
        histPageTitle = UILabel()
        histPageTitle.text = "Expenses History"
        histPageTitle.font = UIFont.systemFont(ofSize: 28)
        histPageTitle.numberOfLines = 0
        histPageTitle.lineBreakMode = .byWordWrapping
        histPageTitle.textAlignment = .center
        histPageTitle.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(histPageTitle)
        
        // Initialize 'Export History' button
        exportButton = UIButton(type: .system)
        exportButton.setTitle("Export History", for: .normal)
        exportButton.addTarget(self, action: #selector(exportHistory), for: .touchUpInside)
        exportButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exportButton)
        
        // Initialize UITableView
        historyTableView = UITableView()
        historyTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        historyTableView.delegate = self
        historyTableView.dataSource = self
        historyTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(historyTableView)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            histPageTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            histPageTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            histPageTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            histPageTitle.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            exportButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            exportButton.topAnchor.constraint(equalTo: histPageTitle.bottomAnchor, constant: 20),
            
            historyTableView.topAnchor.constraint(equalTo: exportButton.bottomAnchor, constant: 20),
            historyTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            historyTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            historyTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
    }
    
    private func loadHistoryFiles() {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
            historyFiles = fileURLs
                .map { $0.lastPathComponent }
                .filter { $0.hasPrefix("\(accEmail)_history_") && $0.hasSuffix(".txt") }
            historyTableView.reloadData()
        } catch {
            print("Error listing history files: \(error)")
        }
    }
    
    @objc private func exportHistory() {
        let expenses = fetchExpensesForUser(accEmail: accEmail)
        let historyText = formatExpensesAsText(expenses: expenses)
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .medium,
            timeStyle: .short).replacingOccurrences(of: "/", with: "-").replacingOccurrences(of: ",", with: "").replacingOccurrences(of: " ", with: "_")
        let fileName = "\(accEmail)_history_\(timestamp).txt"
        
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentDirectory.appendingPathComponent(fileName)
            do {
                try historyText.write(to: fileURL, atomically: true, encoding: .utf8)
                print("History exported to \(fileURL)")
                historyFiles.append(fileName)
                historyTableView.reloadData()
            } catch {
                print("Error writing history file: \(error)")
            }
        }
    }
    
    private func fetchExpensesForUser(accEmail: String) -> [ExpenseEntity] {
        let fetchRequest: NSFetchRequest<ExpenseEntity> = ExpenseEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "accemail == %@", accEmail)
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching expenses: \(error)")
            return []
        }
    }

    
    private func formatExpensesAsText(expenses: [ExpenseEntity]) -> String {
        var historyText = "Title, Category, Amount, Date, Account Email\n"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        for expense in expenses {
            let dateStr = dateFormatter.string(from: expense.date ?? Date() )
            historyText += "\(String(describing: expense.title)), \(String(describing: expense.category)), \(expense.amount), \(dateStr), \(String(describing: expense.accemail))\n"
        }
        
        return historyText
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyFiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = historyFiles[indexPath.row]
        cell.textLabel?.numberOfLines = 0 // Allow for multiple lines
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Get the file name
            let fileName = historyFiles[indexPath.row]
            
            // Remove the file from the documents directory
            if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = documentDirectory.appendingPathComponent(fileName)
                do {
                    try FileManager.default.removeItem(at: fileURL)
                    
                    // Remove the file from the historyFiles array
                    historyFiles.remove(at: indexPath.row)
                    
                    // Delete the row from the table view
                    tableView.deleteRows(at: [indexPath], with: .fade)
                } catch {
                    print("Error deleting history file: \(error)")
                }
            }
        }
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Open and display the selected history file
        let fileName = historyFiles[indexPath.row]
        openHistoryFile(named: fileName)
    }
    
    private func openHistoryFile(named fileName: String) {
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentDirectory.appendingPathComponent(fileName)
            do {
                let contents = try String(contentsOf: fileURL, encoding: .utf8)
                // Here, you can display contents in a new view controller or a pop-up
                print(contents) // This is just a placeholder
            } catch {
                print("Error reading file: \(error)")
            }
        }
    }
    
}

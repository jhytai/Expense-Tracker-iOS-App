//
//  Expenses.swift
//  Expense Tracker
//
//  Created by Josh Tai on 11/26/23.
//

import UIKit
import AVKit
import CoreData

class ExpensesViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var expPageTitle     : UILabel!
    @IBOutlet var expTitleLabel    : UILabel!
    @IBOutlet var expTitle         : UITextField!
    @IBOutlet var expCategoryLabel : UILabel!
    @IBOutlet var expCategory      : UITextField!
    @IBOutlet var expAmountLabel   : UILabel!
    @IBOutlet var expAmount        : UITextField!
    @IBOutlet var expDateLabel     : UILabel!
    @IBOutlet var expDate          : UIDatePicker!
    @IBOutlet var submitButton     : UIButton!
    
    private   var audioPlayer      : AVAudioPlayer!
    
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 2
        return nf
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // Function to control and validate changes to Rounds Text Input Field
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let keyboardType = textField.keyboardType
        
        if  keyboardType == .numberPad {
            // Define character set that includes only numeric characters
            let allowedCharacterSet = CharacterSet(charactersIn: "0123456789")
            
            // Check if the replacement string contains only the allowed characters
            let characterSet = CharacterSet(charactersIn: string)
            
            // If only numeric digits, accept. Else, reject the replacement string
            return allowedCharacterSet.isSuperset(of: characterSet)
            }
        else if keyboardType == .namePhonePad {
            // Define character set that includes only letter characters and space
            let allowedCharacterSet = CharacterSet.letters.union(CharacterSet(charactersIn: " "))
            
            // Iterate over string to make sure it only contains allowed characters
            for c in string {
                if !allowedCharacterSet.isSuperset(of: CharacterSet(charactersIn: String(c))) {
                    // Prevent input of characters that are not letters or spaces
                    return false
                    }
                }
            }
        else if keyboardType == .decimalPad {
            if string.rangeOfCharacter(from: CharacterSet.letters) != nil
                {
                return false
                }
            
            let currentLocale = Locale.current
            let decimalSeparator = currentLocale.decimalSeparator ?? "."
            let existingTextHasDecimalSeparator = textField.text?.range(of: decimalSeparator)
            let replacementTextHasDecimalSeparator = string.range(of: decimalSeparator)
            
            if existingTextHasDecimalSeparator != nil, replacementTextHasDecimalSeparator != nil
                {
                return false
                }
            }
        
        return true
        }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer)
        {
        self.expTitle.resignFirstResponder()
        self.expCategory.resignFirstResponder()
        self.expAmount.resignFirstResponder()
        print("Background tapped!")
        }
    
    @IBAction func submitExpTapped (_ sender: UIButton) {
        print("Submit expense button tapped!")
        
        // Validate form data
        guard let title = expTitle.text, !title.isEmpty,
              let category = expCategory.text, !category.isEmpty,
              let amountText = expAmount.text, let amount = Double(amountText),
              amount > 0 else {
            // Handle validation error
            print("Validation failed.")
            
            let alert = UIAlertController(title: "Error: Invalid data in the form, or form is empty.",
                message: "Please enter valid data in the form, then submit again.",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        // Get the managed object context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        
        // Create a new expense record
        let expense = ExpenseEntity(context: context)
        expense.title = title
        expense.category = category
        expense.amount = amount
        expense.date = expDate.date
        
        // Save the context
        do  {
            try context.save()
            print("Expense saved.")
            
            let alert = UIAlertController(title: "Successfully added new expense.",
                message: "You can see the expenses in Category or History tab.",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } catch {
            print("Failed to save expense: \(error)")
            
            let alert = UIAlertController(title: "Error: Failed to add expense.",
                message: "Database is not accessible to save new expense entry.",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        
        // Reset the form
        resetForm()
        
        // Play audio feedback
        playSubmitAudio()
    }
    
    private func resetForm() {
        expTitle.text = ""
        expCategory.text = ""
        expAmount.text = ""
        expDate.date = Date()
    }
    
    private func playSubmitAudio() {
        if let audioPath = Bundle.main.path(forResource: "cha ching", ofType: "mp3") {
            do  {
                let audioURL = URL(fileURLWithPath: audioPath)
                try self.audioPlayer = AVAudioPlayer(contentsOf: audioURL)
                self.audioPlayer.volume = 10
                self.audioPlayer.currentTime = 0
                self.audioPlayer.prepareToPlay()
                self.audioPlayer.play()
            } catch {
                print("Failed to play cha-ching sound.")
            }
        }
    }
    
}

//
//  ExpensesViewController.swift
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
    public    var accEmail         : String = ""

    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 2
        return nf
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.accEmail = Global.accEmail
        print("Received accEmail from Login: \(accEmail)")
    }

    // Function to control and validate changes to Rounds Text Input Field
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let keyboardType = textField.keyboardType

        // Keyboard type "Name Phone Pad" for expense category text field
        if keyboardType == .namePhonePad {
            // Define character set that includes only letter characters
            let allowedCharacterSet = CharacterSet.letters

            // Iterate over string to make sure it only contains letter characters
            for c in string {
                if !allowedCharacterSet.isSuperset(of: CharacterSet(charactersIn: String(c))) {
                    // Prevent input on non-letter characters
                    return false
                }
            }
        }
        // Keyboard type "Decimal Pad" for expense amount text field
        else if keyboardType == .decimalPad {
            if string.rangeOfCharacter(from: CharacterSet.letters) != nil {
                return false
            }

            let currentLocale = Locale.current
            let decimalSeparator = currentLocale.decimalSeparator ?? "."
            let existingTextHasDecimalSeparator = textField.text?.range(of: decimalSeparator)
            let replacementTextHasDecimalSeparator = string.range(of: decimalSeparator)

            if existingTextHasDecimalSeparator != nil, replacementTextHasDecimalSeparator != nil {
                return false
            }
        }

        return true
    }

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.expTitle.resignFirstResponder()
        self.expCategory.resignFirstResponder()
        self.expAmount.resignFirstResponder()
        print("Background tapped")
    }

    @IBAction func submitExpTapped (_ sender: UIButton) {
        print("Submit expense button tapped!")

        // Validate form data
        guard let title = expTitle.text, !title.isEmpty,
              let category = expCategory.text, !category.isEmpty,
              let amountText = expAmount.text, 
              // replaced direct conversion of the amountText to a Double with  NumberFormatter.This  allows  to  handle different number formats based on user's locale
              let amount = numberFormatter.number(from: amountText)?.doubleValue,
              amount > 0 else {
            // Handle validation error
            print("Validation failed.")

            let alert = UIAlertController(title: NSLocalizedString("Error: Invalid data in the form, or form is empty.", comment: "Error: Invalid data in the form, or form is empty"),
                                          message: NSLocalizedString("Please enter valid data in the form, then submit again.", comment: "Please enter valid data in the form, then submit again"),
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: nil))
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
        expense.accemail = accEmail

        // Save the context
        do {
            try context.save()
            print("New expense saved for accEmail: \(accEmail)")

            NotificationCenter.default.post(name: NSNotification.Name("NewExpenseAdded"), object: nil)

            let alert = UIAlertController(title: NSLocalizedString("Successfully added new expense.", comment: "Successfully added new expense"),
                                          message: NSLocalizedString("You can see the expenses in Category or History tab.", comment: "You can see the expenses in Category or History tab"),
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)

        } catch {
            print("Failed to save expense: \(error)")

            let alert = UIAlertController(title: NSLocalizedString("Error: Failed to add expense.", comment: "Error: Failed to add expense"),
                                          message: NSLocalizedString("Database is not accessible to save new expense entry.", comment: "Database is not accessible to save new expense entry"),
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: nil))
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
            do {
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

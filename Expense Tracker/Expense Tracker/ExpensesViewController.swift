//
//  Expenses.swift
//  Expense Tracker
//
//  Created by Josh Tai on 11/26/23.
//

import UIKit
import AVKit

class ExpensesViewController: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitExpTapped (_ sender: UIButton) {
        print("Submit expense button tapped!")
        
        if let audioPath = Bundle.main.path(forResource: "cha ching", ofType: "mp3")
            {
            do  {
                let audioURL = URL(fileURLWithPath: audioPath)
                try self.audioPlayer = AVAudioPlayer(contentsOf: audioURL)
                self.audioPlayer.volume = 10
                self.audioPlayer.currentTime = 0
                self.audioPlayer.prepareToPlay()
                self.audioPlayer.play()
                }
            catch { print("Failed to play Banana_Slip sound.") }
            }
    }
}

//
//  ViewController.swift
//  Expense Tracker
//
//  Created by Danyal Nemati on 11/16/23.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    
    @IBOutlet var appTitleLabel   : UILabel!
    @IBOutlet var appLogoImage    : UIImageView!
    @IBOutlet var loginButton     : UIButton!
    @IBOutlet var createAccButton : UIButton!
    
    private   var audioPlayer      : AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setGradientBackground()
    }
    
    @IBAction func loginButtonTapped (_ sender: UIButton) {
        print("Login button tapped!")
    }
    
    @IBAction func createAccButtonTapped (_ sender: UIButton) {
        print("Create account button tapped!")
    }
    
    @IBAction func logoTapped (_sender: UITapGestureRecognizer) {
        print("Expense Tracker's logo tapped!")
        changeImage()
        blinkLogo()
        playAudio()
    }
    
    func setGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemPurple.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.bounds
        
        // Add the gradient layer to the view
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func playAudio() {
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
    
    private func blinkLogo() {
        UIView.animate(withDuration: 0.1, animations: {
            self.appLogoImage.alpha = 0
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.appLogoImage.alpha = 1
            }
        }
    }
    
    private func changeImage() {
        if appLogoImage.image == UIImage(named: "ExpenseLogov2") {
            appLogoImage.image = UIImage(named: "ExpenseLogo")
        } else {
            appLogoImage.image = UIImage(named: "ExpenseLogov2")
        }
    }
}

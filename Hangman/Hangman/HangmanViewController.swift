//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class HangmanViewController: UIViewController, UITextFieldDelegate {


    @IBOutlet weak var hangman: UIImageView!
    @IBOutlet weak var hangPhrase: UILabel!
    @IBOutlet weak var incorrectGuesses: UILabel!
    @IBOutlet weak var guesedLetter: UITextField!
    @IBOutlet weak var guessBut: UIButton!
    
    
        
    var phrase: String?
    var guessingPhrase: String?
    var guesedSet = Set<String>()
    var incorrectGuessesSet = Set<String>()
    var death = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guessBut.layer.cornerRadius = 3;
        guessBut.layer.borderWidth = 2;
        guessBut.layer.borderColor = UIColor.white.cgColor
        

        let hangmanPhrases = HangmanPhrases()
        // Generate a random phrase for the user to guess
               
        self.phrase = hangmanPhrases.getRandomPhrase()
        print(phrase!)
        
        initializeTextFields()
        incorrectGuesses.text = ""
        
        displayWord()
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Make sure that textfield contains only letters
    func initializeTextFields() {
        guesedLetter.delegate = self
        guesedLetter.keyboardType = UIKeyboardType.asciiCapable
    }
    
    
    // Keep track of guesed letters
    func displayWord(){
        
        hangPhrase.text = ""

        for x in phrase!.characters {
            if (guesedSet.contains(String(x))){
                hangPhrase.text = hangPhrase.text! + String(x)
            }else if x == " "{
                hangPhrase.text = hangPhrase.text! + " "
            } else {
                hangPhrase.text = hangPhrase.text! + "- "
            }
        }
        ifWon()
    }
    
    
    // Check the validity of the textfield
    func textField(_ textField: UITextField,
                             shouldChangeCharactersIn range: NSRange,
                               replacementString string: String) -> Bool {
        //Check username contains a letter
        
        // We still return true to allow the change to take place.
        if string.characters.count == 0 {
            return true
        }
        
        // If the contents still fit the constraints, allow the change
        // by returning true; otherwise disallow the change by returning false.
        let prospectiveText = (guesedLetter.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        let resultingStringLengthIsLegal = prospectiveText.characters.count == 1
            
            
        switch textField {
                
        // Allow only upper- and lower-case vowels in this field,
        // and limit its contents to a maximum of 6 characters.
        case guesedLetter:
            return prospectiveText.containsOnlyCharactersIn(matchCharacters: "ABCDEFGHIJKLMNOPQRSTUVWXYZ") && resultingStringLengthIsLegal
            
        // Do not put constraints on any other text field in this view
        // that uses this class as its delegate.
        default:
            return true
        }
    }
    
    @IBAction func makeGuess(_ sender: UIButton) {
        
        if let guess = guesedLetter.text {
            print(guess)
            if (guess == ""){
                let alert = UIAlertController(
                    title: "Can't submint an empty field",
                    message: "Chose a letter :)",
                    preferredStyle: UIAlertControllerStyle.alert)
                let continueGame = UIAlertAction(title: "OK", style: .default)
                alert.addAction(continueGame)
                self.present(alert, animated: true, completion: nil)
            }else {
                var inserted = false
                
                for x in phrase!.characters{
                    if (guess == String(x)) {
                        guesedSet.insert(guess)
                        
                        inserted = true
                    }
                }
                
                if (!inserted && !incorrectGuessesSet.contains(guess)){
                    incorrectGuessesSet.insert(guess)
                    ifLoos()
                }
                
                incorrectGuesses.text = String(describing:incorrectGuessesSet)
                
                guesedLetter.text = ""
                displayWord()
            }
            
        }else {
            print("You forgot to enter some a guess!")
        }

    }
    
    func ifLoos(){
        if death < 7 {
            death += 1
            hangman.image = UIImage(named: "hangman" + String(death) + ".gif")
        }else if(death == 7) {
            finish()
        }
    }
    
    func finish(){
        makeAlert(t: "You Lost!", m: "Let's try again")
    }
    
    func reset(){
        print("reset")
        let hangmanPhrases = HangmanPhrases()
        
        self.phrase = hangmanPhrases.getRandomPhrase()
        print(phrase!)
        initializeTextFields()
        incorrectGuesses.text = ""
        self.death = 1
        self.hangman.image = UIImage(named: "hangman" + String(death) + ".gif")
        self.guesedSet = Set<String>()
        self.incorrectGuessesSet = Set<String>()
        self.guessBut.isEnabled = true
        displayWord()
    }
    
    func ifWon(){
        print(hangPhrase.text!)
        
        for x in hangPhrase.text!.characters {
            print(x)
            if (String(x) == "-"){
                return
            }
        }
        print("You won!")
        
        makeAlert(t: "You Made It!", m: "Let's play a new game")

    }
   
    func makeAlert(t: String, m: String){
        // create the alert
        let alert = UIAlertController(
            title: t,
            message: m,
            preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        let newGame = UIAlertAction(title: "OK", style: .default) {
            action in self.reset()
        }
        
        // show the alert
        alert.addAction(newGame)
        self.present(alert, animated: true, completion: nil)
        
    }
    @IBAction func startOver(_ sender:UIBarButtonItem) {
        makeAlert(t: "Do you want to start over?", m: "Let's play a new game")
    }
    
    @IBAction func giveUp(_ sender: UIBarButtonItem) {
        hangPhrase.text = phrase
        death = 7
        hangman.image = UIImage(named: "hangman" + String(death) + ".gif")
        guessBut.isEnabled = false
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

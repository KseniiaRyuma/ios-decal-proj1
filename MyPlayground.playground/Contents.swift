//: Playground - noun: a place where people can play

import UIKit


let alertController = UIAlertController(title: "Hey AppCoda", message: "What do you want to do?", preferredStyle: .alert)
    
let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(defaultAction)
    
presentViewController(alertController, animated: true, completion: nil)




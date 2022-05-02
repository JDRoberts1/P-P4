//
//  ViewController.swift
//  GetFocused
//
//  Created by Nai Roberts on 4/24/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func segueToTimer(_ sender: UIButton){
        
        performSegue(withIdentifier: "timerSegue", sender: sender)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let selectedbttn = sender as! UIButton
        
        if selectedbttn.tag <= 4{
            let destination = segue.destination as! TimerViewController
            
            // Set button tag variable for TimerViewController for switch statement
            destination.tag = selectedbttn.tag
            
        }
        
    }
    
    @IBAction func unwindToHome(_ unwindSegue: UIStoryboardSegue) {
        
        // Use data from the view controller which initiated the unwind segue
    }


}


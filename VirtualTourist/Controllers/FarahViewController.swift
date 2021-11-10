//
//  FarahViewController.swift
//  VirtualTourist
//
//  Created by Zakaria on 07/11/2021.
//

import UIKit

class FarahViewController: UIViewController {

    @IBOutlet weak var buttonPressed: UIButton!
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

   
    @IBAction func button(_ sender: UIButton) {
        performSegue(withIdentifier: "goTo", sender: self)
        print("aaaaaa")
    }
    
}

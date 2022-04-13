//
//  ResultViewController.swift
//  ShippingCostCalculator
//
//  Created by Максим Беседин on 13.03.2022.
//

// Москва
// Ставрополь

import UIKit

class ResultViewController: UIViewController {
    
    var result : String?

    @IBOutlet weak var resultOutlet: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        resultOutlet.text = result!
    }
    

    @IBAction func recalculateButton(_ sender: UIButton) {
//        self.dismiss(animated: true, completion: nil)
        
        self.performSegue(withIdentifier: "goToMap", sender: self)

    }
    
}


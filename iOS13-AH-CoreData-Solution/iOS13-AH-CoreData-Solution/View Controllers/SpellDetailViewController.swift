//
//  SpellDetailViewController.swift
//  iOS13-AH-CoreData-Solution
//
//  Created by Austin Potts on 1/29/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class SpellDetailViewController: UIViewController {

    @IBOutlet weak var spellName: UITextField!
    @IBOutlet weak var threatLevel: UISegmentedControl!
    
    @IBOutlet weak var spellDetail: UITextView!
    @IBOutlet weak var saveSpellButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        saveSpellButton.layer.cornerRadius = 25
    }
    

    @IBAction func saveSpellButtonTapped(_ sender: Any) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

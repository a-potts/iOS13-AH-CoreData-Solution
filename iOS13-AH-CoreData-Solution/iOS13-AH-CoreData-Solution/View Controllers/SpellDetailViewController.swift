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
    @IBOutlet weak var threatLevelSegController: UISegmentedControl!
    
    @IBOutlet weak var spellDetail: UITextView!
   // @IBOutlet weak var saveSpellButton: UIButton!
    
    
    var spell: Spell?
    var spellController: SpellController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

      //  saveSpellButton.layer.cornerRadius = 25
        updateViews()
    }
    
   
    

    @IBAction func saveSpellButtonTapped(_ sender: Any) {
        if let name = spellName.text,
            let details = spellDetail.text {
            
            //check which segment is selected and create a string constant that holds the corresponding mood
            let index = threatLevelSegController.selectedSegmentIndex
            let threatLevel = ThreatLevel.allCases[index]
            
            if let spell = spell {
                spellController?.updateSpell(spell: spell, name: name, details: details, threatLevel: threatLevel)
            } else {
                spellController?.createSpell(with: name, details: details, threatLevel: threatLevel, context: CoreDataStack.share.mainContext)
            }
            
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    func updateViews(){
        guard isViewLoaded else {return}
        
        title = spell?.name ?? ""
        spellDetail.text = spell?.details
        spellName.text = spell?.name
        
        if let threatString = spell?.threatLevel,
            let threatLevel = ThreatLevel(rawValue: threatString) {
            
            let index = ThreatLevel.allCases.firstIndex(of: threatLevel) ?? 0
            threatLevelSegController.selectedSegmentIndex = index
        }
        
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

//
//  Spell+Convenience .swift
//  iOS13-AH-CoreData-Solution
//
//  Created by Austin Potts on 1/29/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import CoreData

enum ThreatLevel: String, CaseIterable {
    case 🤢
    case 🤕
    case 💀
}

extension Spell {
    
    
    var spellRepresentation: SpellRepresentation? {
        guard let name = name,
        let details = details,
        let threatLevel = threatLevel,
            let identfier = identifier else {return nil}
        
        return SpellRepresentation(name: name, details: details, threatLevel: threatLevel, identfier: identfier)
    }
    
    // Create the convenience initalizer extension for your core data model
    @discardableResult convenience init(name: String, details: String, threatLevel: ThreatLevel, identifier: UUID = UUID(), context: NSManagedObjectContext) {
        
        self.init(context: context)
        
        self.name = name
        self.details = details
        self.threatLevel = threatLevel.rawValue
        self.identifier = identifier
        
    }
    
    @discardableResult convenience init?(spellRepresentation: SpellRepresentation, context: NSManagedObjectContext){
        
        guard let threatLevel = ThreatLevel(rawValue: spellRepresentation.threatLevel) else {return nil}
        
        self.init(name: spellRepresentation.name, details: spellRepresentation.details, threatLevel: threatLevel, identifier: spellRepresentation.identfier, context: context)
        
    }
    
    
    
}

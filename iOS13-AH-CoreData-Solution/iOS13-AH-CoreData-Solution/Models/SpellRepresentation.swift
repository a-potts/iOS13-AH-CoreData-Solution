//
//  SpellRepresentation.swift
//  iOS13-AH-CoreData-Solution
//
//  Created by Austin Potts on 1/29/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation


struct SpellRepresentation: Codable {
    
    let name: String
    let details: String
    let threatLevel: String
    let identfier: UUID
    
    
}

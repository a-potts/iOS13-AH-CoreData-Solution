//
//  SpellController.swift
//  iOS13-AH-CoreData-Solution
//
//  Created by Austin Potts on 1/29/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import CoreData


enum HTTPMethod: String{
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

class SpellController {
    
    
    //Establish baseURL
    let baseURL = URL(string: "https://ios13ah.firebaseio.com/")! //Firebase APi
    
    //Fetch anything from server
    
    func fetchSpellFromServer(completion: @escaping ()-> Void = { } ) {
        
        //Set up the URL
       let requestURL = baseURL.appendingPathExtension("json")
        
        //Set up the request URL
        let request = URLRequest(url: requestURL)
        
        //Perform the data task
        URLSession.shared.dataTask(with: request) {data, _, error in
            
            //Error handling
            if let error = error {
                NSLog("error fetching spells: \(error)")
                completion()
                return
            }
            
            //Make sure we have the data else fail
            guard let data = data else {
                NSLog("Error no data: \(error)")
                completion()
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let spell = try decoder.decode([String: SpellRepresentation].self, from: data).map({$0.value})
                
                //Call update
                self.updateSpell(with: spell)
                
            } catch {
                NSLog("Error decoding spell\(error)")
            }
            
            completion()
            
        }.resume()
        
    }
    
    //Update on server
    func updateSpell(with representations: [SpellRepresentation]){
        
           let identifiersToFetch = representations.map({ $0.identfier})
           
           let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
           
           
           var spellToCreate = representationsByID
           
           //Adding new Background Context
           let context = CoreDataStack.share.container.newBackgroundContext()
           
           context.performAndWait {
               
           
           do {
               
               
               let fetchRequest: NSFetchRequest<Spell> = Spell.fetchRequest()
               //Only fetch the tasks with identifiers that are in this identifersToFetch array
               fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
               
               let exisitingSpell = try context.fetch(fetchRequest)
               
               //Update the ones we have
               for spell in exisitingSpell {
                   
                   // Grab the task representation that corresponds to this task
                   guard let identifier = spell.identifier,
                       let representation = representationsByID[identifier]else { continue }
                   
                  spell.name = representation.name
                  spell.details = representation.details
                   spell.threatLevel = representation.threatLevel
                   
                   //We just updated a Task, we dont need to create a new Task for this identifier
                   spellToCreate.removeValue(forKey: identifier)
               }
               
               //Figure out which We dont have
               for representation in spellToCreate.values {
                   
                   Spell(spellRepresentation: representation, context: context)
                  // Task(taskRepresentation: representation, context: context)
               }
               
               
               
               CoreDataStack.share.save(context: context)
           } catch {
               NSLog("Error fetching tasks from persistence store: \(error)")
               
           }
        }

        
    }
    
    func putSpell(spell: Spell, completion: @escaping ()-> Void = { }){
           
           //Find a unique place to put this task
           let identifier = spell.identifier ?? UUID()
           spell.identifier = identifier
           
           let requestURL = baseURL
               .appendingPathComponent(identifier.uuidString)
               .appendingPathExtension("json")
           
           var request = URLRequest(url: requestURL)
           request.httpMethod = HTTPMethod.put.rawValue
           
           guard let spellRepresentation = spell.spellRepresentation else {
               NSLog("Entry Representation is nil")
               completion()
               return
           }
           
           do {
               request.httpBody = try JSONEncoder().encode(spellRepresentation)
           } catch {
               NSLog("Error encoding entry representation: \(error)")
               completion()
               return
           }
           
           URLSession.shared.dataTask(with: request) { (_, _, error) in
               
               if let error = error {
                   NSLog("Error PUTting task: \(error)")
                   completion()
                   return
               }
               
               completion()
               }.resume()
           
           
           
       }
    
    func deleteSpellFromServer(_ spell: Spell, completion: @escaping()-> Void = {}) {
           
           guard let identifer = spell.identifier else {
               completion()
               return
           }
           
           let requestURL = baseURL.appendingPathComponent(identifer.uuidString).appendingPathExtension("json")
           
           var request = URLRequest(url: requestURL)
           request.httpMethod = HTTPMethod.delete.rawValue
           
           URLSession.shared.dataTask(with: request) { (data, _, error) in
               if let error = error {
                   NSLog("Error deleting Task from server: \(error)")
                   completion()
                   return
               }
               
               completion()
               }.resume()
           
       }
    
    
    //Create the CRUD Methods
    func createSpell(with name: String, details: String, threatLevel: ThreatLevel, context: NSManagedObjectContext) {
        let spell = Spell(name: name, details: details, threatLevel: threatLevel, context: context)
        CoreDataStack.share.save()
        putSpell(spell: spell)
    }
    
    func updateSpell(spell: Spell, name: String, details: String, threatLevel: ThreatLevel){
        spell.name = name
        spell.details = details
        spell.threatLevel = threatLevel.rawValue
        
        CoreDataStack.share.save()
        putSpell(spell: spell)
    }
    
    
    func delete(spell: Spell){
        deleteSpellFromServer(spell)
        CoreDataStack.share.mainContext.delete(spell)
        CoreDataStack.share.save()
    }
    
}

//
//  CoreDataManager.swift
//  banquemisr.challenge05
//
//  Created by  sherouk ahmed  on 28/09/2024.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    
    var context: NSManagedObjectContext!
    var storedMovies: [NSManagedObject]?
    
    static let shared = CoreDataManager()
    
    private init() {
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func setContext(_ context: NSManagedObjectContext) {
        self.context = context
    }
    
    func storeEvent(Event: EventMovie, EnityValue: String) {
        let entity = NSEntityDescription.entity(forEntityName: EnityValue, in: context)
        let movie = NSManagedObject(entity: entity!, insertInto: context)
        
        movie.setValue(Event.id, forKey: "id")
        movie.setValue(Event.backdrop_path, forKey: "backdrop_path")
        movie.setValue(Event.original_language, forKey: "original_language")
        movie.setValue(Event.overview, forKey: "overview")
        movie.setValue(Event.poster_path, forKey: "poster_path")
        movie.setValue(Event.release_date, forKey: "release_date")
        movie.setValue(Event.title, forKey: "title")
        movie.setValue(Event.vote_average, forKey: "vote_average")
    
        do {
            try context.save()
            print("Movie saved successfully!")
        } catch let error {
            print("Failed to save movie!")
            print(error.localizedDescription)
        }
    }
    
    func getEvent(EnityValue: String) -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: EnityValue)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.propertiesToFetch = ["id", "backdrop_path", "original_language", "overview", "poster_path", "release_date", "title", "vote_average"]
        
        do {
            storedMovies = try context.fetch(fetchRequest)
            if storedMovies?.count == 0 {
                print("No data found in Core Data")
            }
        } catch let error {
            print("Failed to fetch data from Core Data")
            print(error.localizedDescription)
        }
        
        return storedMovies ?? []
    }
    
    func deleteAllMovies(EnityValue: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: EnityValue)
        do {
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            for item in result {
                context.delete(item)
            }
            try context.save()
        } catch {
            print(error)
        }
    }
}

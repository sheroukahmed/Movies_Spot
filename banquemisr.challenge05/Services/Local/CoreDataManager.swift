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
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    private var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
    
    func storeEvent(Event: EventMovie, EnityValue: String) {
       
        guard let entity = NSEntityDescription.entity(forEntityName: EnityValue, in: context) else { return }
        let movie = NSManagedObject(entity: entity, insertInto: context)
        
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
    
    func getEvent(EnityValue: String, completion: @escaping ([NSManagedObject]?) -> Void) {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: EnityValue)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.propertiesToFetch = ["id", "backdrop_path", "original_language", "overview", "poster_path", "release_date", "title", "vote_average"]
        
        do {
            let storedMovies = try context.fetch(fetchRequest)
            if storedMovies.isEmpty {
                print("No data found in Core Data")
            }
            completion(storedMovies)
        } catch let error {
            print("Failed to fetch data from Core Data")
            print(error.localizedDescription)
            completion(nil)
        }
        
    }
    
    func deleteAllMovies(EnityValue: String) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: EnityValue)
        do {
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            for item in result {
                context.delete(item)
            }
            try context.save()
            print("All movies deleted successfully.")
        } catch {
            print("Failed to delete movies: \(error.localizedDescription)")
        }
        
    }
}

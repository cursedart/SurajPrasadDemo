//
//  PersistenceController.swift
//  SurajPrasadDemo
//
//  Created by Suraj Prasad on 24/12/25.
//

import Foundation
import CoreData

final class PersistenceStorage {

    static let shared = PersistenceStorage()
    private init() {}

    // MARK: - Persistent Container
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "HoldingDataModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data load error: \(error)")
            }
        }

        // Recommended Core Data settings
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true

        return container
    }()

    // MARK: - Main Context
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    // MARK: - Save
    
    func saveContext() {
        let context = viewContext
        guard context.hasChanges else { return }

        do {
            try context.save()
        } catch {
            debugPrint("Core Data save error:", error.localizedDescription)
        }
    }

    // MARK: - Fetch
    
    func fetch<T: NSManagedObject>(_ type: T.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> [T] {

        let request = NSFetchRequest<T>(entityName: String(describing: type))
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors

        do {
            return try viewContext.fetch(request)
        } catch {
            debugPrint("Fetch error:", error.localizedDescription)
            return []
        }
    }

    // MARK: - Delete All
    
    func deleteAll<T: NSManagedObject>(_ type: T.Type) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(
            entityName: String(describing: type)
        )

        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try viewContext.execute(deleteRequest)
            self.saveContext()
        } catch {
            debugPrint("Batch delete error:", error.localizedDescription)
        }
    }
}

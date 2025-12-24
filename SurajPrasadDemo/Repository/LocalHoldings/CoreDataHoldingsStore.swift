//
//  CoreDataHoldingsStore.swift
//  SurajPrasadDemo
//
//  Created by Mobcoder Technologies Private Limited on 24/12/25.
//

import Foundation
import CoreData

final class CoreDataHoldingsStore: HoldingsLocalDataSource {

    private let persistence = PersistenceStorage.shared

    // MARK: - Save (Background Context)

    func saveHoldings(_ holdings: [Holding]) {

        let context = persistence.persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        context.perform {
            self.clearHoldings(in: context)

            holdings.forEach { holding in
                let entity = HoldingEntity(context: context)
                entity.symbol = holding.symbol
                entity.quantity = Int64(holding.safeQuantity)
                entity.lastTradedPrice = holding.safeLTP
                entity.averagePrice = holding.safeAveragePrice
                entity.closePrice = holding.safeClosePrice
                entity.lastUpdated = Date()
            }

            guard context.hasChanges else { return }
            
            do {
                try context.save()
            } catch {
                debugPrint("Save holdings error:", error.localizedDescription)
            }
        }
    }

    // MARK: - Fetch (Main Context)

    func fetchHoldings() -> [Holding] {

        let context = persistence.viewContext
        let request: NSFetchRequest<HoldingEntity> = HoldingEntity.fetchRequest()

        request.sortDescriptors = [
            NSSortDescriptor(key: "symbol", ascending: true)
        ]

        do {
            return try context.fetch(request).map {
                Holding(
                    symbol: $0.symbol,
                    quantity: Int($0.quantity),
                    lastTradedPrice: $0.lastTradedPrice,
                    averagePrice: $0.averagePrice,
                    closePrice: $0.closePrice
                )
            }
        } catch {
            debugPrint("Fetch holdings error:", error.localizedDescription)
            return []
        }
    }

    // MARK: - Clear (Background Context)

    private func clearHoldings(in context: NSManagedObjectContext) {

        let fetchRequest: NSFetchRequest<NSFetchRequestResult> =
            HoldingEntity.fetchRequest()

        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeObjectIDs

        do {
            let result = try context.execute(deleteRequest) as? NSBatchDeleteResult
            let objectIDs = result?.result as? [NSManagedObjectID] ?? []

            NSManagedObjectContext.mergeChanges(
                fromRemoteContextSave: [NSDeletedObjectsKey: objectIDs],
                into: [persistence.viewContext]
            )
        } catch {
            debugPrint("Clear holdings error:", error.localizedDescription)
        }
    }
    
    func clearHoldings() {

        let persistence = PersistenceStorage.shared
        let backgroundContext = persistence.persistentContainer.newBackgroundContext()

        backgroundContext.perform {

            let fetchRequest: NSFetchRequest<NSFetchRequestResult> =
                HoldingEntity.fetchRequest()

            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            deleteRequest.resultType = .resultTypeObjectIDs

            do {
                let result = try backgroundContext.execute(deleteRequest) as? NSBatchDeleteResult
                let objectIDs = result?.result as? [NSManagedObjectID] ?? []

                // Merge deletion changes into viewContext
                NSManagedObjectContext.mergeChanges(
                    fromRemoteContextSave: [NSDeletedObjectsKey: objectIDs],
                    into: [persistence.viewContext]
                )

            } catch {
                debugPrint("Failed to clear holdings:", error.localizedDescription)
            }
        }
    }
}

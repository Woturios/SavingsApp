//
//  CoreDataManager.swift
//  CashRefill
//
//  Created by Jan Antonowicz on 24/05/2022.
//

import Foundation
import CoreData

class CoreDataManager {
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "ItemsContainer")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core Data Store failed \(error.localizedDescription)")
            }
        }
    }
    
    func getListItems() -> [PostEntity] {
        
        let fetchRequest: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        
        do {
            return try container.viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    func deleteItem(item: PostEntity) {
        container.viewContext.delete(item)
        
        do {
            try container.viewContext.save()
        } catch {
            container.viewContext.rollback()
            print("Failed to save context \(error)")
        }
    }
    
    func updateItem() {
        
        do {
            try container.viewContext.save()
        } catch {
            container.viewContext.rollback()
            print("Failed to update Item \(error)")
        }
    }
    
    func saveItem(title: String, price: Double) {
        
        let item = PostEntity(context: container.viewContext)
        item.name = title
        item.price = price
        
        do {
            try container.viewContext.save()
        } catch {
            print("Failed to save Item \(error)")
        }
        
    }
}
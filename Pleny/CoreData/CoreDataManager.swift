//
//  CoreDataManager.swift
//  Pleny
//
//  Created by Abdalla Elsaman on 16/03/2025.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let container: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    init() {
        container = NSPersistentContainer(name: "PostsContainer")
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Unresolved error \(error.localizedDescription)")
            }
        }
    }
    
    func fetchPostsFromCoreData() -> [Post] {
        let fetchRequest: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        do {
            let coreDataPosts = try viewContext.fetch(fetchRequest)
            return coreDataPosts.map { Post(id: Int($0.id), title: $0.title ?? "", body: $0.body ?? "", views: Int($0.views)) }
        } catch {
            print("Error fetching posts from Core Data: \(error)")
            return []
        }
    }

    func saveContext() {
        let context = viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

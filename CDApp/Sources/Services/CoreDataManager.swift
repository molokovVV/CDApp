//
//  CoreDataManager.swift
//  CDApp
//
//  Created by Виталик Молоков on 12.04.2023.
//

import CoreData

protocol StorageManagerType {
    func savePersonName(_ name: String)
    func deletePerson(person: Person)
    func fetchAllPerson() -> [Person]?
    func updatePerson(_ person: Person,
                      _ image: Data?,
                      _ name: String?,
                      _ dateOfBirth: String?,
                      _ gender: String?)
}

class StorageManager: StorageManagerType {

    // MARK: - Properties

    private let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CDApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    private lazy var context: NSManagedObjectContext = persistentContainer.viewContext

    // MARK: - Functions

    func savePersonName(_ name: String) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Person",
                                                                 in: context) else {return}
        let newPerson = Person(entity: entityDescription,
                               insertInto: context)
        newPerson.name = name
        saveContext()
    }

    func updatePerson(_ person: Person,
                      _ image: Data?,
                      _ name: String?,
                      _ dateOfBirth: String?,
                      _ gender: String?) {

        if let image = image {
            person.image = image
        }
        if let name = name {
            person.name = name
        }
        if let dateOfBirth = dateOfBirth {
            person.dateOfBirth = dateOfBirth.convertToDate()
        }
        if let gender = gender {
            person.gender = gender
        }
        saveContext()
    }

    func fetchAllPerson() -> [Person]? {
        
        do {
            let persons = try context.fetch(fetchRequest) as? [Person]
            return persons
        } catch {
            print(error)
            return nil
        }
    }

    func deletePerson(person: Person) {
        context.delete(person)
        saveContext()
    }

    // MARK: - Delete all data

    func deleteAllData() {
        do {
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject] {
                context.delete(result)
            }
        } catch {
            print(error)
        }
        saveContext()
    }

    // MARK: - Core Data Saving support

    private func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

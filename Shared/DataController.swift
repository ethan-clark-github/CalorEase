import Foundation
import CoreData

class DataController: ObservableObject {
    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "FoodModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Error loading persistent store: \(error.localizedDescription)")
            }
        }
    }

    func save() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                fatalError("Error saving view context: \(error.localizedDescription)")
            }
        }
    }

    func addFood(name: String, calories: Double) {
        let context = container.viewContext
        let food = Food(context: context)
        food.id = UUID()
        food.date = Date()
        food.name = name
        food.calories = calories
        save()
    }

    func editFood(food: Food, name: String, calories: Double) {
        food.date = Date()
        food.name = name
        food.calories = calories
        save()
    }

    func deleteAllFoods() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Food.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try container.viewContext.execute(batchDeleteRequest)
            save()
        } catch {
            fatalError("Error deleting all foods: \(error.localizedDescription)")
        }
    }

    func fetchFoods() -> [Food] {
        let request: NSFetchRequest<Food> = Food.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]

        do {
            return try container.viewContext.fetch(request)
        } catch {
            fatalError("Error fetching foods: \(error.localizedDescription)")
        }
    }
}


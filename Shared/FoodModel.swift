import Foundation
import CoreData

@objc(FoodModel)
public class FoodModel: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID?
    @NSManaged public var name: String
    @NSManaged public var calories: Double
    @NSManaged public var date: Date
}





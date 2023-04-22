import Foundation
import WatchConnectivity

protocol ConnectivityDelegate: AnyObject {
    func didReceiveFoodList(_ foodList: [FoodModel])
}

class ConnectivityViewModel: NSObject, ObservableObject {
    static let shared = ConnectivityViewModel()

    @Published var receivedFoodList: [FoodModel] = []

    public override init() {
        super.init()
    }

    weak var delegate: ConnectivityDelegate?

    private let session: WCSession? = WCSession.default

    func startSession() {
        session?.delegate = self
        session?.activate()
    }

    func sendFoodData(foodList: [FoodModel]) {
        guard let session = session, session.isReachable else { return }

        do {
            let foodData = try JSONEncoder().encode(foodList)
            let message: [String: Any] = ["foodList": foodData]
            session.sendMessage(message, replyHandler: nil, errorHandler: { error in
                print("Error sending food data: \(error)")
            })
        } catch {
            print("Error encoding food data: \(error)")
        }
    }
}

extension ConnectivityViewModel: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activation failed with error: \(error.localizedDescription)")
            return
        }
        print("WCSession activated with state: \(activationState.rawValue)")
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        DispatchQueue.main.async {
            guard let foodData = message["foodList"] as? Data else { return }
            do {
                let foodList = try JSONDecoder().decode([FoodModel].self, from: foodData)
                self.receivedFoodList = foodList
                self.delegate?.didReceiveFoodList(foodList)
            } catch {
                print("Error decoding food data: \(error)")
            }
        }
    }
}

extension FoodModel: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(calories, forKey: .calories)
        try container.encode(date, forKey: .date)
    }
}

extension FoodModel: Decodable {
    public convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        calories = try container.decode(Double.self, forKey: .calories)
        date = try container.decode(Date.self, forKey: .date)
    }
}











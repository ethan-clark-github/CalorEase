import WatchConnectivity

#if os(watchOS)
class ConnectivityViewModelWatchOSDelegate: NSObject, ConnectivityDelegate {
    func didReceiveFoodList(_ foodList: [FoodModel]) {
        // Handle received food list on watchOS
    }
}

extension ConnectivityViewModel: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // Handle session activation completion here
    }

    func sessionReachabilityDidChange(_ session: WCSession) {
        // Handle reachability changes here
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        if let foodData = message["foodList"] as? Data {
            do {
                let receivedFoodModels = try JSONDecoder().decode([FoodModel].self, from: foodData)
                delegate?.didReceiveFoodList(receivedFoodModels)
            } catch {
                print("Error decoding food data: \(error)")
            }
        }
    }
}
#endif





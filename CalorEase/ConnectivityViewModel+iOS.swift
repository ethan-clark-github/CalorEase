import WatchConnectivity

#if os(iOS)
class ConnectivityViewModeliOSDelegate: NSObject, ConnectivityDelegate {
    func didReceiveFoodList(_ foodList: [FoodModel]) {
        // Handle received food list on iOS
    }
}

extension ConnectivityViewModel: WCSessionDelegate {
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("test")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("test")
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // Handle session activation completion here
    }
}
#endif




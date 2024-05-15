import Network

public protocol NetworkMonitor {
    func start()
    func isConnected() -> Bool
}

public class NetworkMonitorImpl: NetworkMonitor {
    private let monitor: NWPathMonitor

    public init(interfaceType: NWInterface.InterfaceType = .wifi) {
        monitor = NWPathMonitor(requiredInterfaceType: interfaceType)
    }

    deinit {
        monitor.cancel()
    }

    public func start() {
        monitor.start(queue: .global(qos: .background))
    }

    public func isConnected() -> Bool {
        return monitor.currentPath.status == .satisfied
    }
}

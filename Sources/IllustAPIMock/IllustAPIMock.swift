import CoreData
import Foundation

public class IllustAPIMock {
    public var networkMonitor: NetworkMonitor = NetworkMonitorImpl()

    private static let databaseName = "Illusts"
    private static let entityName = "IllustEntity"

    private let container: NSPersistentContainer

    public init() {
        let modelURL = Bundle.module.url(forResource: Self.databaseName, withExtension: "momd")!
        let model = NSManagedObjectModel(contentsOf: modelURL)!
        container = NSPersistentContainer(name: Self.databaseName, managedObjectModel: model)
        container.loadPersistentStores { _, _ in }

        setup()

        networkMonitor.start()
    }

    public func getRanking(offset: Int = 0) async throws -> [Illust] {
        // チュートリアルでネットワークエラーを再現できるように
        // 端末がネットワークに繋がってなければエラーを吐くようにする
        guard networkMonitor.isConnected() else {
            throw IllustError.networkError
        }

        let context = container.viewContext
        let request = NSFetchRequest<IllustEntity>(entityName: Self.entityName)
        request.fetchLimit = 4
        request.fetchOffset = offset
        request.sortDescriptors = [NSSortDescriptor(key: "favoritedCount", ascending: false)]
        let result = try context.fetch(request)

        // 実際のネットワークリクエストをしているような体感ができるように1秒待つ
        _ = try await Task.sleep(nanoseconds: 1 * 1_000_000_000)

        return result.map(Illust.init)
    }

    public func getRecommended(offset: Int = 0) async throws -> [Illust] {
        // チュートリアルでネットワークエラーを再現できるように
        // 端末がネットワークに繋がってなければエラーを吐くようにする
        guard networkMonitor.isConnected() else {
            throw IllustError.networkError
        }

        let context = container.viewContext
        let request = NSFetchRequest<IllustEntity>(entityName: Self.entityName)
        request.fetchLimit = 4
        request.fetchOffset = offset
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        let result = try context.fetch(request)

        // 実際のネットワークリクエストをしているような体感ができるように1秒待つ
        _ = try await Task.sleep(nanoseconds: 1 * 1_000_000_000)

        return result.map(Illust.init)
    }

    public func postIsFavorited(illustID: UUID, isFavorited: Bool) async throws -> Illust {
        // チュートリアルでネットワークエラーを再現できるように
        // 端末がネットワークに繋がってなければエラーを吐くようにする
        guard networkMonitor.isConnected() else {
            throw IllustError.networkError
        }

        let context = container.viewContext
        let request = NSFetchRequest<IllustEntity>(entityName: Self.entityName)
        request.predicate = NSPredicate(format: "id = %@", illustID as NSUUID)
        let result = try context.fetch(request)
        guard !result.isEmpty else {
            throw IllustError.notFound
        }

        result[0].isFavorited = isFavorited
        try context.save()

        // 実際のネットワークリクエストをしているような体感ができるように1秒待つ
        _ = try await Task.sleep(nanoseconds: 1 * 1_000_000_000)

        return Illust(entity: result[0])
    }

    public func reset() throws {
        let context = container.viewContext
        let request = NSFetchRequest<IllustEntity>(entityName: Self.entityName)
        let result = try container.viewContext.fetch(request)
        result.forEach { context.delete($0) }
        try context.save()

        setup()
    }

    private func setup() {
        let imageURLs: [String] = [
            "https://firebasestorage.googleapis.com/v0/b/ios-tutorial-375005.appspot.com/o/01.png?alt=media&token=efe5b321-3e4c-4557-b8a2-a28316964c15",
            "https://firebasestorage.googleapis.com/v0/b/ios-tutorial-375005.appspot.com/o/02.png?alt=media&token=569fa657-4a03-4437-b171-cc70a0688dbf",
            "https://firebasestorage.googleapis.com/v0/b/ios-tutorial-375005.appspot.com/o/03.png?alt=media&token=45531e20-c7c9-4046-891c-c4c91fd7134f",
            "https://firebasestorage.googleapis.com/v0/b/ios-tutorial-375005.appspot.com/o/04.png?alt=media&token=798942e9-a96b-4e45-b25a-dc1383041fa6",
            "https://firebasestorage.googleapis.com/v0/b/ios-tutorial-375005.appspot.com/o/05.png?alt=media&token=354e8a3b-2c6f-4206-976d-19f4b14e96ea",
            "https://firebasestorage.googleapis.com/v0/b/ios-tutorial-375005.appspot.com/o/06.png?alt=media&token=d8be90ae-28e3-4971-ada9-5f326c6f68bc",
            "https://firebasestorage.googleapis.com/v0/b/ios-tutorial-375005.appspot.com/o/07.png?alt=media&token=ab593896-34ab-4258-9a49-03a75dfd7a25",
            "https://firebasestorage.googleapis.com/v0/b/ios-tutorial-375005.appspot.com/o/08.png?alt=media&token=1ccb43d3-ef0d-44e4-acfa-ded7570f8baf",
            "https://firebasestorage.googleapis.com/v0/b/ios-tutorial-375005.appspot.com/o/09.png?alt=media&token=df479179-b5d2-4d1d-b8d4-6f7cef262a9c"
        ]

        let context = container.viewContext
        let request = NSFetchRequest<IllustEntity>(entityName: Self.entityName)
        do {
            let result = try context.fetch(request)
            guard result.isEmpty else {
                return
            }

            for urlString in imageURLs {
                let illust = IllustEntity(context: context)
                illust.id = UUID()
                illust.imageURL = URL(string: urlString)
                illust.isFavorited = false
                illust.favoritedCount = 0
                illust.createdAt = Date()
            }

            try context.save()
        } catch {
            print(error)
        }
    }
}

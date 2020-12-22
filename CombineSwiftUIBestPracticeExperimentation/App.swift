
import SwiftUI

fileprivate let persistenceService: PersistenceService = UserDefaultsPersistenceService()
fileprivate let configurationStore: ConfigurationStore = .init(persistenceService)
fileprivate let inputStore: InputStore = .init()

@main
struct CombineSwiftUIBestPracticeExperimentationApp: App {
    var body: some Scene {
        WindowGroup {
            Root()
                .environmentObject(inputStore)
                .environmentObject(configurationStore)
                .onAppear {
                    configurationStore.load()
                    inputStore.load()
                }
        }
    }
}

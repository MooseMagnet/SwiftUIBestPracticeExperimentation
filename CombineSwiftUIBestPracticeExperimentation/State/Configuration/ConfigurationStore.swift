
import Foundation
import Combine

class ConfigurationStore : ObservableObject {
           
    let persistenceService: PersistenceService
    
    @Published private(set) var configuration: Loadable<Configuration> = .notLoaded
    
    private var subs: Set<AnyCancellable> = .init()
    
    init(_ persistenceService: PersistenceService) {
        self.persistenceService = persistenceService
        
        saveConfigurationOnChange()
    }
    
    private func saveConfigurationOnChange() {
        $configuration
            .sink { loadableConfiguration in
                switch loadableConfiguration {
                
                case .loaded(let configuration):
                    self.persistenceService.save(configuration)
                
                default: return
                
                }
            }
            .store(in: &subs)
    }
    
    func load() {
        configuration = .loaded(self.persistenceService.load() ?? .init(preference: 5))
    }
    
    func update(_ new: Configuration) {
        configuration = .loaded(new)
    }
}


import Foundation
import Combine

class ConfigurationStore : ObservableObject {
           
    let persistenceService: PersistenceService
    
    @Published private(set) var configuration: Configuration? = nil
    
    private var subs: Set<AnyCancellable> = .init()
    
    init(_ persistenceService: PersistenceService) {
        self.persistenceService = persistenceService
        
        saveConfigurationOnChange()
    }
    
    private func saveConfigurationOnChange() {
        $configuration
            .sink { [weak self] c in
                if let c = c {
                    self?.persistenceService.save(c)
                }
            }
            .store(in: &subs)
    }
    
    func load() {
        configuration = self.persistenceService.load() ?? .init(preference: 5)
    }
    
    func update(_ new: Configuration) {
        configuration = new
    }
}

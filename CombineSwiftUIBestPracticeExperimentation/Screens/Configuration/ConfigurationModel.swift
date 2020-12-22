
import Combine

class ConfigurationModel : ObservableObject {
    
    private let configurationStore: ConfigurationStore
    
    @Published var preferenceAsText: String
    
    @Published var isValid: Bool = false
    
    init(_ configurationStore: ConfigurationStore) {
        self.configurationStore = configurationStore
        
        switch configurationStore.configuration {
        
        case .loaded(let loadedConfiguration):
            preferenceAsText = "\(loadedConfiguration.preference)"
            
        default:
            preferenceAsText = ""
            
        }
        
        maintainIsValid()
    }
    
    func save() {
        guard isValid else { return }
        configurationStore.update(.init(preference: Int(preferenceAsText)!))
    }
    
    private func maintainIsValid() {
        $preferenceAsText
            .map { v in Int(v) != nil }
            .assign(to: &$isValid)
    }
}

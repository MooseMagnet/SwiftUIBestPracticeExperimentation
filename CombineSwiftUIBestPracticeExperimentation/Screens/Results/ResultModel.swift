
import Combine

class ResultModel : ObservableObject {
    
    private let configurationStore: ConfigurationStore
    private let inputStore: InputStore
    
    @Published private(set) var result: Loadable<Int> = .notLoaded
    
    @Published private(set) var input: [Int] = []
    
    @Published private(set) var preference: Loadable<Int> = .notLoaded
    
    @Published var showConfigurationScreen: Bool = false
    
    private var subs: Set<AnyCancellable> = .init()
    
    init(_ configurationStore: ConfigurationStore, _ inputStore: InputStore) {
        self.configurationStore = configurationStore
        self.inputStore = inputStore
        
        maintainResult()
        maintainInput()
        maintainPreference()
    }
    
    private func maintainResult() {
        Publishers
            .CombineLatest(configurationStore.$configuration, inputStore.$input)
            .map { (config, input) in
                switch (config, input) {
                case (.loaded(let config), .loaded(let input)):
                    return .loaded(input.filter { i in i == config.preference }.count)
                default: return .notLoaded
                }
            }
            .assign(to: &$result)
    }
    
    private func maintainInput() {
        inputStore
            .$input
            .map { loadableInput in
                switch loadableInput {
                case .loaded(let input):
                    return input
                default:
                    return []
                }
            }
            .assign(to: &$input)
    }
    
    private func maintainPreference() {
        configurationStore
            .$configuration
            .map { loadableConfiguration in
                switch loadableConfiguration {
                case .loaded(let configuration):
                    return .loaded(configuration.preference)
                default:
                    return .notLoaded
                }
            }
            .assign(to: &$preference)
    }
    
    func pressedButton() {
        inputStore.add(Int.random(in: 0...10))
    }
    
    func pressedChange() {
        showConfigurationScreen = true
    }
}

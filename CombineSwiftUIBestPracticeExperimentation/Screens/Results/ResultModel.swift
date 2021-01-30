
import Combine

class ResultModel : ObservableObject {
    
    private let configurationStore: ConfigurationStore
    private let inputStore: InputStore
    
    @Published private(set) var result: Int? = nil
    
    @Published private(set) var input: [Int] = []
    
    @Published private(set) var preference: Int? = nil
    
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
                case (.some(let config), .some(let input)):
                    return input.filter { i in i == config.preference }.count
                default: return nil
                }
            }
            .assign(to: &$result)
    }
    
    private func maintainInput() {
        inputStore
            .$input
            .map { i in i ?? [] }
            .assign(to: &$input)
    }
    
    private func maintainPreference() {
        configurationStore
            .$configuration
            .map { c in c?.preference }
            .assign(to: &$preference)
    }
    
    func pressedButton() {
        inputStore.add(Int.random(in: 0...10))
    }
    
    func pressedChange() {
        showConfigurationScreen = true
    }
}


import Combine

class InputStore : ObservableObject {
    
    @Published private(set) var input: Loadable<[Int]> = .notLoaded
    
    func load() {
        input = .loaded([1,2,3])
    }
    
    func add(_ n: Int) {
        switch input {
        
        case .loaded(let existing):
            input = .loaded(existing + [n])
            
        default: return
            
        }
    }
}

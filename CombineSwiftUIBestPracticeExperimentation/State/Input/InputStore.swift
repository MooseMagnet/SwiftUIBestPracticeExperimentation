
import Combine

class InputStore : ObservableObject {
    
    @Published private(set) var input: [Int]? = nil
    
    func load() {
        input = [1,2,3]
    }
    
    func add(_ n: Int) {
        if let existing = input {
            input = existing + [n]
        }
    }
}


import SwiftUI

// Until there's some better way to initialize parameterised @StateObjects,
// we'll encapsulate the dirt around .onAppear

class ModelContainer<T> : ObservableObject {
    
    @Published private(set) var model: T? = nil
    
    func load(_ t: T) {
        model = t
    }
}

struct ViewContainer<Model, Content> : View where Content : View {
    
    @StateObject var modelContainer: ModelContainer<Model> = .init()
    
    private let modelInitializer: () -> Model
    private let content: (Model) -> Content
    
    init(modelInitializer: @escaping () -> Model,
        @ViewBuilder content: @escaping (Model) -> Content) {
        self.content = content
        self.modelInitializer = modelInitializer
    }
    
    @ViewBuilder var body: some View {
        switch modelContainer.model {
        
        case .some(let model):
            content(model)
        
        default:
            // In theory, this should appear for less than a fraction of an instant. :shrug:
            Color.clear
                .onAppear {
                    modelContainer.load(modelInitializer())
                }
        }
    }
}

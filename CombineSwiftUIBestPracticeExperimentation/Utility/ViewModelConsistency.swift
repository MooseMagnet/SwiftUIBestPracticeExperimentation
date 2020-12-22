
import SwiftUI

// Until there's some better way to initialize parameterised @StateObjects,
// we'll encapsulate the dirt around .onAppear

class ModelContainer<T> : ObservableObject {
    
    @Published private(set) var model: Loadable<T> = .notLoaded
    
    func load(_ t: T) {
        model = .loaded(t)
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
    
    var body: some View {
        switch modelContainer.model {
        
        case .loaded(let model):
            return content(model).asAnyView()
        
        default:
            // In theory, this should appear for less than a fraction of an instant. :shrug:
            return VStack {
                EmptyView()
            }
            .onAppear {
                modelContainer.load(modelInitializer())
            }
            .asAnyView()
        }
    }
}


import SwiftUI

struct ResultViewContainer : View {
    
    @EnvironmentObject private var configurationStore: ConfigurationStore
    @EnvironmentObject private var inputStore: InputStore
    
    var body: some View {
        ViewContainer(modelInitializer: { ResultModel(configurationStore, inputStore) }) { r in
            ResultView(resultModel: r)
        }
    }
}

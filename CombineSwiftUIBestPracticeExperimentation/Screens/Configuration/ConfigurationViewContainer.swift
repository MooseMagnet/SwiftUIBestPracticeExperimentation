
import SwiftUI

struct ConfigurationContainerView : View {
    
    @EnvironmentObject private var configurationStore: ConfigurationStore
    
    var body: some View {
        ViewContainer(modelInitializer: { ConfigurationModel(configurationStore) }) { c in
            ConfigurationView(configurationModel: c)
        }
    }
}

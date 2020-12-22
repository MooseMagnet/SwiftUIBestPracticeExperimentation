
import SwiftUI

struct ConfigurationView : View {
    
    @ObservedObject var configurationModel: ConfigurationModel
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Preference")) {
                    TextField("Preference", text: $configurationModel.preferenceAsText)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        configurationModel.save()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Done")
                    }
                    .disabled(!configurationModel.isValid)
                }
            }
            .navigationTitle("Configuration")
        }
    }
}

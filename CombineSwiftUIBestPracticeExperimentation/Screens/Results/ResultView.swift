
import Combine
import SwiftUI

struct ResultView : View {
    
    @ObservedObject var resultModel: ResultModel
    
    var body: some View {
        VStack {
            
            preferenceContent
            
            resultContent
            
            Button(action: resultModel.pressedButton) {
                Text("+ Random Number")
            }
            
            Text("Input")
                .bold()
            
            ScrollView {
                ForEach(resultModel.input, id: \.self) { i in
                    Text("\(i)")
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }
    
    @ViewBuilder private var resultContent: some View {
        switch (resultModel.preference, resultModel.result) {
        
        case (.some(let preference), .some(let result)):
            Text("Result: \(preference) appears \(result) times")
            
        default:
            EmptyView()
            
        }
    }
    
    @ViewBuilder private var preferenceContent: some View {
        switch resultModel.preference {
        
        case .some(let value):
            VStack {
                Text("Preference: \(value)")
                
                Button(action: resultModel.pressedChange) {
                    Text("Change")
                }
                .sheet(isPresented: $resultModel.showConfigurationScreen) {
                    ConfigurationContainerView()
                }
            }
            
        default:
            EmptyView()
            
        }
    }
}

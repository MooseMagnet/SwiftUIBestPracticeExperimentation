
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
    
    private var resultContent: some View {
        switch resultModel.result {
        
        case .loaded(let value):
            return Text("Result: \(value)").asAnyView()
            
        default:
            return EmptyView().asAnyView()
            
        }
    }
    
    private var preferenceContent: some View {
        switch resultModel.preference {
        
        case .loaded(let value):
            return VStack {
                Text("Preference: \(value)").asAnyView()
                Button(action: resultModel.pressedChange) {
                    Text("Change")
                }
                .sheet(isPresented: $resultModel.showConfigurationScreen) {
                    ConfigurationContainerView()
                }
            }
            .asAnyView()
            
        default:
            return EmptyView().asAnyView()
            
        }
    }
}

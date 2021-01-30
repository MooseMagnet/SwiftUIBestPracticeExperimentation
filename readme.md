# What's this?

A sample project demonstrating my current best attempt at clean state management with SwiftUI, _without_ resorting to external packages or verbose Redux-style solutions that are seemingly at odds with the SwiftUI + Combine ethos.

The key player is [`ViewContainer`](https://github.com/MooseMagnet/SwiftUIBestPracticeExperimentation/blob/main/CombineSwiftUIBestPracticeExperimentation/Utility/ViewModelConsistency.swift), which allows you to construct view models using dependencies injected via `@EnvironmentObject` without compromising on the public interface of your view models.

## Example

```swift
import SwiftUI

struct ConfigurationContainerView : View {
    
    @EnvironmentObject private var configurationStore: ConfigurationStore
    
    var body: some View {
        ViewContainer(modelInitializer: { ConfigurationModel(configurationStore) }) { c in
            ConfigurationView(configurationModel: c)
        }
    }
}

struct ConfigurationView : View {
    
    @ObservedObject var configurationModel: ConfigurationModel
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Preference")) {
                    TextField("Preference", text: $configurationModel.preferenceAsText)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: configurationModel.save) {
                        Text("Done")
                    }
                    .disabled(!configurationModel.isValid)
                }
            }
            .navigationTitle("Configuration")
        }
    }
}
```

Because `ConfigurationModel` depends on `ConfigurationStore`, it should be injected as an initializer argument. However, `@StateObject`s require inline initialization\*, and properties injected via `@EnvironmentObject` are not available at that scope.

The workaround would typically be to latently assign the `ConfigurationStore` to the view model, perhaps inside an `.onAppear { ... }` modifier on the view. This not only requires the property to be publicly mutable, but also has implications on internal state management within the view model itself, which then has implications on the view.

None of this is particularly harmful, but it does muddy the proverbial waters and add unnecessary cognitive overhead. The ideal scenario is that the view model must be constructed with all required dependencies and is always in a state where those dependencies are available. As far as I can tell, there is no out-of-the-box solution to this problem.

## What about the StateObject initializer?

Worth noting is that `StateObject` currently has an initializer:

`@inlinable public init(wrappedValue thunk: @autoclosure @escaping () -> ObjectType)`

While it doesn't help with dependencies injected via the environment, it does help with dependencies supplied via the view's initializer. I've seen a lot of people using this to try and solve the problem. It's even the "accepted answer" on a [related StackOverflow question](https://stackoverflow.com/questions/62635914/initialize-stateobject-with-a-parameter-in-swiftui) (though thankfully called out as incorrect in the comments and a subsequent answer). The documentation specifically warns against using this initializer. It appears to be for internal use only within the SDK. As such, there remains no supported solution to this problem.

# Anyway.

Anyway, this is just an idea. It's the best I've come up with so far. That is to say, it's the solution I hate the least. If anyone reading this has a better idea, let me know. I'm ridiculously keen to know about it...
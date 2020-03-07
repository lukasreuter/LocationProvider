# LocationProvider

A simple Swift package to get the current device location by using Combine and ObservableObject

## Usage

```swift

struct ContentView : View {
    @ObservedObject var currentLocation = LocationProvider()
    
    var body: some View {
        VStack {
            Text(currentLocation.location)
            
            Text(currentLocation.occasionalLocation)
        }
    }
}

```

import Foundation
import Combine
import CoreLocation
import os

public class LocationProvider: NSObject, ObservableObject, CLLocationManagerDelegate
{
    public var objectWillChange = PassthroughSubject<CLLocation, Never>()

    @Published public var location: CLLocation = CLLocation() {
        didSet {
            objectWillChange.send(location)
        }
    }

    @Published public var occasionalLocation: CLLocation = CLLocation()

    private var occasionalLocationCancellable: Cancellable? {
        didSet {
            oldValue?.cancel()
        }
    }

    private let locationManager: CLLocationManager

    public override init() {
        locationManager = CLLocationManager()
        super.init()

        locationManager.delegate = self
        setup()
    }

    deinit {
        locationManager.stopUpdatingLocation()
        occasionalLocationCancellable?.cancel()
    }

    private func setup() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        occasionalLocationCancellable = self.objectWillChange
                                                .throttle(for: .seconds( 5 ), scheduler: DispatchQueue.main, latest: true)
                                                .assign(to: \.occasionalLocation, on: self)
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.last!
        self.location = currentLocation
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationProvider: location failed with \(error)")
    }
}

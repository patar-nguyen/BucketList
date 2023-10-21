//
//  ContentView.swift
//  BucketList
//
//  Created by Patrick Nguyen on 2023-09-27.
//

import SwiftUI
import MapKit
import LocalAuthentication

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        if viewModel.isUnlocked {
            ZStack {
                Map(coordinateRegion: $viewModel.mapRegion, annotationItems: viewModel.locations) { location in
                    MapAnnotation(coordinate: location.coordinate) {
                        VStack {
                            Image(systemName: "star.circle")
                                .resizable()
                                .foregroundColor(.red)
                                .frame(width: 44, height: 44)
                                .backgroundStyle(.white)
                                .clipShape(Circle())
                            Text(location.name)
                                .fixedSize()
                        }
                        .onTapGesture {
                            viewModel.selectedPlace = location
                        }
                    }
                }
                .ignoresSafeArea()
                
                Circle()
                    .fill(.blue)
                    .opacity(0.3)
                    .frame(width: 32, height: 32)
                
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            viewModel.addLocation()
                        } label: {
                            Image(systemName: "plus")
                        }
                        .padding()
                        .background(.black.opacity(0.75))
                        .foregroundColor(.white)
                        .font(.title)
                        .clipShape(Circle())
                        .padding(.trailing)
                    }
                }
            }
            .sheet(item: $viewModel.selectedPlace) { place in
                EditView(location: place) { newLocation in
                    viewModel.update(location: newLocation)
                }
            }
        } else {
            Button("Unlock") {
                viewModel.authenticate()
            }
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
        }
    }
}

//USING TOUCH AND FACE ID
//struct ContentView: View {
//    @State private var isUnlocked = false
//
//    var body: some View {
//        VStack {
//            if isUnlocked {
//                Text("Unlocked")
//            } else {
//                Text("Locked")
//            }
//        }
//        .onAppear(perform: authenticate)
//    }
//
//    func authenticate() {
//        let context = LAContext()
//        var error: NSError?
//
//        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
//            let reason = "We need to unlock your data"
//
//            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
//                if success {
//                    isUnlocked = true
//                } else {
//                    // problem
//                }
//            }
//        } else {
//            // no biometrics
//        }
//    }
//}

//INTEGRATING MAPKIT
//struct Location: Identifiable {
//    let id = UUID()
//    let name: String
//    let coordinate: CLLocationCoordinate2D
//}
//struct ContentView: View {
//    //span is zoom level
//    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.5, longitude: -0.12), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
//
//    let locations = [
//        Location(name: "Buckingham Palace", coordinate: CLLocationCoordinate2D(latitude: 51.501, longitude: -0.141)),
//        Location(name: "Tower of London", coordinate: CLLocationCoordinate2D(latitude: 51.508, longitude: -0.076))
//    ]
//
//    var body: some View {
//        NavigationView {
//            Map(coordinateRegion: $mapRegion, annotationItems: locations) { location in
//                MapAnnotation(coordinate: location.coordinate) {
//                    //this just makes the marker
//                    //MapMarker(coordinate: location.coordinate)
//                    NavigationLink {
//                        Text(location.name)
//                    } label: {
//                        Circle()
//                            .stroke(.red, lineWidth: 3)
//                            .frame(width: 44, height: 44)
//                    }
//                }
//            }
//            .navigationTitle("London explorer")
//        }
//    }
//}

//SWITCHING VIEW STATES WITH ENUM
//enum LoadingState {
//    case loading, success, failed
//}
//
//struct LoadingView: View {
//    var body: some View {
//        Text("Loading")
//    }
//}
//
//struct SuccessView: View {
//    var body: some View {
//        Text("Success")
//    }
//}
//
//struct FailedView: View {
//    var body: some View {
//        Text("Failed")
//    }
//}
//
//struct ContentView: View {
//    var loadingState = LoadingState.loading
//
//    var body: some View {
//        switch loadingState {
//        case .loading:
//            LoadingView()
//        case .success:
//            SuccessView()
//        case .failed:
//            FailedView()
//        }
//        if loadingState == .loading {
//            LoadingView()
//        } else if loadingState == .success {
//            SuccessView()
//        } else if loadingState == .failed {
//            FailedView()
//        }
//    }
//}

//WRITING DATA TO THE DOCUMENTS DIRECTORY
//struct ContentView: View {
//    var body: some View {
//        Text("Hi")
//            .onTapGesture {
//                let str = "Test Message"
//                let url = getDocumentsDirectory().appendingPathExtension("message.txt")
//
//                do {
//                    try str.write(to: url, atomically: true, encoding: .utf8)
//
//                    let input = try String(contentsOf: url)
//                    print(input)
//                } catch {
//                    print(error.localizedDescription)
//                }
//            }
//    }
//
//    func getDocumentsDirectory() -> URL {
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        return paths[0]
//    }
//}

//ADDING CONFORMANCE TO COMPARABLE
//struct User: Identifiable, Comparable {
//    let id = UUID()
//    let firstName: String
//    let lastName: String
//
//    static func <(lhs: User, rhs: User) -> Bool {
//        lhs.lastName < rhs.lastName
//    }
//}
//
//struct ContentView: View {
//    let users = [
//        User(firstName: "Patrick", lastName: "Nguyen"),
//        User(firstName: "Patrick", lastName: "Dooyen"),
//        User(firstName: "Patrick", lastName: "Zooyen")
//    ].sorted()
//
//    var body: some View {
//        List(users) { user in
//            Text("\(user.firstName) \(user.lastName)")
//        }
//    }
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

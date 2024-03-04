//
//  MaptView.swift
//  pilgrimage_app
//
//  Created by 阿部和貴 on 2024/02/16.
//

import MapKit
import SwiftUI

extension CLLocationCoordinate2D {
    static let spot = CLLocationCoordinate2D(latitude: 35.6092, longitude: 137.7303)
    static let spot2 = CLLocationCoordinate2D(latitude: 34.8092, longitude: 137.4303)
}

struct MaptView: View {
    @ObservedObject var viewModel = SanctuaryListViewModel()
    @State private var searchText: String = ""

    // マップ上の円の位置
    @State private var mapCircleLocation: CLLocationCoordinate2D = .spot2
    var body: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                MapReader { mapProxy in
                    Map {
                        ForEach(viewModel.sanctuaries) { sanctuary in
                            Marker(sanctuary.name,
                                   coordinate: sanctuary.coordinate)
                                .tint(sanctuary.color)
                        }
                        
                        MapCircle(center: viewModel.sanctuaries.first?.coordinate ?? .spot,
                                  radius: 50000)
                        .foregroundStyle(.blue.opacity(0.0))
                    }
                    .ignoresSafeArea()
                    .onTapGesture { location in
                        guard let selectedLocation = mapProxy.convert(location, from: .local) else { return }
                        mapCircleLocation = selectedLocation
                    }
                }

                VStack {
                    TextField("Search", text:  $searchText)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .padding(.horizontal)
                        .padding(.top, 10)
                    Button("Open Google Maps") {
                        // Google Mapsに遷移する処理を実装
                        if let url = URL(string: "comgooglemaps://?center=35.6092,139.7303") {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                        
                    }
                    .buttonStyle(RoundedButtonStyle())
                }
            }
        }.onAppear(){
            viewModel.fetchData()
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}

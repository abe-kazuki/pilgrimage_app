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
    @Environment(\.modelContext) private var modelContext
    @ObservedObject private var viewModel = SanctuaryListViewModel()
    @State private var isListVisible = true

    // マップ上の円の位置
    @State private var mapCircleLocation: CLLocationCoordinate2D = .spot2
    var body: some View {
        VStack {
            ZStack(alignment: .topLeading) {
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
                        mapCircleLocation = viewModel.sanctuaries.first?.coordinate ?? .spot
                    }
                }

                VStack {
                    TextField("Search", text:  $viewModel.searchText)
                        .padding()
                        .background(Color.white)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .onTapGesture {
                            self.isListVisible = true
                        }
                    if isListVisible {
                        List(viewModel.sanctuaries) { sanctuary in
                            Text(sanctuary.title)
                                .onTapGesture {
                                    viewModel.searchText = sanctuary.title
                                    self.isListVisible = true
                                }
                        }
                        .listStyle(PlainListStyle())
                        .padding(.horizontal)
                    }
                }
                .gesture(
                    TapGesture()
                        .onEnded { _ in
                            self.isListVisible = false
                        }
                )
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

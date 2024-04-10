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
}


struct MaptView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject private var viewModel = SanctuaryListViewModel()
    @FocusState var isFocused: Bool

    // マップ上の円の位置
    @State private var mapCircleLocation: CLLocationCoordinate2D = .spot
    var body: some View {
        VStack {
            ZStack(alignment: .topLeading) {
                MapReader { mapProxy in
                    Map {
                        ForEach(viewModel.sanctuaries) { sanctuary in
                            Annotation(sanctuary.id.description, coordinate: sanctuary.coordinate) {
                                  VStack {
                                      // ここはアイコン考える
                                      Text(sanctuary.name)
                                          .foregroundColor(.black)
                                          .dynamicTypeSize(.small)
                                      Circle()
                                        .fill(sanctuary.color)
                                        .frame(width: 15, height: 15)
                                      if viewModel.isOnlyContent {
                                          ContentInfoWindow(content: sanctuary.title, url: sanctuary.googleMapsURL())
                                      }
                                  }
                            }
                        }
                        
                        MapCircle(center: viewModel.sanctuaries.first?.coordinate ?? .spot,
                                  radius: 50000)
                        .foregroundStyle(.blue.opacity(0.0))
                        
                    }
                    .onTapGesture { location in
                        guard mapProxy.convert(location, from: .local) != nil else { return }
                    }
                }

                VStack {
                    TextField("Search", text:  $viewModel.searchText)
                        .padding()
                        .background(Color.white)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .focused($isFocused)
                    if isFocused {
                        List(viewModel.sanctuaries) { sanctuary in
                            Text(sanctuary.title)
                                .onTapGesture {
                                    viewModel.searchText = sanctuary.title
                                }
                        }
                        .listStyle(PlainListStyle())
                        .padding(.horizontal)
                    }
                }
                .gesture(
                    TapGesture()
                        .onEnded { _ in
                            self.isFocused = false
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

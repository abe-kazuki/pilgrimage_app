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
    @FocusState var isFocused: Bool

    // マップ上の円の位置
    @State private var mapCircleLocation: CLLocationCoordinate2D = .spot2
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
                                      SpeechBubble(content: sanctuary.title, url: sanctuary.googleMapsURL())
                                  }
                            }
                        }
                        
                        MapCircle(center: viewModel.sanctuaries.first?.coordinate ?? .spot,
                                  radius: 50000)
                        .foregroundStyle(.blue.opacity(0.0))
                        
                    }
                    .onTapGesture { location in
                        guard mapProxy.convert(location, from: .local) != nil else { return }
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

struct SpeechBubble: View {
    let content: String
    let url: URL
    
    var body: some View {
        HStack(spacing: 1) {
            Text(content)
                .foregroundColor(.black)
                .cornerRadius(5)
            Button(action: {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }) {
                Image(systemName: "map")
                .foregroundColor(.blue)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 4)
            }
            .padding(5)
            
        }
        .padding(2)
        .background(Color.white)
        .cornerRadius(10)
        .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}

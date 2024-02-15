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

// アノテーションデータモデル
struct AnnotationItem: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let name: String
    let color: Color
    
    init(coordinate: CLLocationCoordinate2D = .spot,
         name : String,
         color: Color = .orange
    ) {
        self.coordinate = coordinate
        self.name = name
        self.color = color
    }
}

struct MaptView: View {
    @State private var searchText: String = ""
    private let annotationItem: [AnnotationItem] = [
        AnnotationItem(name: "test1"),
        AnnotationItem(coordinate: .spot2, name: "test2")]

    // マップ上の円の位置
    @State private var mapCircleLocation: CLLocationCoordinate2D = .spot2
    var body: some View {
        
        VStack {
            ZStack(alignment: .top) {
                MapReader { mapProxy in
                    Map {
                        ForEach(annotationItem) { location in
                            Marker(location.name, coordinate: location.coordinate)
                                .tint(location.color)
                        }
                        
                        MapCircle(center: .spot2, radius: 50000)
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
                        
                    }.frame(alignment: .bottomTrailing)
                        .buttonStyle(RoundedButtonStyle())
                }
            }

        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}

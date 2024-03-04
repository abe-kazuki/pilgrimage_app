//
//  SanctuaryViewModel.swift
//  pilgrimage_app
//
//  Created by 阿部和貴 on 2024/03/04.
//

import SwiftUI
import Firebase
import MapKit

class SanctuaryListViewModel: ObservableObject {
    @Published var sanctuaries: [AnnotationSanctuary] = []
    private var db = Firestore.firestore()
    
    struct AnnotationSanctuary: Identifiable {
        let id = UUID()
        let coordinate: CLLocationCoordinate2D
        let name: String
        let color: Color
        
        init(latitude: Double,
             longitude: Double,
             name: String,
             color: Color = .orange
        ) {
            self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            self.name = name
            self.color = color
        }
    }
    
    func fetchData() {
        db.collection("sancutualy").addSnapshotListener { querySnapshot, error in
            if let error = error {
                // エラーが発生した場合の処理
                print("エラーが発生しました: \(error.localizedDescription)")
                return
            }
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.sanctuaries = documents.compactMap { document in
                try? document.data(as: Sanctuary.self)
            }.map{ sanctuary in
                AnnotationSanctuary(
                    latitude: sanctuary.latitude, longitude: sanctuary.longitude, name: sanctuary.name
                )
            }
        }
    }
}


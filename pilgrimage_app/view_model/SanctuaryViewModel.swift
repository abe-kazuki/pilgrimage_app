//
//  SanctuaryViewModel.swift
//  pilgrimage_app
//
//  Created by 阿部和貴 on 2024/03/04.
//

import SwiftUI
import MapKit
import Combine

class SanctuaryListViewModel: ObservableObject {
    @Published var sanctuaries: [AnnotationSanctuary] = []
    @ObservationIgnored private let reposity: SanctuaryRepository
    private var cancellables = [AnyCancellable]()
    
    init(reposity: SanctuaryRepository = SanctuaryRepository.shared) {
        self.reposity = reposity
    }
    
    
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
        
        reposity.fetchData()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                print("Data fetching completed!")
            case .failure(let error):
                print("Error fetching data: \(error)")
            }
        }, receiveValue: { contents in
            // データの取得が完了し、Firestoreから取得したデータ(contents)がここで利用可能
            print("Fetched contents:", contents)
            // ViewModelで受け取る処理を行う
            let results : [AnnotationSanctuary] = contents.flatMap{ content in
                content.sancutualies.compactMap { sancutualy in
                    return AnnotationSanctuary(latitude: sancutualy.latitude, longitude: sancutualy.longitude, name: sancutualy.name)
                }
            }
            self.sanctuaries = results
        }).store(in: &cancellables)
    }
}


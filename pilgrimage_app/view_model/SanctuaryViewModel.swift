//
//  SanctuaryViewModel.swift
//  pilgrimage_app
//
//  Created by 阿部和貴 on 2024/03/04.
//

import SwiftUI
import MapKit
import Combine


struct AnnotationSanctuary: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let name: String
    let color: Color
    let title: String
    
    init(latitude: Double,
         longitude: Double,
         name: String,
         title: String,
         color: Color = .orange
    ) {
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.name = name
        self.title = title
        self.color = color
    }
    
    func googleMapsURL() -> URL {
        let urlString = "https://www.google.com/maps/search/?api=1&query=\(coordinate.latitude),\(coordinate.longitude)&query_place_id=\(self.title)"
        return URL(string: urlString) ?? URL.applicationDirectory
    }
}

class SanctuaryListViewModel: ObservableObject {
    @Published var sanctuaries: [AnnotationSanctuary] = [] {
        didSet {
            self.uniqueTitles = Array(Set(sanctuaries.map { $0.title })).sorted()
        }
    }
    @Published var searchText: String = "" {
        didSet {
            search()
        }
    }
    @Published var isOnlyContent: Bool = false
    @ObservationIgnored private let reposity: SanctuaryRepository
    private var cancellables = [AnyCancellable]()
    
    @Published var uniqueTitles: [String] = []
    
    init(reposity: SanctuaryRepository = SanctuaryRepository.shared) {
        self.reposity = reposity
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
            self.monitoredUpdate(contents: contents)
        }).store(in: &cancellables)
    }
    
    func search() {
        print(self.searchText)
        reposity.getData(text: self.searchText)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                print("Data fetching completed!")
            case .failure(let error):
                print("Error fetching data: \(error)")
            }
        }, receiveValue: { contents in
            self.monitoredUpdate(contents: contents)
        }).store(in: &cancellables)
    }
    
    private func monitoredUpdate(contents: [ContentModel]) {
        // データの取得が完了し、Firestoreから取得したデータ(contents)がここで利用可能
        let results : [AnnotationSanctuary] = contents.flatMap { content in
            return content.sancutualies.map{ sancutualy in
                sancutualy.convertoToSateDate(title: content.title)
            }
        }
        self.isOnlyContent = contents.count == 1
        self.sanctuaries = results
    }
}


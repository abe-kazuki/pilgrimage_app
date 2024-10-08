//
//  TopViewModel.swift
//  pilgrimage_app
//
//  Created by 阿部和貴 on 2024/08/09.
//

import SwiftUI
import Combine
import MapKit

struct SanctuaryWithPhoto: Identifiable {
    let id = UUID()
    let name: String
    let title: String
    let coordinate: CLLocationCoordinate2D
    
    init(name: String,
         title: String,
         latitude: Double,
         longitude: Double
    ) {
        self.name = name
        self.title = title
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

class TopViewModel: ObservableObject {
    @ObservationIgnored private let sanctuaryReposity: SanctuaryRepository
    @ObservationIgnored private let eventRepository: EventRepository
    private var cancellables = [AnyCancellable]()
    
    @Published var sanctuaryWithPhotos: [SanctuaryWithPhoto] = []
    @Published var events: [Event] = []
    @Published var images: [String: UIImage] = [:] // URLごとに画像を保持
    @Published var lookAroundScenes: [String: MKLookAroundScene] = [:]
    
    init(sanctuaryReposity: SanctuaryRepository = SanctuaryRepository.shared
    ) {
        self.sanctuaryReposity = sanctuaryReposity
        self.eventRepository = EventRepository.shared
    }
    
    func fetchData() {
        sanctuaryReposity.fetchData()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Data fetching completed!")
                case .failure(let error):
                    print("Error fetching data: \(error)")
                }
            }, receiveValue: { contents in
                self.setSanctuaryWithPhotos(contents: contents)
            })
            .store(in: &cancellables)
    }
    
    // TODO: データ取得なのでdata層が適切
    func requestLookAroundScene(coordinate: CLLocationCoordinate2D, sanctuaryName: String) {
        let request = MKLookAroundSceneRequest(coordinate: coordinate)
        Task {
            try? await request.scene.publisher
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("image fetching completed!")
                    case .failure(let error):
                        print("Error fetching image: \(error)")
                    }
                }, receiveValue: { [weak self] scene in
                    guard let self = self else { return }
                    self.lookAroundScenes[sanctuaryName] = scene
                })
                .store(in: &cancellables)
        }
    }
    
    func fetchEnent() {
        eventRepository.fetchData()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Data fetching completed!")
                case .failure(let error):
                    print("Error fetching data: \(error)")
                }
            }, receiveValue: { events in
                self.events = events
                self.events.forEach{event in
                    self.image(title: event.title, path: event.image_path)
                }
            })
            .store(in: &cancellables)
    }
    
    func image(title: String, path: String) {
        eventRepository.downloadImagre(from: path) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let downloadedImage):
                    self.images[title] = downloadedImage
                case .failure(let error):
                    print("Error fetching data: \(error)")
                }
            }
        }
    }

    private func setSanctuaryWithPhotos(contents: [ContentModel]) {
        self.sanctuaryWithPhotos = contents.flatMap { content in
            return content.sancutualies.map{ sancutualy in
                let data = SanctuaryWithPhoto(name: sancutualy.name, title: content.title, latitude: sancutualy.latitude, longitude: sancutualy.longitude)
                if self.lookAroundScenes[data.name] == nil {
                    requestLookAroundScene(coordinate: data.coordinate, sanctuaryName: data.name)
                }
                return data
            }
        }
    }
}

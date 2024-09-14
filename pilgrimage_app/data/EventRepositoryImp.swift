//
//  EvetRepositoryImp.swift
//  pilgrimage_app
//
//  Created by 阿部和貴 on 2024/09/14.
//

import Firebase
import FirebaseStorage
import SwiftData
import Combine


final class EventRepository {
    private let firebase = Firestore.firestore()
    private let storage = Storage.storage()
    
    //private let modelContainer: ModelContainer
    //private let modelContext: ModelContext

    @MainActor
    static let shared = EventRepository()
    
    @MainActor
    private init() {
        //self.modelContainer = try! ModelContainer(for: ContentModel.self, SancutualyModel.self)
        //self.modelContext = modelContainer.mainContext
    }
    
    func fetchData() -> AnyPublisher<[Event], Error> {
        do {
            return Future<[Event], Error> { promise in
                do {
                    var events: [Event] = []
                    self.firebase.collection("events").addSnapshotListener { querySnapshot, error in
                        if let error = error {
                            // エラーが発生した場合の処理
                            print("エラーが発生しました: \(error.localizedDescription)")
                            return
                        }
                        guard let documents = querySnapshot?.documents else {
                            print("No documents")
                            return
                        }
                        events = documents.compactMap { document in
                            try? document.data(as: Event.self)
                        }
                        promise(.success(events))
                    }
                } catch {
                    promise(.failure(error))
                }
            }
            .eraseToAnyPublisher()
            
        } catch {
            return Future<[Event], Error> { promise in
                promise(.failure(error))
            }.eraseToAnyPublisher()
        }
    }
    
    func downloadImagre(from url: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let storageRef = storage.reference(forURL: url)
        
        storageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                completion(.success(image))
            } else {
                completion(.failure(NSError(domain: "Image data invalid", code: -1, userInfo: nil)))
            }
        }
    }
}

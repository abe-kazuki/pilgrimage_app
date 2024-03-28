//
//  SanctuaryRepositoryImp.swift
//  pilgrimage_app
//
//  Created by 阿部和貴 on 2024/03/14.
//

import Firebase
import SwiftData
import Combine


final class SanctuaryRepository {
    private let updateLimit: Double = -3660
    private var firebase = Firestore.firestore()
    
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext

    @MainActor
    static let shared = SanctuaryRepository()
    
    @MainActor
    private init() {
        self.modelContainer = try! ModelContainer(for: ContentModel.self, SancutualyModel.self)
        self.modelContext = modelContainer.mainContext
    }
    
    func fetchData() -> AnyPublisher<[ContentModel], Error> {
        do {
            let contents: [ContentModel] = try self.modelContext.fetch(FetchDescriptor<ContentModel>())
            // falseならretrunする
            guard (contents.last?.createdDate.timeIntervalSinceNow ?? updateLimit - 1) <= updateLimit else {
                return Future<[ContentModel], Error> { promise in
                    promise(.success(contents))
                }.eraseToAnyPublisher()
            }
            return Future<[ContentModel], Error> { promise in
                self._fetchFreshData { _ in
                    do {
                        let contents: [ContentModel] = try self.modelContext.fetch(FetchDescriptor<ContentModel>())
                        promise(.success(contents))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
            .eraseToAnyPublisher()
            
        } catch {
            return Future<[ContentModel], Error> { promise in
                promise(.failure(error))
            }.eraseToAnyPublisher()
        }
    }
    
    func getData(text: String) -> AnyPublisher<[ContentModel], Error> {
        let predicate = #Predicate<ContentModel> { content in            content.title.contains(text)
        }
        let descriptor = FetchDescriptor(predicate: predicate)
        return Future<[ContentModel], Error> { promise in
            do {
                let contents: [ContentModel] = try self.modelContext.fetch(descriptor)
                promise(.success(contents))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func _fetchFreshData(completion: @escaping (Result<Void, Error>) -> Void) {
        var sancutuaries: [Sanctuary] = []
        var contents: [Content] = []
        firebase.collection("contents").addSnapshotListener { querySnapshot, error in
            if let error = error {
                // エラーが発生した場合の処理
                print("エラーが発生しました: \(error.localizedDescription)")
                return
            }
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            contents = documents.compactMap { document in
                try? document.data(as: Content.self)
            }
            
            self.firebase.collection("sancutualy").addSnapshotListener { querySnapshot, error in
                if let error = error {
                    // エラーが発生した場合の処理
                    print("エラーが発生しました: \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    completion(.failure(NSError()))
                    return
                }
                
                sancutuaries = documents.compactMap { document in
                    try? document.data(as: Sanctuary.self)
                }
                do {
                    try self.modelContext.transaction {
                        contents.forEach{ content in
                            let targetSancutuaries = sancutuaries.filter{ sancutuary in
                                content.sancutualyDocumentIds.contains(sancutuary.id ?? "")
                            }.map{ entity in
                                SancutualyModel(id: entity.id ?? "", name: entity.name, latitude: entity.latitude, longitude: entity.longitude)
                            }
                            let model = ContentModel(id: content.id, title: content.title, sancutualies: targetSancutuaries)
                            self.modelContext.insert(model)
                        }
                    }
                } catch {
                    fatalError(error.localizedDescription)
                }
                completion(.success(()))
            }
        }
    }
}

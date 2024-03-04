//
//  userListViewModel.swift
//  pilgrimage_app
//
//  Created by 阿部和貴 on 2024/03/04.
//

import SwiftUI
import Firebase


class ItemListViewModel: ObservableObject {
    @Published var users: [User] = []
    private var db = Firestore.firestore()
    
    func fetchData() {
        db.collection("contents").addSnapshotListener { querySnapshot, error in
            if let error = error {
                // エラーが発生した場合の処理
                print("エラーが発生しました: \(error.localizedDescription)")
                return
            }
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.users = documents.compactMap { document in
                try? document.data(as: User.self)
            }
            print(self.users)
        }
    }
}

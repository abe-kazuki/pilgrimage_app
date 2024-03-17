//
//  Content.swift
//  pilgrimage_app
//
//  Created by 阿部和貴 on 2024/03/14.
//

import FirebaseFirestoreSwift

struct Content: Identifiable, Codable  {
    @DocumentID var id: String?
    var title: String
    var sancutualyDocumentIds: [String]
}

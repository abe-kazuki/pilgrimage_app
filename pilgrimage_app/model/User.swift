//
//  users.swift
//  pilgrimage_app
//
//  Created by 阿部和貴 on 2024/03/04.
//

import FirebaseFirestoreSwift // 必要

struct User: Identifiable, Codable  {
    @DocumentID var id: String?
    var born: Int
    var first: String
    var last: String
}

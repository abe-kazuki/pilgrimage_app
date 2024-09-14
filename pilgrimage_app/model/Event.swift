//
//  Event.swift
//  pilgrimage_app
//
//  Created by 阿部和貴 on 2024/09/14.
//

import FirebaseFirestoreSwift
import Foundation

struct Event: Identifiable, Codable  {
    @DocumentID var id: String?
    var title: String
    var day: String
    var image_path: String
    var contents_id: String
}

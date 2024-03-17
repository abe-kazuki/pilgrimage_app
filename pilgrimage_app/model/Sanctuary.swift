//
//  sanctuary.swift
//  pilgrimage_app
//
//  Created by 阿部和貴 on 2024/03/04.
//

import FirebaseFirestoreSwift
import SwiftData


@Model
class SancutualyModel {
    @Attribute(.unique) let id: String?
    let name: String
    let latitude: Double
    let longitude: Double
    var parent: ContentModel?
    
    init(id: String,name: String, latitude: Double, longitude: Double) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}


@Model
class ContentModel {
    @Attribute(.unique) let id: String?
    var title: String
    @Relationship(inverse: \SancutualyModel.parent)
    var sancutualies: [SancutualyModel]
    
    init(id: String?, title: String, sancutualies: [SancutualyModel]) {
        self.id = id
        self.title = title
        self.sancutualies = sancutualies
    }
}

struct Sanctuary: Identifiable, Codable  {
    @DocumentID var id: String?
    var name: String
    var latitude: Double
    var longitude: Double
}



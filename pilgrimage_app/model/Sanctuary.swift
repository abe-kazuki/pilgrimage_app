//
//  sanctuary.swift
//  pilgrimage_app
//
//  Created by 阿部和貴 on 2024/03/04.
//

import FirebaseFirestoreSwift
import SwiftData
import Foundation


@Model
class SancutualyModel {
    @Attribute(.unique) let id: String?
    let name: String
    let latitude: Double
    let longitude: Double
    @Relationship(inverse: \ContentModel.sancutualies)
    let content: ContentModel?
    
    init(id: String,name: String, latitude: Double, longitude: Double) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func convertoToSateDate(title: String)  -> AnnotationSanctuary {
        AnnotationSanctuary(latitude: latitude,
                                                   longitude: longitude,
                                                   name: name,
                                                   title: title)
    }
}


@Model
class ContentModel {
    @Attribute(.unique) let id: String?
    var title: String
    var createdDate: Date
    @Relationship
    var sancutualies: [SancutualyModel]
    
    init(id: String?, title: String, sancutualies: [SancutualyModel]) {
        self.id = id
        self.title = title
        self.sancutualies = sancutualies
        self.createdDate = Date.now
    }
}

struct Sanctuary: Identifiable, Codable  {
    @DocumentID var id: String?
    var name: String
    var latitude: Double
    var longitude: Double
}



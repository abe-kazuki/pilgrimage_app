//
//  sanctuary.swift
//  pilgrimage_app
//
//  Created by 阿部和貴 on 2024/03/04.
//

import FirebaseFirestoreSwift
import MapKit

struct Sanctuary: Identifiable, Codable  {
    @DocumentID var id: String?
    var name: String
    var latitude: Double
    var longitude: Double
}



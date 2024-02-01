//
//  Item.swift
//  pilgrimage_app
//
//  Created by 阿部和貴 on 2024/02/02.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

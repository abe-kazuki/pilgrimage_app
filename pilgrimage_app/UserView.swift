//
//  UserView.swift
//  pilgrimage_app
//
//  Created by 阿部和貴 on 2024/03/04.
//

import SwiftUI

struct UserView: View {
    @ObservedObject var viewModel = SanctuaryListViewModel()
    
    var body: some View {
        List(viewModel.sanctuaries) { sanctuary in
            HStack {
                Text(sanctuary.name)
                    .foregroundColor(.green)
                Text(sanctuary.coordinate.latitude.description)
                    .foregroundColor(.green)
                Text(sanctuary.coordinate.longitude.description)
                    .foregroundColor(.green)
            }
        }
    }    
}

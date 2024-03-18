//
//  SuggestListView.swift
//  pilgrimage_app
//
//  Created by 阿部和貴 on 2024/03/17.
//

import SwiftUI

struct SuggestListView: View {
    var body: some View {
        List(viewModel.sanctuaries) { sanctuary in
            Text(sanctuary.title)
        }
        .listStyle(PlainListStyle())
        .padding(.horizontal)
    }
}

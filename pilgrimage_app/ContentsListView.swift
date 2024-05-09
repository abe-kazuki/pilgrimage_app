//
//  ContentsListView.swift
//  pilgrimage_app
//
//  Created by 阿部和貴 on 2024/05/09.
//

import SwiftUI

struct ContentsListView: View {
    @ObservedObject private var viewModel = SanctuaryListViewModel()
    @Environment(\.modelContext) private var modelContext
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.uniqueTitles, id: \.self) {title in
                    Text(title)
                        .onTapGesture {
                            print(title)
                        }
                }.refreshable {
                    viewModel.fetchData()
                }.navigationTitle("作品一覧")
                
            }
        }.onAppear() {
            viewModel.fetchData()
        }

    }
}

#Preview {
    ContentsListView()
}

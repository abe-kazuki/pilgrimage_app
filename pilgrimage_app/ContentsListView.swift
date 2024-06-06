//
//  ContentsListView.swift
//  pilgrimage_app
//
//  Created by 阿部和貴 on 2024/05/09.
//

import SwiftUI

struct ContentsListView: View {
    @ObservedObject private var viewModel: SanctuaryListViewModel = SanctuaryListViewModel()
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    @Environment(\.modelContext) private var modelContext
    @Binding private var searchText: String
    
    init(searchText: Binding<String>) {
        self._searchText = searchText
        self.viewModel.fetchData()
    }
    
    var body: some View {
        List {
            ForEach(self.viewModel.uniqueTitles, id: \.self) {title in
                HStack {
                    Image(systemName: "map.fill")
                    Text(title)
                        .onTapGesture {
                            self.navigationViewModel.didSelectItem()
                            self.searchText = title
                        }
                }.refreshable {
                    self.viewModel.fetchData()
                }.navigationTitle("作品一覧")
            }
        }
    }
}


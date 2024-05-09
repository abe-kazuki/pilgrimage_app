//
//  ContentsListView.swift
//  pilgrimage_app
//
//  Created by 阿部和貴 on 2024/05/09.
//

import SwiftUI

struct ContentsListView: View {
    @ObservedObject private var viewModel: SanctuaryListViewModel
    @ObservedObject var navigationViewModel: NavigationViewModel
    @Environment(\.modelContext) private var modelContext
    @Binding var searchText: String
    
    init(navigationViewModel: NavigationViewModel, searchText: Binding<String>) {
        self.viewModel = SanctuaryListViewModel()
        self.navigationViewModel = navigationViewModel
        self._searchText = searchText
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.uniqueTitles, id: \.self) {title in
                    Text(title)
                        .onTapGesture {
                            self.navigationViewModel.didSelectItem()
                            self.searchText = title
                        }
                }.refreshable {
                    self.viewModel.fetchData()
                }.navigationTitle("作品一覧")
                
            }
        }.onAppear() {
            self.viewModel.fetchData()
        }
    }
}


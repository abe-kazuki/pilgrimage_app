//
//  TopView.swift
//  pilgrimage_app
//
//  Created by 阿部和貴 on 2024/07/11.
//

import SwiftUI

struct TopView: View {
    @ObservedObject private var viewModel: SanctuaryListViewModel = SanctuaryListViewModel()

    @Environment(\.modelContext) private var modelContext
    let layout = [GridItem(.adaptive(minimum: 100))]
    
    init() {
        self.viewModel.fetchData()
    }
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                LazyVGrid(columns: layout) {
                    ForEach(viewModel.sanctuaries) { sanctuary in
                        VStack {
                            Text("\(sanctuary.name)")
                                .padding(5)
                            Text("\(sanctuary.title)")
                        }
                    }
                }
            }
            .navigationTitle("今週の人気聖地")
        }
    }
}

#Preview {
    TopView()
}

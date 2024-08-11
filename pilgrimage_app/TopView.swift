//
//  TopView.swift
//  pilgrimage_app
//
//  Created by 阿部和貴 on 2024/07/11.
//

import SwiftUI
import MapKit

struct TopView: View {
    @ObservedObject private var viewModel: TopViewModel = TopViewModel()

    @Environment(\.modelContext) private var modelContext
    @State private var lookAroundScene: MKLookAroundScene?
    let layout = [GridItem(.adaptive(minimum: 100))]
    
    init() {
        self.viewModel.fetchData()
    }
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                LazyVGrid(columns: layout) {
                    ForEach(viewModel.sanctuaryWithPhotos) { sanctuaryWithPhoto in
                        VStack {
                            Text("\(sanctuaryWithPhoto.name)")
                                .padding(5)
                            Text("\(sanctuaryWithPhoto.title)")
                                .padding(5)

                            LookAroundPreview(initialScene: viewModel.lookAroundScenes[sanctuaryWithPhoto.name])
                                .frame(height: 200)
                                .overlay(alignment: .bottomTrailing) {
                                    HStack {
                                        Text("\(sanctuaryWithPhoto.name)")
                                    }
                                    .font(.caption)
                                    .foregroundStyle(.white)
                                    .padding(30)
                                }
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

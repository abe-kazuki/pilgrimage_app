//
//  TopView.swift
//  pilgrimage_app
//
//  Created by 阿部和貴 on 2024/07/11.
//

import SwiftUI
import MapKit

struct TopView: View {
    @StateObject private var viewModel: TopViewModel = TopViewModel()
    let layout = [GridItem(.adaptive(minimum: 100))]

    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                LazyVGrid(columns: layout) {
                }
                
                LazyVGrid(columns: layout) {
                    ForEach(viewModel.sanctuaryWithPhotos) { sanctuaryWithPhoto in
                        VStack {
                            Text("\(sanctuaryWithPhoto.title)")
                                .padding(5)
                                .frame(height: 90)

                            LookAroundPreview(initialScene: viewModel.lookAroundScenes[sanctuaryWithPhoto.name])
                                .frame(height: 150)
                                .cornerRadius(10) // 角を丸くする
                                .overlay(alignment: .bottomTrailing) {
                                    Text(sanctuaryWithPhoto.name)
                                        .font(.caption)
                                        .foregroundColor(.white)
                                        .background(Color.black.opacity(0.7)) // 背景を半透明の黒に設定
                                        .cornerRadius(5)
                                }
                        }
                    }
                    .background(Color(.systemGray6)) // 背景色を設定
                    .cornerRadius(10) // 角を丸くする
                    .shadow(radius: 5) // 影を追加
                    .padding(.vertical, 10)
                    .padding(.horizontal, 2)
                }.navigationTitle("今週の人気聖地")
            }
            
        }
        .onAppear {
            self.viewModel.fetchData()
        }
    }
}

#Preview {
    TopView()
}

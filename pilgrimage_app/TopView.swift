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
                Text("本日のイベント")
                    .font(.title2)
                    .bold()
                    .padding(.horizontal, 20)
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 20) {
                        ForEach(viewModel.events) { event in
                            VStack(spacing: 5) {
                                Text(event.title)
                                    .font(.headline)
                                    .padding()
                                    .frame(width: 150, height: 50)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(10)
                                if let image = viewModel.images[event.title] {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.blue)
                                } else {
                                    ProgressView("Loading...")
                                }
                            }
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                            .padding(.vertical, 10)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                
                Text("今週の人気聖地")
                    .font(.title2)
                    .bold()
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
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
                }
            }
            
        }
        .onAppear {
            self.viewModel.fetchData()
            self.viewModel.fetchEnent()
        }
    }
}

#Preview {
    TopView()
}

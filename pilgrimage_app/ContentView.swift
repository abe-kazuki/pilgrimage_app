//
//  ContentView.swift
//  pilgrimage_app
//
//  Created by 阿部和貴 on 2024/02/02.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject private var navigationViewModel = NavigationViewModel()
    @State private var searchText = ""

    var body: some View {
        TabView(selection: $navigationViewModel.selectedTab) {
            NavigationView {
                CustopMapView(searchText: $searchText)
            }
            .tabItem {
                Label("Map", systemImage: "map")
            }
            .tag(0)
            
            NavigationView {
                ContentsListView(navigationViewModel: navigationViewModel, searchText: $searchText)
            }
            .tabItem {
                Label("Contents", systemImage: "list.bullet.clipboard")
            }
            .tag(1)
        }
    }
}

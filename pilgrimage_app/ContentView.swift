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
    @EnvironmentObject private var navigationViewModel: NavigationViewModel
    @State private var searchText = ""

    var body: some View {
        TabView(selection: $navigationViewModel.selectedTab) {
            NavigationView {
                TopView()
            }
            .tabItem {
                Label("home", systemImage: "house.fill")
            }
            .tag(0)

            NavigationView {
                CustopMapView(navigationViewModel: navigationViewModel, searchText: $searchText)
            }
            .environmentObject(navigationViewModel)
            .tabItem {
                Label("Map", systemImage: "map")
            }
            .tag(1)

            NavigationView {
                ContentsListView(searchText: $searchText)
            }
            .tabItem {
                Label("Contents", systemImage: "list.bullet.clipboard")
            }
            .tag(2)
        }
    }
}

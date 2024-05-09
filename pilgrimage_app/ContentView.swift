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
    @Query private var items: [Item]

    var body: some View {
        TabView {
            MaptView().tabItem {
                Text("map").font(.custom("Times-Roman", size: 100))
                Image(systemName: "command")
            }
            ContentsListView().tabItem {
                Text("Contents").font(.custom("Times-Roman", size: 100))
                Image(systemName: "book.pages")
            }
        }
    }
    
    struct SecondView: View {
        var body: some View {
            Text("タブメニュー２の画面")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

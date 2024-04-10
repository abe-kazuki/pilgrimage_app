//
//  InfoWindow.swift
//  pilgrimage_app
//
//  Created by 阿部和貴 on 2024/04/11.
//

import SwiftUI

struct ContentInfoWindow: View {
    let content: String
    let url: URL
    
    var body: some View {
        HStack(spacing: 1) {
            Text(content)
                .foregroundColor(.black)
                .cornerRadius(5)
            Button(action: {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }) {
                Image(systemName: "map")
                .foregroundColor(.blue)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 4)
            }
            .padding(5)
            
        }
        .padding(2)
        .background(Color.white)
        .cornerRadius(10)
        .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
    }
}

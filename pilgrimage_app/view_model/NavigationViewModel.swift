//
//  navigationViewModel.swift
//  pilgrimage_app
//
//  Created by 阿部和貴 on 2024/03/04.
//

import SwiftUI
import Firebase


class NavigationViewModel: ObservableObject {
    @Published var selectedTab: Int = 0 // タブの選択状態を管理する状態

    func didSelectItem() {
        self.selectedTab = 0
    }
}

//
//  userListViewModel.swift
//  pilgrimage_app
//
//  Created by 阿部和貴 on 2024/03/04.
//

import SwiftUI
import Firebase


class NavigationViewModel: ObservableObject {
    @Published var selectedTab: Int = 0 // タブの選択状態を管理する状態

    func didSelectItem() {
        // リスト項目が選択されたときにタブの選択状態を変更する
        self.selectedTab = 0 // MaptViewに切り替える
    }
}

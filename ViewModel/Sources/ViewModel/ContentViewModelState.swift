//
//  ContentViewModelState.swift
//  
//
//  Created by quesera2 on 2022/02/17.
//

import Foundation
import Model

enum ContentViewModelState {
    /// 待機状態
    case idle
    /// 読込中状態
    case loading
    /// 読み込み成功
    case loaded([GitHubRepository])
    /// 読み込み失敗
    case failed(ContentViewModelError)
}

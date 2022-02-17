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
    case Idle
    /// 読込中状態
    case Loading
    /// 読み込み成功
    case Loaded([GitHubRepository])
    /// 読み込み失敗
    case Failed(ContentViewModelError)
}

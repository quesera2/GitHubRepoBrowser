//
//  ContentViewModelError.swift
//  
//
//  Created by quesera2 on 2022/02/17.
//

import Foundation

public enum ContentViewModelError {
    case requestError
    case responseError
}

extension ContentViewModelError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .requestError: return "リクエストが不正です。"
        case .responseError: return "通信に失敗しました。"
        }
    }
}

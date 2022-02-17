//
//  ContentViewModelError.swift
//  
//
//  Created by quesera2 on 2022/02/17.
//

import Foundation

public enum ContentViewModelError {
    case RequestError
    case ResponseError
}

extension ContentViewModelError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .RequestError: return "リクエストが不正です。"
        case .ResponseError: return "通信に失敗しました。"
        }
    }
}

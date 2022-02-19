//
//  Navigator.swift
//  GitHubRepoBrowser
//
//  Created by quesera2 on 2022/02/19.
//

import Foundation
import ViewModel
import SwiftUI

final class Navigator: NavigatorProtocol {
    
    @Environment(\.openURL) var openURL
    
    func openUrl(_ url: URL) {
        openURL(url)
    }
}

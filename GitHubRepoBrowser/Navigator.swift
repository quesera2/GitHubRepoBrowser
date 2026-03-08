import Foundation
import UIKit
import ViewModel

final class Navigator: NavigatorProtocol {

    func openUrl(_ url: URL) {
        UIApplication.shared.open(url)
    }
}

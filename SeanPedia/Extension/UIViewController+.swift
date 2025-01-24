//
//  UIViewController+.swift
//  SeanPedia
//
//  Created by BAE on 1/25/25.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, confirmHandler: ((UIAlertAction) -> Void)?, cancelHandler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: cancelHandler)
        let ok = UIAlertAction(title: "확인", style: .default, handler: confirmHandler)
        
        alert.addAction(cancel)
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
    
    func pushNewRootController(root: UIViewController) {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = scene.windows.first else { return }
        window.rootViewController = UINavigationController(rootViewController: root)
        window.makeKeyAndVisible()
    }
}

//
//  LoadingOrverlay.swift
//  chorecade
//
//  Created by Carolina Silva dos Santos on 23/06/25.
//

import UIKit

class LoadingOverlay: UIView {

    private var activityIndicator: UIActivityIndicatorView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.isUserInteractionEnabled = true

        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = self.center
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Exibe o overlay em cima da view desejada
    static func show(on view: UIView) -> LoadingOverlay {
        let overlay = LoadingOverlay(frame: view.bounds)
        overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(overlay)
        return overlay
    }

    // Remove o overlay
    func hide() {
        self.removeFromSuperview()
    }
}

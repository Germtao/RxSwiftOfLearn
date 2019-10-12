//
//  ObservableAndBindViewController.swift
//  RxSwiftByExamples
//
//  Created by QDSG on 2019/10/12.
//  Copyright © 2019 unitTao. All rights reserved.
//

import UIKit

// MARK: - 可观察和绑定
class ObservableAndBindViewController: UIViewController {
    @IBOutlet weak var circleView: UIView!
}

extension ObservableAndBindViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
}

extension ObservableAndBindViewController {
    private func setupUI() {
        circleView.layer.cornerRadius = circleView.bounds.width / 2.0
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(circleMoved(_:)))
        circleView.addGestureRecognizer(pan)
    }
    
    @objc private func circleMoved(_ recognizer: UIPanGestureRecognizer) {
        let location = recognizer.location(in: view)
        UIView.animate(withDuration: 0.1) {
            self.circleView.center = location
        }
    }
}

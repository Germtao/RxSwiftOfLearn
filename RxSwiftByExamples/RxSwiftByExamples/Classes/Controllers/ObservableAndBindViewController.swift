//
//  ObservableAndBindViewController.swift
//  RxSwiftByExamples
//
//  Created by QDSG on 2019/10/12.
//  Copyright © 2019 unitTao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: - 可观察和绑定
class ObservableAndBindViewController: UIViewController {
    @IBOutlet weak var circleView: UIView!
    
    private let circleViewModel = CircleViewModel()
    
    private let disposeBag = DisposeBag()
}

extension ObservableAndBindViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
}

// MARK: - Rx Setup
private extension ObservableAndBindViewController {
    func setupColorObserver() {
        circleViewModel.backgroundColorObservale
            .subscribe(onNext: { [unowned self] backgroundColor in
                UIView.animate(withDuration: 0.1) {
                    self.circleView.backgroundColor = backgroundColor
                    let viewBgColor = backgroundColor.withAlphaComponent(0.2)
                    self.view.backgroundColor = viewBgColor
                }
            })
            .disposed(by: disposeBag)
    }
    
    func setupCircleViewConfiguration() {
        // 将CircleView的中心点绑定到中心可观察对象
        circleView
            .rx
            .observe(CGPoint.self, "center")
            .bind(to: circleViewModel.centerVariable)
            .disposed(by: disposeBag)
    }
}

private extension ObservableAndBindViewController {
    func setupUI() {
        circleView.layer.cornerRadius = circleView.bounds.width / 2.0
        
        setupCircleViewConfiguration()
        setupColorObserver()
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(circleMoved(_:)))
        circleView.addGestureRecognizer(pan)
    }
    
    @objc func circleMoved(_ recognizer: UIPanGestureRecognizer) {
        let location = recognizer.location(in: view)
        UIView.animate(withDuration: 0.1) {
            self.circleView.center = location
        }
    }
}

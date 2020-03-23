//
//  PlayerViewController.swift
//  test
//
//  Created by Anton Miroshnyk on 3/23/20.
//  Copyright © 2020 Anton Miroshnyk. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {
    
    private let smallHeight: CGFloat = 100
    private let smallWidth: CGFloat = 200
    
    private var isFullScreen: Bool = false
    
    private let playerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue
        return view
    }()
    
    private var animator = UIViewPropertyAnimator()
    
    private var heightConst = NSLayoutConstraint()
    private var widthConst = NSLayoutConstraint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        
        view.addSubview(playerView)
        heightConst = playerView.heightAnchor.constraint(equalToConstant: smallHeight)
        heightConst.isActive = true
        widthConst = playerView.widthAnchor.constraint(equalToConstant: smallWidth)
        widthConst.isActive = true
        playerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        playerView.addGestureRecognizer(pan)
        
    }
    
    @objc func didPan(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            print(isFullScreen)
            animator = UIViewPropertyAnimator(duration: 1, curve: .easeInOut, animations: {
                self.heightConst.constant = self.isFullScreen ? self.smallHeight : self.view.frame.height
                self.widthConst.constant = self.isFullScreen ? self.smallWidth : self.view.frame.width
                self.view.layoutIfNeeded()
            })
            animator.pauseAnimation()
        case .changed:
            let translation = recognizer.translation(in: playerView).y
            let prograss = isFullScreen ? translation / 400 : -translation / 400
            print(prograss)
            animator.fractionComplete = prograss
        case .ended:
            animator.isReversed = animator.fractionComplete < 0.3 ? true : false
            if !animator.isReversed { isFullScreen.toggle() }
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            print(isFullScreen)
        default:
            break
        }
    }
    
}

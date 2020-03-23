//
//  TestViewController.swift
//  test
//
//  Created by Anton Miroshnyk on 3/4/20.
//  Copyright © 2020 Anton Miroshnyk. All rights reserved.
//

import UIKit

class DotViewController: UIViewController {
    
    fileprivate let playerAnimationDuration = 2.0
    
    fileprivate let dot: UIView = {
        let radius: CGFloat = 10
        let view = UIView()
        view.frame = .init(x: 64, y: 64, width: radius * 2, height: radius * 2)
        view.backgroundColor = #colorLiteral(red: 0.7098039216, green: 0.4549019608, blue: 0.9607843137, alpha: 1)
        view.layer.cornerRadius = 10
        return view
    }()
    
    fileprivate var playerAnimator: UIViewPropertyAnimator?
    
    fileprivate var enemyAnimators = [UIViewPropertyAnimator]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupPlayerView()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touchLocation = event?.allTouches?.first?.location(in: view) {
            movePlayer(to: touchLocation)
        }    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touchLocation = event?.allTouches?.first?.location(in: view) {
            movePlayer(to: touchLocation)
        }
    }
    
    func setupPlayerView() {
        
        view.addSubview(dot)
    }
    
    func movePlayer(to touchLocation: CGPoint) {
        playerAnimator = UIViewPropertyAnimator(duration: playerAnimationDuration,
                                                dampingRatio: 0.7,
                                                animations: { self.dot.center = touchLocation })
        playerAnimator?.startAnimation()
    }
}

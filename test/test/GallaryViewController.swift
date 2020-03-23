//
//  MyVC.swift
//  test
//
//  Created by Anton Miroshnyk on 3/3/20.
//  Copyright © 2020 Anton Miroshnyk. All rights reserved.
//

import UIKit

class GallaryViewController: UIViewController {
    
    private var transition: TransitioningDelegate?
    
    let asd: UIButton = {
        let view = UIButton()
        view.backgroundColor = .red
        view.setTitle("<", for: .normal)
        view.frame = .init(x: 32, y: 32, width: 32, height: 32)
        view.addTarget(self, action: #selector(buttonTaped), for: .touchUpInside)
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        
        let lendth: CGFloat = (UIScreen.main.bounds.size.width - 4.0)/3.0
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: lendth, height: lendth)
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        layout.scrollDirection = .vertical
        
        let collectionView: UICollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.register(PresentingCollectionViewCell.self, forCellWithReuseIdentifier: "presenting_cell")
        collectionView.backgroundColor = UIColor.white
        collectionView.contentInset = UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        view.addSubview(asd)
        collectionView.indexPathsForSelectedItems?.first
    }
    
    @objc func buttonTaped() {
        self.dismiss(animated: true, completion: nil)
    }

}

extension GallaryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 64
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PresentingCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "presenting_cell", for: indexPath) as! PresentingCollectionViewCell
        cell.contentView.backgroundColor = UIColor.lightGray
        cell.content.image = UIImage(named: "image\(indexPath.item%4 + 1)")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PresentingCollectionViewCell
        let image = cell.content.image
        
        let vc = ImagePreviewer()
        vc.content.image = image
        vc.modalPresentationStyle = .overFullScreen
        transition = TransitioningDelegate()
        vc.transitioningDelegate = transition
        present(vc, animated: true, completion: nil)
    }
    
}

class TransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = Animator(isPresenting: false)
        return animator
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = Animator(isPresenting: true)
        return animator
    }
}

class Animator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let isPresenting: Bool
    let animationDuration: TimeInterval = 0.5
    
    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
                
        let topVC = transitionContext.viewController(forKey: isPresenting ? .to : .from)!
        let navigationController = transitionContext.viewController(forKey: isPresenting ? .from : .to) as! UINavigationController
        let bottomVC = navigationController.topViewController as! GallaryViewController
        let selectedIndexPath = bottomVC.collectionView.indexPathsForSelectedItems?.first
        let cell = bottomVC.collectionView.cellForItem(at: selectedIndexPath!)!
        
        if isPresenting {
            topVC.view.transformViewsTop(view: cell)
            containerView.addSubview(topVC.view)
        }
        
        let animations: () -> ()
        if isPresenting {
            animations = { topVC.view.transform = .identity }
        } else {
            animations = { topVC.view.transformViewsTop(view: cell) }
        }
        let animator = UIViewPropertyAnimator.init(duration: animationDuration, dampingRatio: 0.8, animations: animations)
        animator.addCompletion { _ in transitionContext.completeTransition(true) }
        animator.startAnimation()
    }
}

class ImagePreviewer: UIViewController {
    
    lazy var asd: UIButton = {
        let view = UIButton()
        view.backgroundColor = .red
        view.setTitle("X", for: .normal)
        view.frame = .init(x: 32, y: 32, width: 32, height: 32)
        view.addTarget(self, action: #selector(buttonTaped), for: .touchUpInside)
        return view
    }()
    
    let content: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .orange
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonTaped)))
        
        view.addSubview(content)
        content.stickToSuperviewsTop()
        content.heightAnchor.constraint(equalTo: content.widthAnchor).isActive = true
    
        content.enableZoom()
        
        view.addSubview(asd)
    }
    
    @objc func buttonTaped() {
        self.dismiss(animated: true, completion: nil)
    }
}

class PresentingCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.content)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public lazy var content: UIImageView = {
        let view: UIImageView = UIImageView(frame: self.contentView.bounds)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.backgroundColor = UIColor.gray
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
}

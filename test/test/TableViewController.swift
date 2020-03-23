//
//  ViewController.swift
//  test
//
//  Created by Anton Miroshnyk on 3/2/20.
//  Copyright © 2020 Anton Miroshnyk. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "photo-1534067783941-51c9c23ecefd")
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Text text"
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setup()
    }
    
    private func setup() {
        addSubview(imageView)
        addSubview(label)
        
        backgroundColor = .white
        
        imageView.anchorCenterSuperview()
        imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6).isActive = true
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        
        addSubview(label)
        label.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        label.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        
        self.addBorder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let tallH: CGFloat = 240
    private let shortH: CGFloat = 40
    private var deltaH: CGFloat {
        return tallH - shortH
    }
    
    private var heightConstraint = NSLayoutConstraint()
    
    private lazy var headerAnimator: UIViewPropertyAnimator = {
        let animator = UIViewPropertyAnimator(duration: 0.25, curve: UIView.AnimationCurve.linear) {
            self.heightConstraint.constant = self.shortH
            self.headerView.label.alpha = 0
            self.view.layoutIfNeeded()
        }
        animator.pausesOnCompletion = true
        animator.pauseAnimation()
        return animator
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: UITableView.Style.plain)
        table.contentInset = .init(top: tallH, left: 0, bottom: 0, right: 0)
        table.contentOffset = .init(x: 0, y: -tallH)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let headerView: HeaderView = {
        let view = HeaderView()
        return view
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(headerView)
        headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        heightConstraint = headerView.heightAnchor.constraint(equalToConstant: tallH)
        heightConstraint.isActive = true
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "id")
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "header")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        headerAnimator.stopAnimation(true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath)
        cell.textLabel?.text = "row number \(indexPath.row)"
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let y: CGFloat = scrollView.contentOffset.y
        guard y > -tallH && y < 0 else { return }
        if headerAnimator.fractionComplete > 0.5 {
            tableView.setContentOffset(CGPoint(x: 0, y: -shortH), animated: true)
        } else {
            tableView.setContentOffset(CGPoint(x: 0, y: -tallH), animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y: CGFloat = scrollView.contentOffset.y
        guard y > -tallH && y < 0 else { return }
        let fractionComplete = 1 - ((-y - shortH) / deltaH)
        headerAnimator.fractionComplete = fractionComplete
    }
}

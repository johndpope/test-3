//
//  MenuViewController.swift
//  test
//
//  Created by Anton Miroshnyk on 3/23/20.
//  Copyright © 2020 Anton Miroshnyk. All rights reserved.
//

import UIKit

struct AnimationExample {
    let title: String
    let vc: UIViewController.Type
    let icon: UIImage?
    
    static let items: [AnimationExample] = [
        AnimationExample(title: "Photos transition", vc: GallaryViewController.self, icon: nil),
        AnimationExample(title: "Flexible header", vc: TableViewController.self, icon: nil),
        AnimationExample(title: "Dot fun", vc: DotViewController.self, icon: nil),
        AnimationExample(title: "Player", vc: PlayerViewController.self, icon: nil)
    ]
}

class MenuViewController: UIViewController {

    let items = AnimationExample.items
    
    private lazy var tableView: UITableView = {
        let tableView: UITableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.fillSuperview()
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = items[indexPath.row]
        cell.imageView?.image = #imageLiteral(resourceName: "photo-1534067783941-51c9c23ecefd")
        cell.textLabel?.text = item.title
        cell.accessoryType = .detailDisclosureButton
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.item]
        let vc = item.vc.init()
        vc.title = item.title
        navigationController?.pushViewController(vc, animated: true)
    }
}

//
//  ImagePreviewer.swift
//  test
//
//  Created by Anton Miroshnyk on 3/18/20.
//  Copyright © 2020 Anton Miroshnyk. All rights reserved.
//

import UIKit

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

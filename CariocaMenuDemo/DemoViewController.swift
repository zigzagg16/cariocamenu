//
//  ViewController.swift
//  CariocaMenuDemo
//
//  Created by Arnaud Schloune on 21/11/2017.
//  Copyright © 2017 CariocaMenu. All rights reserved.
//

import UIKit

class DemoViewController: UIViewController {

    var carioca: CariocaMenu?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        initialiseCarioca()
    }

    func initialiseCarioca() {
        if let dataSource = self.storyboard?.instantiateViewController(withIdentifier: "DemoMenu")
            as? CariocaController {
            self.addChildViewController(dataSource)
            carioca = CariocaMenu(dataSource: dataSource,
                                  hostView: self.view,
                                  edges: [.left, .right],
                                  delegate: self)
            carioca?.addInHostView()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension DemoViewController: CariocaDelegate {

    func cariocaDidSelectItem(at index: Int) {
       CariocaMenu.log("didSelect: \(index)")
    }
}

//
//  BaseMetalViewController.swift
//  Navy_Nickel
//
//  Created by Grzegorz Przybyła on 25/10/2019.
//  Copyright © 2019 Grzegorz Przybyła(S). All rights reserved.
//

import UIKit

class BaseMetalViewController<T: UIView>: UIViewController {
    override func loadView() {
        let view = T.init()
        self.view = view
    }
}

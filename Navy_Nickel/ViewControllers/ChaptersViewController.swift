//
//  ChaptersViewController.swift
//  Navy_Nickel
//
//  Created by Grzegorz Przybyła(S) on 18/10/2019.
//  Copyright © 2019 Grzegorz Przybyła(S). All rights reserved.
//

import UIKit

class ChaptersViewController: UITableViewController {
    let chapters: [(String, UIViewController.Type)] = [("Scene setup", SceneSetupViewController.self),
                                                       ("2D Drawing", Drawing2DViewController.self),
                                                       ("3D Drawing", ViewController.self),
                                                       ("Lighting", ViewController.self)]
    let cellIdentifier = "cellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Metal by examples"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chapters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        cell.selectionStyle = .none
        cell.textLabel?.text = chapters[indexPath.row].0
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewControllerType = chapters[indexPath.row].1
        let viewController = viewControllerType.init()
        navigationController?.pushViewController(viewController, animated: true)
    }
}

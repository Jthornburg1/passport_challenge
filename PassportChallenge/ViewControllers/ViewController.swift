//
//  ViewController.swift
//  PassportChallenge
//
//  Created by jonathan thornburg on 6/11/18.
//  Copyright © 2018 jonathan thornburg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segControlHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var segControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        segControl.alpha = 0
        segControl.tintColor = UIColor.darkGray
        segControlHeightConstraint.constant = 0
        tableView.delegate = self
        searchBar.delegate = self
    }
    func segControl(show: Bool) {
        let heightMetric: CGFloat = show ? 28 : 0
        let alphaMetric: CGFloat = show ? 1 : 0
        UIView.animate(withDuration: 0.3, animations: {
            self.segControlHeightConstraint.constant = heightMetric
            self.segControl.alpha = alphaMetric
            self.viewWillLayoutSubviews()
            self.view.layoutIfNeeded()
        }) { (success) in
            // after appearance/disappearance
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        segControl(show: true)
        return true
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        segControl(show: false)
        searchBar.resignFirstResponder()
    }
}


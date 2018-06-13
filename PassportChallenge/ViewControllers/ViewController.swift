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
    
    var profiles = [Profile]()
    var imageCache = NSCache<AnyObject, AnyObject>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        segControl.alpha = 0
        segControl.tintColor = UIColor.darkGray
        segControlHeightConstraint.constant = 0
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        let cellNib = UINib(nibName: "ProfileCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "ProfileCell")
        tableView.separatorColor = UIColor.black
        tableView.separatorInset = UIEdgeInsets(top: -0.2, left: 0, bottom: 0, right: -0.2)
        FirebaseGet.shared.getProfiles { (profiles) in
            self.profiles = profiles.sorted(by: { $0.id! < $1.id! })
            self.tableView.reloadData()
        }
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
        return profiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let profile = profiles[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as? ProfileCell
        if let id = profile.id {
            if imageCache.object(forKey: id as AnyObject) == nil {
                profile.getImage { (success, imag) in
                    if let img = imag {
                        self.imageCache.setObject(img, forKey: id as AnyObject)
                        cell?.profileImageView.image = img
                    }
                }
            } else {
                if let img = self.imageCache.object(forKey: id as AnyObject) as? UIImage {
                    cell?.profileImageView.image = img
                }
            }
        }
        cell?.configureFor(profile: profile)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 156
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        segControl(show: true)
        return true
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        segControl(show: false)
        FirebaseGet.shared.getProfiles { (pr) in
            
        }
        searchBar.resignFirstResponder()
    }
}


//
//  ViewController.swift
//  PassportChallenge
//
//  Created by jonathan thornburg on 6/11/18.
//  Copyright © 2018 jonathan thornburg. All rights reserved.
//

import UIKit

protocol OverlayDelegate {
    func removeOverlay()
}

enum TypeOfFilter {
    case none
    case nameAscending
    case nameDescending
    case ageAscending
    case ageDescending
    case menOnly
    case womenOnly
}

class ViewController: UIViewController, OverlayDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addProfileButton: UIButton!
    @IBOutlet weak var applyFilterButton: UIButton!
    
    var profiles = [Profile]()
    var genderSpecificProfiles = [Profile]()
    var imageCache = NSCache<AnyObject, AnyObject>()
    var detailVC: ProfileOverlayViewController?
    var filterType: TypeOfFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterType = .none
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        let cellNib = UINib(nibName: "ProfileCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "ProfileCell")
        tableView.separatorColor = UIColor.black
        tableView.separatorInset = UIEdgeInsets(top: -0.2, left: 0, bottom: 0, right: -0.2)
        FirebaseGet.shared.getProfiles { (profiles) in
            self.profiles = profiles.sorted(by: { $0.id! < $1.id! })
            self.tableView.reloadData()
        }
        applyFilterButton.layer.borderColor = UIColor.darkGray.cgColor
        applyFilterButton.layer.cornerRadius = 3
        applyFilterButton.layer.borderWidth = 0.5
        addProfileButton.layer.borderColor = UIColor.darkGray.cgColor
        addProfileButton.layer.borderWidth = 0.5
        addProfileButton.layer.cornerRadius = 3
    }
    @IBAction func didTapAddFilter(_ sender: Any) {
        
    }
    
    @IBAction func didTapAddProfile(_ sender: Any) {
        
    }
    
    // Delegate function to remove Overlay
    func removeOverlay() {
        detailVC?.willMove(toParentViewController: nil)
        detailVC!.view.removeFromSuperview()
        detailVC!.removeFromParentViewController()
        tableView.isUserInteractionEnabled = true
        detailVC = nil
    }
    
    func getCorrectArray() -> [Profile] {
        switch filterType {
        case .nameAscending:
            profiles = profiles.sorted(by: { $0.name! < $1.name! })
        case .nameDescending:
            profiles = profiles.sorted(by: { $0.name! > $1.name! })
        case .ageAscending:
            profiles = profiles.sorted(by: { $0.age! < $1.age! })
        case .ageDescending:
            profiles = profiles.sorted(by: { $0.age! > $1.age! })
        case .menOnly:
            genderSpecificProfiles = profiles.filter{ $0.gender! == "male" }
        case .womenOnly:
            genderSpecificProfiles = profiles.filter{ $0.gender! == "female" }
        default:
            return profiles
        }
        return profiles
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let prfs = getCorrectArray()
        return prfs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let prfs = getCorrectArray()
        let profile = prfs[indexPath.row]
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let prfs = getCorrectArray()
        detailVC = ProfileOverlayViewController()
        detailVC!.delegate = self
        detailVC!.profile = prfs[indexPath.row]
        addChildViewController(detailVC!)
        detailVC!.view.frame = CGRect(x: (view.frame.size.width / 2) - 150, y: (view.frame.size.height / 2) - 200, width: 300, height: 400)
        view.addSubview(detailVC!.view)
        detailVC!.didMove(toParentViewController: self)
        tableView.isUserInteractionEnabled = false
    }
}


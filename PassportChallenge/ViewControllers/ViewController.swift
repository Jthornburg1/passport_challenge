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
    func updateProfiles()
}

enum TypeOfFilter: String {
    case none = "Sort by ID"
    case nameAscending = "Ascending by Name"
    case nameDescending = "Descending by Name"
    case ageAscending = "Ascending by Age"
    case ageDescending = "Descending by Age"
    case menOnly = "Only Men"
    case womenOnly = "Only Women"
    static let allFilters = [TypeOfFilter.none,TypeOfFilter.nameAscending,TypeOfFilter.nameDescending,TypeOfFilter.ageAscending,TypeOfFilter.ageDescending,TypeOfFilter.menOnly,TypeOfFilter.womenOnly]
}

class ViewController: UIViewController, OverlayDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var TopButtons: [UIButton]!
    
    var profiles = [Profile]()
    var genderSpecificProfiles = [Profile]()
    var imageCache = NSCache<AnyObject, AnyObject>()
    var detailVC: ProfileOverlayViewController?
    var addProfVC: AddUserViewController?
    var filterType: TypeOfFilter!
    var detailDelegate: UpdateDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.black
        view.backgroundColor = UIColor.black
        filterType = .none
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        let cellNib = UINib(nibName: "ProfileCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "ProfileCell")
        tableView.separatorColor = UIColor.black
        tableView.separatorInset = UIEdgeInsets(top: -0.2, left: 0, bottom: 0, right: -0.2)
        updateProfiles()
        configureButtons()
    }
    
    func updateDetailProfile() {
        if let detail = detailVC {
            if let id = detail.profile.id {
                let profile = getCorrectArray().filter{ $0.id! == id }.first!
                detail.profile = profile
                detailDelegate!.update(profile: profile)
            }
        }
    }
    
    func configureButtons() {
        for button in TopButtons {
            button.layer.cornerRadius = 3
            button.layer.borderWidth = 0.5
            button.layer.borderColor = UIColor.darkGray.cgColor
        }
    }
    
    @IBAction func didTapAddFilter(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Filter/Sort", message: "How would you prefer profiles to display", preferredStyle: .actionSheet)
        for filterCase in TypeOfFilter.allFilters {
            let action = UIAlertAction(title: filterCase.rawValue, style: .default) { (action) in
                self.filterType = filterCase
                self.tableView.reloadData()
            }
            actionSheet.addAction(action)
        }
        present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func didTapAddProfile(_ sender: Any) {
        addProfVC = AddUserViewController()
        addProfVC!.delegate = self
        addProfVC!.view.frame = view.frame
        addChildViewController(addProfVC!)
        view.addSubview(addProfVC!.view)
        addProfVC!.didMove(toParentViewController: self)
    }
    
    @IBAction func didTapClearFilters(_ sender: Any) {
        filterType = .none
        tableView.reloadData()
    }
    
    // Delegate function to remove Overlay
    func removeOverlay() {
        detailVC?.willMove(toParentViewController: nil)
        detailVC!.view.removeFromSuperview()
        detailVC!.removeFromParentViewController()
        tableView.isUserInteractionEnabled = true
        tableView.reloadData()
        detailVC = nil
    }
    
    func updateProfiles() {
        FirebaseGet.shared.getProfiles { (profiles) in
            self.profiles = profiles.sorted(by: { $0.id! < $1.id! })
            self.updateDetailProfile()
            self.tableView.reloadData()
        }
    }
    
    func getCorrectArray() -> [Profile] {
        switch filterType {
        case .none:
            return profiles.sorted(by: { $0.id! < $1.id! })
        case .nameAscending:
            return profiles.sorted(by: { $0.name! < $1.name! })
        case .nameDescending:
            return profiles.sorted(by: { $0.name! > $1.name! })
        case .ageAscending:
            return profiles.sorted(by: { $0.age! < $1.age! })
        case .ageDescending:
            return profiles.sorted(by: { $0.age! > $1.age! })
        case .menOnly:
            genderSpecificProfiles = profiles.filter{ $0.gender! == "male" }
            return genderSpecificProfiles
        case .womenOnly:
            genderSpecificProfiles = profiles.filter{ $0.gender! == "female" }
            return genderSpecificProfiles
        default:
            return profiles
        }
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
        detailDelegate = detailVC!
        addChildViewController(detailVC!)
        detailVC!.view.frame = CGRect(x: (view.frame.size.width / 2) - 150, y: (view.frame.size.height / 2) - 200, width: 300, height: 400)
        view.addSubview(detailVC!.view)
        detailVC!.didMove(toParentViewController: self)
        tableView.isUserInteractionEnabled = false
    }
}


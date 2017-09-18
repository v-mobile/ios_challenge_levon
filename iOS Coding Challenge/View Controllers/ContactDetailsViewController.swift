//
//  ContactDetailsViewController.swift
//  iOS Coding Challenge
//
//  Created by Levon Hovsepyan on 9/18/17.
//  Copyright © 2017 VOLO. All rights reserved.
//

import UIKit
import RealmSwift

class ContactDetailsViewController: UIViewController {
    
    // MARK: - Constants
    
    let starIcon = UIImage(named: "star_icon")
    let filledStarIcon = UIImage(named: "filled_star_icon")
    
    // MARK: - Variables
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var favoriteButton: UIButton!
    
    var user: User!
    var isModified = false
    var onFavoriteAction: ((User) -> Void)?
    
    var isFavorite: Bool = false {
        didSet {
            favoriteButton.setImage(isFavorite ? filledStarIcon : starIcon, for: .normal)
        }
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Details"
        
        isFavorite = RealmManager.shared.isFavorite(user: user)
        setupTableView()
        
        let url = URL(string: user.picture?.large ?? "")
        profileImageView.sd_setImage(with: url, completed: nil)
    }
    
    deinit {
        guard isModified else {
            return
        }
        if isFavorite {
            RealmManager.shared.addToFavorites(user: user)
        } else {
            RealmManager.shared.removeFromFavorites(user: user)
        }
        onFavoriteAction?(user)
    }
    
    // MARK: - Methods
    
    func setupTableView() {
        tableView.registerNib(named: "InfoCell", forCellReuseIdentifier: "info_cell_id")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        isModified = true
        isFavorite = !isFavorite
    }
}

extension ContactDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension ContactDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "info_cell_id") as! InfoCell
        
        switch indexPath.row {
        case 0:
            cell.fieldLabel.text = "Full Name"
            cell.valueLabel.text = user.fullName
        case 1:
            cell.fieldLabel.text = "Email"
            cell.valueLabel.text = user.email
        case 2:
            cell.fieldLabel.text = "Cell"
            cell.valueLabel.text = user.cell
        case 3:
            cell.fieldLabel.text = "Gender"
            cell.valueLabel.text = user.gender
        case 4:
            cell.fieldLabel.text = "Date of Birth"
            cell.valueLabel.text = user.dob
        case 5:
            cell.fieldLabel.text = "Address"
            cell.valueLabel.text = user.location?.address
        case 6:
            cell.fieldLabel.text = "Postal Code"
            cell.valueLabel.text = user.location?.postcode.description
        default:
            break
        }
        
        return cell
    }
}

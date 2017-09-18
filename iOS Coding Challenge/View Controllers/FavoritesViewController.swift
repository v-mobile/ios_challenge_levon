//
//  FavoritesViewController.swift
//  iOS Coding Challenge
//
//  Created by Levon Hovsepyan on 9/18/17.
//  Copyright © 2017 VOLO. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var favoriteUsers: [User] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Favorites"
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadFavoriteUsers()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let dest = segue.destination as? ContactDetailsViewController {
            dest.user = User(copy: sender as? User)
            dest.onFavoriteAction = { user in
                self.loadFavoriteUsers()
            }
        }
    }
    
    // MARK: - Methods
    
    func setupTableView() {
        tableView.registerNib(named: "ContactCell", forCellReuseIdentifier: "contact_cell_id")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func loadFavoriteUsers() {
        favoriteUsers = RealmManager.shared.favoriteUsers()
    }
}

extension FavoritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "favorites_details_segue", sender: favoriteUsers[indexPath.row])
    }
    
}

extension FavoritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contact_cell_id") as! ContactCell
        
        let user = favoriteUsers[indexPath.row]
        
        cell.nameLabel.text = user.fullName
        cell.emailLabel.text = user.email
        cell.phoneLabel.text = user.cell
        
        let thumbnail = URL(string: user.picture?.medium ?? "")
        cell.profilePic.sd_setImage(with: thumbnail, placeholderImage: UIImage(named: "user_placeholder"), options: .highPriority, completed: nil)
        
        return cell
    }
}

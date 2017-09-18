//
//  ViewController.swift
//  iOS Coding Challenge
//
//  Created by Levon Hovsepyan on 9/18/17.
//  Copyright © 2017 VOLO. All rights reserved.
//

import UIKit
import SDWebImage

class ContactsViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    var users = Users()
    var usersToShow: [User] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Contacts"
        
        loadRandomUsers()
        setupTableView()
        setupSearchBar()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let dest = segue.destination as? ContactDetailsViewController {
            dest.user = User(copy: sender as? User)
        }
    }
    
    // MARK: - Methods
    
    func setupTableView() {
        tableView.registerNib(named: "ContactCell", forCellReuseIdentifier: "contact_cell_id")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupSearchBar() {
        searchBar.delegate = self
    }
    
    // MARK: - API
    
    func loadRandomUsers() {
        Users.loadRandom { (users, error) in
            if let error = error {
                Dialog.show(title: "Error", message: error.message, target: self)
            } else if let users = users {
                self.users = users
                self.usersToShow = users.items
            }
        }
    }
}

extension ContactsViewController: UITableViewDelegate {
    
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
        performSegue(withIdentifier: "contacts_details_segue", sender: usersToShow[indexPath.row])
    }
}

extension ContactsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersToShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contact_cell_id") as! ContactCell
        
        let user = usersToShow[indexPath.row]
        
        cell.nameLabel.text = user.fullName
        cell.emailLabel.text = user.email
        cell.phoneLabel.text = user.cell
        
        let thumbnail = URL(string: user.picture?.medium ?? "")
        cell.profilePic.sd_setImage(with: thumbnail, placeholderImage: UIImage(named: "user_placeholder"), options: .highPriority, completed: nil)
        
        return cell
    }
}

extension ContactsViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = false
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        usersToShow = users.items
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            usersToShow = users.items
        } else {
            usersToShow = users.items.filter({
                $0.email.contains(searchText.lowercased()) || $0.fullName.contains(searchText.lowercased())
            })
        }
    }
}

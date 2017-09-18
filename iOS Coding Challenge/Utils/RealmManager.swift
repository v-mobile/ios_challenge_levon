//
//  RealmManager.swift
//  iOS Coding Challenge
//
//  Created by Levon Hovsepyan on 9/18/17.
//  Copyright © 2017 VOLO. All rights reserved.
//

import RealmSwift

class RealmManager {
    
    static let shared = RealmManager()
    
    var realm: Realm!
    
    private init() {
        do {
            realm = try Realm()
        } catch {
            print("Could not start Realm! Please reinstall the app!")
        }
    }
}

extension RealmManager {
    
    func isFavorite(user: User) -> Bool {
        return realm.objects(User.self).filter(NSPredicate(format: "email = '\(user.email)'")).count != 0
    }
    
    func addToFavorites(user: User) {
        
        guard !isFavorite(user: user) else {
            return
        }
        
        realm.beginWrite()
        realm.add(user)
        do {
            try realm.commitWrite()
        } catch {
            print("Could not add user to favorites")
        }
        realm.refresh()
    }
    
    func removeFromFavorites(user: User) {
        
        guard isFavorite(user: user) else {
            return
        }

        realm.beginWrite()
        realm.delete(realm.objects(User.self).filter("email = %@", user.email))
        do {
            try realm.commitWrite()
        } catch {
            print("Could not add user to favorites")
        }
        realm.refresh()
    }
    
    func favoriteUsers() -> [User] {
        return realm.objects(User.self).filter { (_) -> Bool in
            return true
        }
    }
}

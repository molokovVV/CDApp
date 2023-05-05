//
//  PropertiesPresenter.swift
//  CDApp
//
//  Created by Виталик Молоков on 12.04.2023.
//

import Foundation

// MARK: - Detail Presenter Protocol

protocol DetailPresenterType {
    var person: Person? { get set }
    init (person: Person, storage: StorageManagerType)
    func updatePerson(image: Data?,
                      name: String?,
                      dateOfBirth: String?,
                      gender: String?)
}

// MARK: - Detail Presenter

class DetailPresenter: DetailPresenterType {

    required init(person: Person, storage: StorageManagerType) {
        self.person = person
        storageManager = storage
    }

    var person: Person?
    let storageManager: StorageManagerType

    func updatePerson(image: Data?,
                      name: String?,
                      dateOfBirth: String?,
                      gender: String?) {
        
        guard let person = person else { return }
        storageManager.updatePerson(person, image, name, dateOfBirth, gender)
    }
}

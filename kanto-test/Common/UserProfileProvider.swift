//
//  UserProfileProvider.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 16/03/21.
//

import Foundation
import Bond

enum UserProfileProviderError: Error {
    case invalidUserId
}

class UserProfileProvider {
    
    private let apiService: ApiService
    private let persistenceController: PersistenceController
    let userProfile = Observable<UserProfile?>(nil)
    
    init(apiService: ApiService, persistenceController: PersistenceController) {
        self.apiService = apiService
        self.persistenceController = persistenceController
        _ = persistenceController.userProfile.observeNext { [weak self] in
            self?.userProfile.value = $0
        }
    }

    var name: String? {
        guard let profile = userProfile.value else {
            return nil
        }
        return profile.name
    }
    
    var username: String? {
        guard let profile = userProfile.value else {
            return nil
        }
        return profile.userName
    }
    
//    func refreshUserProfile(completion: @escaping (EmptyResult) -> Void) {
//        guard let userProfile = userProfile.value else { return }
//        let accountId = userProfile.identifier
//        apiService.getAccount(with: "\(accountId)") { [weak self] (result) in
//            switch result {
//            case .success(let account):
//                self?.persistenceController.updateUserProfileInfoWith(account: account)
//                guard let cityId = account.addresses.first?.city else {
//                    completion(.success)
//                    return
//                }
//                self?.getCity(withId: cityId) { city in
//                    guard let city = city else { return }
//                    self?.persistenceController.addCity(city)
//                }
//                completion(.success)
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
//
//    func updateBusinessName(businessName: String) {
//        persistenceController.updateBusinessName(businessName: businessName)
//    }
//
//    func updateBusinessContact(firstName: String, lastName: String) {
//        persistenceController.updateBusinessContact(firstName: firstName, lastName: lastName)
//    }
//
//    func updateDeclaredActivity(activity: String) {
//        persistenceController.updateDeclaredActivity(declaredActivity: activity)
//    }
//
//    func updateCountryAddress(country: Country) {
//        persistenceController.updateUserCountryAddress(country: country)
//    }
//
//    func updateDataBank(bankInfo: SaveBankInformationResult) {
//        self.persistenceController.updateDataBankInfo(bankInfo: bankInfo)
//    }
//
//    func updateUserData(withUserData userData: UserData, completion: @escaping (EmptyResult) -> Void) {
//        guard let accountId = userProfile.value?.identifier else { return }
//        apiService.updateUserData(with: "\(accountId)", userData: userData) { (result) in
//            switch result {
//            case .success:
//                self.persistenceController.updateUserDataWith(userData: userData)
//                completion(.success)
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
//
//    func updateUserProfile(withAddress address: Address, type: String, completion: @escaping (EmptyResult) -> Void) {
//        guard let accountId = userProfile.value?.identifier else { return }
//        apiService.updateProfileInfo(with: "\(accountId)", type: type, address: address) { (result) in
//            switch result {
//            case .success:
//                self.persistenceController.updateUserAddressWith(address: address)
//                completion(.success)
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
//
//    func getCountries(completion:  @escaping (Result<[Country], Error>) -> Void) {
//        apiService.getCountries { (result) in
//            switch result {
//            case .success(let countries):
//                self.persistenceController.replaceParametrics(with: countries, type: .country)
//                completion(.success(countries))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
//
//    func getCities(from state: State, completion: @escaping (Result<[City], Error>) -> Void) {
//        apiService.getCities(stateId: String(state.identifier)) { (result) in
//            if case let .success(cities) = result {
//                self.persistenceController.replaceParametrics(with: cities, type: .city)
//            }
//            completion(result)
//        }
//    }
//
//    func getCity(withId cityId: String, completion: @escaping (City?) -> Void) {
//        if let city = citiesDictionary[cityId] {
//            completion(city)
//        } else {
//            apiService.getCity(cityId: cityId) { [weak self] (result) in
//                switch result {
//                case .success(let city):
//                    self?.citiesDictionary[cityId] = city.first
//                    completion(city.first)
//                case .failure:
//                    completion(nil)
//                }
//            }
//        }
//    }
//
//    func getJuridictions(completion:  @escaping (Result<[Juridiction], Error>) -> Void) {
//        apiService.getJuridictions { (result) in
//            switch result {
//            case .success(let juridictions):
//                completion(.success(juridictions))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
//
//    func getAffidavit(with accountId: Int, completion: @escaping (Result<Affidavit, Error>) -> Void) {
//        apiService.getAffidavit(with: accountId) { result in
//            switch result {
//            case .success (let affidavit):
//                completion(.success(affidavit))
//            case .failure (let error):
//                completion(.failure(error))
//            }
//        }
//    }
//
//    func createAffidavit(with affidavit: Affidavit, completion: @escaping (Result<EmptyNetworkResult, Error>) -> Void) {
//        apiService.createAffidavit(with: affidavit) { result in
//            switch result {
//            case .success (let response):
//                completion(.success(response))
//            case .failure (let error):
//                completion(.failure(error))
//            }
//        }
//    }
//
//    func updateAffidavit(with affidavit: Affidavit, completion: @escaping (Result<EmptyNetworkResult, Error>) -> Void) {
//        apiService.updateAffidavit(with: affidavit) { result in
//            switch result {
//            case .success (let response):
//                completion(.success(response))
//            case .failure (let error):
//                completion(.failure(error))
//            }
//        }
//    }
//
//    func updateDeclaredActivity(with accountId: Int, activity: String, completion: @escaping (Result<EmptyNetworkResult, Error>) -> Void) {
//        apiService.updateDeclaredActivity(with: accountId, activity: activity) { result in
//            switch result {
//            case .success (let response):
//                completion(.success(response))
//            case .failure (let error):
//                completion(.failure(error))
//            }
//        }
//    }
//
//    func updateBusinessDenomination(with accountId: Int, denomination: String, completion: @escaping (Result<EmptyNetworkResult, Error>) -> Void) {
//        apiService.updateBusinessDenomination(with: accountId, denomination: denomination) { result in
//            switch result {
//            case .success (let response):
//                completion(.success(response))
//            case .failure (let error):
//                completion(.failure(error))
//            }
//        }
//    }
//
//    func updateBusinessContact(with accountId: Int, firstName: String, lastName: String, completion: @escaping (Result<EmptyNetworkResult, Error>) -> Void) {
//        apiService.updateBusinessContact(with: accountId, firstName: firstName, lastName: lastName) { result in
//            switch result {
//            case .success (let response):
//                completion(.success(response))
//            case .failure (let error):
//                completion(.failure(error))
//            }
//        }
//    }
//
//    func getCollaborators(completion: @escaping (Result<Collaborators, Error>) -> Void) {
//        guard let userProfile = userProfile.value else {
//            completion(.failure(UserProfileProviderError.invalidUserId))
//            return
//        }
//        apiService.getCollaborators(with: userProfile.identifier,
//                                    then: completion)
//    }
//
//    func addCollaborator(email: String, firstName: String, lastName: String, mobilePhone: String, completion: @escaping (Result<Collaborator, Error>) -> Void) {
//        guard let userProfile = userProfile.value else {
//            completion(.failure(UserProfileProviderError.invalidUserId))
//            return
//        }
//        apiService.addCollaborator(with: userProfile.identifier,
//                                   email: email,
//                                   firstName: firstName,
//                                   lastName: lastName,
//                                   mobilePhone: mobilePhone,
//                                   then: completion)
//    }
//
//    func setState(_ state: CollaboratorState, to collaborator: Collaborator, completion: @escaping (Result<Collaborator, Error>) -> Void) {
//        guard let userProfile = userProfile.value else {
//            completion(.failure(UserProfileProviderError.invalidUserId))
//            return
//        }
//        apiService.setState(state, to: collaborator, with: userProfile.identifier, then: completion)
//    }
//
//    func updatePhone(_ phone: String, to collaborator: Collaborator, completion: @escaping (Result<Collaborator, Error>) -> Void) {
//        guard let userProfile = userProfile.value else {
//            completion(.failure(UserProfileProviderError.invalidUserId))
//            return
//        }
//        apiService.updatePhone(phone, to: collaborator, with: userProfile.identifier, then: completion)
//    }
}

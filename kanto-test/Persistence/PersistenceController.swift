//
//  PersistenceController.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 16/03/21.
//

import Foundation
import RealmSwift
import ReactiveKit
import Bond

class PersistenceController {
    
    private let keyValueStorage: KeyValueStorage
    private let database: Realm
    private static let databaseEncryptionStorageKey = "dbKey"
    private static func generateDatabaseEncryptionKey() -> Data {
        let bytes = (0 ..< 64).map { _ in UInt8.random(in: 0..<255) }
        return bytes.withUnsafeBufferPointer { (buffer: UnsafeBufferPointer<UInt8>) -> Data in
            Data(buffer: buffer)
        }
    }
    
    private(set) var userProfile = Observable<UserProfile?>(nil)
    
    init(keyValueStorage: KeyValueStorage) {
        self.keyValueStorage = keyValueStorage
        var configuration = Realm.Configuration.defaultConfiguration
//        configuration.schemaVersion = UInt64(Int(VersionManager.currentVersion()) ?? 1)
        if let databaseEncryptionKey = keyValueStorage.data(forKey: PersistenceController.databaseEncryptionStorageKey) {
            configuration.encryptionKey = databaseEncryptionKey
        } else {
            let newKey = PersistenceController.generateDatabaseEncryptionKey()
            keyValueStorage.set(newKey, forKey: PersistenceController.databaseEncryptionStorageKey)
            configuration.encryptionKey = newKey
        }
        do {
            database = try Realm(configuration: configuration)
            loadObjects()
        } catch {
            do {
                configuration.deleteRealmIfMigrationNeeded = true
                database = try Realm(configuration: configuration)
                loadObjects()
            } catch {
                fatalError("Unable to load database: \(error)")
            }
        }
    }
    
//    func storeUserProfile(with account: Account,
//                          andEmail email: String,
//                          andLastUserLogin lastUserLogin: Int?) {
//        let userProfile = UserProfile()
//        userProfile.firstName = account.firstName
//        userProfile.lastName = account.lastName
//        userProfile.email = email
//        userProfile.phoneNumber = account.telefonoMovil ?? ""
//        userProfile.identifier = account.id
//        userProfile.document = account.identification ?? ""
//        userProfile.imageUrl = "" //no service returns imageURL
//        userProfile.type = account.type
//        userProfile.gender = account.gender ?? ""
//        userProfile.birthDate = account.birthDate ?? ""
//        userProfile.nationality = account.nationality ?? 0
//        userProfile.identificationType = 1
//        userProfile.businessCuit = account.businessCuit ?? ""
//        userProfile.statusCode = 0
//        userProfile.statusOperativeTi = 0
//        userProfile.lastUserSession = lastUserLogin ?? 0
//
//        //Fiscal status
//        if let fiscalInformation = account.currentFiscalSituation {
//            userProfile.hasFiscalInformation = true
//            userProfile.cuitNumberFI = fiscalInformation.cuit ?? ""
//            userProfile.businessNameFI = fiscalInformation.businessName ?? ""
//            userProfile.iibbNumber = fiscalInformation.iibbNumber ?? ""
//            userProfile.ivaConditionId = fiscalInformation.ivaCondition?.id ?? 0
//            userProfile.ivaConditionCode = fiscalInformation.ivaCondition?.code ?? ""
//            userProfile.ivaConditionDescription = fiscalInformation.ivaCondition?.description ?? ""
//            userProfile.iibbConditionId = fiscalInformation.iibbCondition?.id ?? 0
//            userProfile.iibbConditionCode = fiscalInformation.iibbCondition?.code ?? ""
//            userProfile.iibbConditionDescription = fiscalInformation.iibbCondition?.description ?? ""
//            userProfile.documentationStatusId = fiscalInformation.documentationStatus?.id ?? 0
//            userProfile.documentationStatusCode = fiscalInformation.documentationStatus?.code ?? ""
//            userProfile.documentationStatusDescription = fiscalInformation.documentationStatus?.description ?? ""
//            userProfile.endDateExclusion = fiscalInformation.endDateExclusion ?? ""
//            userProfile.currentFiscal = fiscalInformation.current ?? false
//            userProfile.ivaExclusion = fiscalInformation.ivaExclusionPercentage ?? 0
//            let currentJIIBB = fiscalInformation.iibbJurisdictions?.filter(({ $0.central == true }))
//            userProfile.centralJIIBB = currentJIIBB?.first?.central ?? false
//            userProfile.descriptionJIIBB = currentJIIBB?.first?.description ?? ""
//        } else {
//            userProfile.hasFiscalInformation = false
//        }
//
//        if let profileBankAccount = account.informationBankAccount {
//            userProfile.hasBankInformation = true
//            userProfile.informationBankAccoundIdBI = profileBankAccount.informationBankAccoundId ?? 0
//            userProfile.cbuBI = profileBankAccount.cbu ?? ""
//            userProfile.cuitBI = profileBankAccount.cuit ?? ""
//            userProfile.accountIdBI = profileBankAccount.accountId ?? 0
//            userProfile.channelIdBI = profileBankAccount.channelId ?? 0
//            userProfile.cashoutTypeBI = profileBankAccount.cashoutType ?? ""
//            userProfile.statusBI = profileBankAccount.status ?? ""
//            userProfile.bankAccountNumberBI = profileBankAccount.bankAccountNumber ?? ""
//            userProfile.holderNameBI = profileBankAccount.holderName ?? ""
//            userProfile.bankNameBI = profileBankAccount.bankName ?? ""
//            userProfile.accountTypeBI = profileBankAccount.accountType ?? ""
//        } else {
//            userProfile.hasBankInformation = false
//        }
//
//        if let businessContact = account.contact {
//            userProfile.hasContactInformation = true
//            userProfile.contactFirstName = businessContact.firstName ?? ""
//            userProfile.contactLastName = businessContact.lastName ?? ""
//            userProfile.contactIdentificationType = businessContact.identificationType ?? ""
//            userProfile.contactIdentificationNumber = businessContact.identificationNumber ?? ""
//            userProfile.contactGender = businessContact.gender ?? ""
//            userProfile.contactMobilePhone = businessContact.mobilePhone ?? ""
//            userProfile.contactCuit = businessContact.cuit ?? ""
//            userProfile.contactBirthDate = businessContact.birthDate ?? ""
//            userProfile.contactNationality = businessContact.nationality?.description ?? ""
//            userProfile.contactActivity = businessContact.activity ?? ""
//            userProfile.contactEmail = businessContact.email ?? ""
//        }
//
//        if let accountActivity = account.activity {
//            userProfile.workingAreaId = accountActivity.workingAreaId ?? 0
//            userProfile.declaredActivity = accountActivity.declaredActivity ?? ""
//        }
//
//        if !account.validations.contains(where: { $0.type == "BIOMETRIA" }) ||
//            !account.validations.contains(where: { $0.type == "SMS" }) {
//            userProfile.needsBiometricValidation = true
//            userProfile.needsSMSValidation = true
//        } else {
//            if let needsBiometricValidation = (account.validations.first { $0.type == "BIOMETRIA" }) {
//                userProfile.needsBiometricValidation = !needsBiometricValidation.validated
//            } else {
//                userProfile.needsBiometricValidation = true
//            }
//            if let smsValidation = (account.validations.first { $0.type == "SMS" }) {
//                userProfile.needsSMSValidation = !smsValidation.validated
//            } else {
//                userProfile.needsSMSValidation = true
//            }
//        }
//
//        // Show the logged in user email and no other in Headers
//        userProfile.emailUser = email
//
//        do {
//            try database.write {
//                database.delete(database.objects(UserProfile.self))
//                database.add(userProfile)
//            }
//            self.userProfile.value = userProfile
//        } catch {
//            fatalError("Unable to save in database: \(error)")
//        }
//    }
//
//    func updateUserProfileInfoWith(account: Account) {
//        updateUserDataWith(userData: UserData(firstName: account.firstName,
//                                              lastName: account.lastName,
//                                              nationality: account.nationality ?? 0,
//                                              dateOfBirth: account.birthDate ?? ""))
//        if let legalAddress = account.addresses.first(where: { $0.typeCode == "DOM_LEGAL" }) {
//            updateUserAddressWith(address: legalAddress)
//        }
//        if let billingAddress = account.addresses.first(where: { $0.typeCode == "DOM_FACTURACION" }) {
//            updateUserBillingAddressWith(address: billingAddress)
//        }
//    }
//
//    func updateUserDataWith(userData: UserData) {
//        database.beginWrite()
//        userProfile.value?.firstName = userData.firstName
//        userProfile.value?.lastName = userData.lastName
//        userProfile.value?.birthDate = userData.dateOfBirth
//        userProfile.value?.nationality = Int(userData.nationality)
//        do {
//            try database.commitWrite()
//            self.userProfile.value = userProfile.value
//        } catch {
//            fatalError("Unable to save in database: \(error)")
//        }
//    }
//
//    /// Type of permission the user has is updated.
//    /// - Parameter type: 110 for administrators, 111 for current users.
//    func updatePermissionType(type: Int?) {
//        guard let type = type else { return }
//        userProfilePermission.value = Permission(rawValue: type)
//        try? database.write {
//            userProfile.value?.permissionType = type
//        }
//    }
//
//    func updateDataBankInfo(bankInfo: SaveBankInformationResult) {
//        database.beginWrite()
//        userProfile.value?.hasBankInformation = true
//        userProfile.value?.informationBankAccoundIdBI = bankInfo.informationBankAccoundId ?? 0
//        userProfile.value?.cbuBI = bankInfo.cbu ?? ""
//        userProfile.value?.cuitBI = bankInfo.cuit ?? ""
//        userProfile.value?.accountIdBI = bankInfo.accountId ?? 0
//        userProfile.value?.channelIdBI = bankInfo.channelId ?? 0
//        userProfile.value?.cashoutTypeBI = bankInfo.cashoutType ?? ""
//        userProfile.value?.statusBI = bankInfo.status ?? ""
//        userProfile.value?.bankAccountNumberBI = bankInfo.bankAccountNumber ?? ""
//        userProfile.value?.holderNameBI = bankInfo.holderName ?? ""
//        userProfile.value?.bankNameBI = bankInfo.bankName ?? ""
//        userProfile.value?.accountTypeBI = bankInfo.accountType ?? ""
//        do {
//            try database.commitWrite()
//            self.userProfile.value = userProfile.value
//        } catch {
//            fatalError("Unable to save in database: \(error)")
//        }
//    }
//
//    func updateBusinessName(businessName: String) {
//        database.beginWrite()
//        userProfile.value?.businessNameFI = businessName
//        do {
//            try database.commitWrite()
//            self.userProfile.value = userProfile.value
//        } catch {
//            fatalError("Unable to save in database: \(error)")
//        }
//    }
//
//    func updateBusinessContact(firstName: String, lastName: String) {
//        database.beginWrite()
//        userProfile.value?.contactFirstName = firstName
//        userProfile.value?.contactLastName = lastName
//        do {
//            try database.commitWrite()
//            self.userProfile.value = userProfile.value
//        } catch {
//            fatalError("Unable to save in database: \(error)")
//        }
//    }
//
//    func updateDeclaredActivity(declaredActivity: String) {
//        database.beginWrite()
//        userProfile.value?.declaredActivity = declaredActivity
//        do {
//            try database.commitWrite()
//            self.userProfile.value = userProfile.value
//        } catch {
//            fatalError("Unable to save in database: \(error)")
//        }
//    }
//
//    func updateUserAddressWith(address: Address) {
//        database.beginWrite()
//        userProfile.value?.street = address.street ?? ""
//        userProfile.value?.number = address.number ?? ""
//        userProfile.value?.floor = address.floor ?? ""
//        userProfile.value?.apartment = address.apartment ?? ""
//        userProfile.value?.city = address.city ?? ""
//        userProfile.value?.state = address.state ?? ""
//        userProfile.value?.zipCode = address.zipCode ?? ""
//        do {
//            try database.commitWrite()
//            self.userProfile.value = userProfile.value
//        } catch {
//            fatalError("Unable to save in database: \(error)")
//        }
//    }
//
//    func updateUserBillingAddressWith(address: Address) {
//        database.beginWrite()
//        userProfile.value?.streetBilling = address.street ?? ""
//        userProfile.value?.numberBilling = address.number ?? ""
//        userProfile.value?.floorBilling = address.floor ?? ""
//        userProfile.value?.apartmentBilling = address.apartment ?? ""
//        userProfile.value?.cityBilling = address.city ?? ""
//        userProfile.value?.stateBilling = address.state ?? ""
//        userProfile.value?.zipCodeBilling = address.zipCode ?? ""
//        do {
//            try database.commitWrite()
//            self.userProfile.value = userProfile.value
//        } catch {
//            fatalError("Unable to save in database: \(error)")
//        }
//    }
//
//    func updateUserCountryAddress(country: Country) {
//        database.beginWrite()
//        userProfile.value?.country = "\(country.description)"
//        userProfile.value?.nationality = country.identifier
//        try? database.commitWrite()
//        self.userProfile.value = userProfile.value
//    }
//
//    func replaceParametrics<P: ParametricStorable>(with parametrics: [P], type: ParametricStorageType) {
//        deleteParametrics(type: type)
//        database.beginWrite()
//        parametrics.forEach { database.add($0.storage) }
//        try? database.commitWrite()
//        fetchParametrics()
//    }
//
//    func addCity(_ city: City) {
//        try? database.write {
//            database.add(city.storage)
//            fetchParametrics()
//        }
//    }
//
//    func updateSMSValidationForCurrentUser(needsValidation: Bool) {
//        do {
//            try database.write {
//                userProfile.value?.needsSMSValidation = needsValidation
//            }
//        } catch {
//            fatalError("Unable to save in database: \(error)")
//        }
//    }
//
//    func deleteUserProfile() {
//        guard let userProfile = userProfile.value else { return }
//        do {
//            try database.write {
//                database.delete(userProfile)
//                self.userProfile.value = nil
//            }
//        } catch {
//            fatalError("Unable to save in database: \(error)")
//        }
//    }
}

private extension PersistenceController {
    
    func loadObjects() {
        //fetchUserProfile()
    }
//
//    func deleteParametrics(type: ParametricStorageType) {
//        let parametrics = database.objects(ParametricStorage.self)
//        parametrics
//            .filter { ParametricStorageType(rawValue: $0.type) == type }
//            .forEach { (storage)  in try? self.database.write { self.database.delete(storage) } }
//    }
//
//    func fetchParametrics() {
//        let storages = database.objects(ParametricStorage.self)
//        var genders: [Gender] = []
//        var country: Country?
//        var states: [State] = []
//        var cities: [City] = []
//        var accountStatuses: [AccountStatus] = []
//        var banks: [Bank] = []
//        var documents: [Document] = []
//        var phoneOperators: [PhoneOperator] = []
//        storages.forEach { storage in
//            guard let type = ParametricStorageType(rawValue: storage.type) else { return }
//            switch type {
//            case .gender:
//                genders.append(Gender(storage: storage))
//            case .country:
//                country = Country(storage: storage)
//            case .state:
//                states.append(State(storage: storage))
//            case .city:
//                cities.append(City(storage: storage))
//            case .accountStatus:
//                accountStatuses.append(AccountStatus(storage: storage))
//            case .bank:
//                banks.append(Bank(storage: storage))
//            case .document:
//                documents.append(Document(storage: storage))
//            case .phoneOperator:
//                phoneOperators.append(PhoneOperator(storage: storage))
//            }
//        }
//        parametrics.value = Parametrics(genders: genders,
//                                        country: country ?? Country(identifier: 12, code: "ARG", description: "Argentina", isActive: true),
//                                        states: states,
//                                        cities: cities,
//                                        accountStatuses: accountStatuses,
//                                        banks: banks,
//                                        documents: documents,
//                                        phoneOperators: phoneOperators)
//    }
//
//    func fetchUserProfile() {
//        userProfile = Observable(database.objects(UserProfile.self).first)
//    }
}

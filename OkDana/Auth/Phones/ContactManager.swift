//
//  ContactManager.swift
//  OkDana
//
//  Created by hekang on 2025/12/15.
//

import UIKit
import ContactsUI

// MARK: - Contact Manager
class ContactManager: NSObject {
    
    // MARK: - Properties
    static let shared = ContactManager()
    
    private let contactStore = CNContactStore()
    private var singleSelectCompletion: ((CNContact?) -> Void)?
    
    private enum Constants {
        static let contactKeys = [
            CNContactGivenNameKey,
            CNContactFamilyNameKey,
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey
        ] as [CNKeyDescriptor]
    }
    
    // MARK: - Public Methods
    func fetchAllContacts(
        on viewController: UIViewController,
        completion: @escaping ([[String: String]]) -> Void
    ) {
        checkContactAuthorization { [weak self] granted in
            guard let self = self else { return }
            
            guard granted else {
                self.showPermissionAlert(on: viewController)
                return
            }
            
            self.performFetchContacts(completion: completion)
        }
    }
    
    func selectSingleContact(
        on viewController: UIViewController,
        completion: @escaping (CNContact?) -> Void
    ) {
        checkContactAuthorization { [weak self] granted in
            guard let self = self else { return }
            
            guard granted else {
                self.showPermissionAlert(on: viewController)
                return
            }
            
            self.presentContactPicker(on: viewController, completion: completion)
        }
    }
}

// MARK: - Private Methods
private extension ContactManager {
    
    // MARK: - Authorization
    func checkContactAuthorization(completion: @escaping (Bool) -> Void) {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        
        switch status {
        case .authorized, .limited:
            completion(true)
            
        case .notDetermined:
            contactStore.requestAccess(for: .contacts) { granted, _ in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
            
        case .denied, .restricted:
            completion(false)
            
        @unknown default:
            completion(false)
        }
    }
    
    // MARK: - Alert
    func showPermissionAlert(on viewController: UIViewController) {
        let alert = UIAlertController(
            title: LanguageManager.localizedString(for: "Permission Required"),
            message: LanguageManager.localizedString(for: "Contact permission is disabled. Please enable it in Settings to allow your loan application to be processed."),
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(
            title: LanguageManager.localizedString(for: "Cancel"),
            style: .default
        )
        
        let settingsAction = UIAlertAction(
            title: LanguageManager.localizedString(for: "Go to Settings  "),
            style: .cancel
        ) { _ in
            self.openSettings()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(settingsAction)
        
        viewController.present(alert, animated: true)
    }
    
    func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    // MARK: - Contact Operations
    func performFetchContacts(completion: @escaping ([[String: String]]) -> Void) {
        var results: [[String: String]] = []
        let request = CNContactFetchRequest(keysToFetch: Constants.contactKeys)
        
        DispatchQueue.main.async {
            do {
                try self.contactStore.enumerateContacts(with: request) { contact, _ in
                    let contactDict = self.convertContactToDictionary(contact)
                    results.append(contactDict)
                }
                completion(results)
            } catch {
                print("Failed to fetch contacts: \(error)")
                completion([])
            }
        }
    }
    
    func presentContactPicker(
        on viewController: UIViewController,
        completion: @escaping (CNContact?) -> Void
    ) {
        let picker = CNContactPickerViewController()
        picker.delegate = self
        singleSelectCompletion = completion
        
        viewController.present(picker, animated: true)
    }
    
    // MARK: - Contact Conversion
    func convertContactToDictionary(_ contact: CNContact) -> [String: String] {
        let fullName = self.formatFullName(
            givenName: contact.givenName,
            familyName: contact.familyName
        )
        
        let phoneNumbers = self.formatPhoneNumbers(contact.phoneNumbers)
        
        return [
            "motorways": phoneNumbers,
            "concurrent": fullName
        ]
    }
    
    func formatFullName(givenName: String, familyName: String) -> String {
        let fullName = "\(givenName) \(familyName)"
        return fullName.trimmingCharacters(in: .whitespaces)
    }
    
    func formatPhoneNumbers(_ phoneNumbers: [CNLabeledValue<CNPhoneNumber>]) -> String {
        let numbers = phoneNumbers.map { $0.value.stringValue }
        return numbers.joined(separator: ",")
    }
}

// MARK: - CNContactPickerDelegate
extension ContactManager: CNContactPickerDelegate {
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        singleSelectCompletion?(contact)
        singleSelectCompletion = nil
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        singleSelectCompletion?(nil)
        singleSelectCompletion = nil
    }
}

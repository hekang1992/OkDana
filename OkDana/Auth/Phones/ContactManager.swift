//
//  ContactManager.swift
//  OkDana
//
//  Created by Scott Reed on 2025/12/15.
//

import UIKit
import ContactsUI

// MARK: - Contact Manager
final class ContactManager: NSObject {
    
    // MARK: - Shared Instance
    static let shared = ContactManager()
    
    // MARK: - Properties
    private let contactStore = CNContactStore()
    private var singleSelectCompletion: ((CNContact?) -> Void)?
    
    // MARK: - Private Constants
    private enum Constants {
        static let contactKeys = [
            CNContactGivenNameKey,
            CNContactFamilyNameKey,
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey
        ] as [CNKeyDescriptor]
    }
    
    // MARK: - Initializer
    private override init() {
        super.init()
    }
}

// MARK: - Public Interface
extension ContactManager {
    
    func fetchAllContacts(
        on viewController: UIViewController,
        completion: @escaping ([[String: String]]) -> Void
    ) {
        requestContactAuthorization { [weak self] isGranted in
            guard let self = self else { return }
            
            if isGranted {
                self.fetchContacts(completion: completion)
            } else {
                self.showPermissionAlert(on: viewController)
                completion([])
            }
        }
    }
    
    func selectSingleContact(
        on viewController: UIViewController,
        completion: @escaping (CNContact?) -> Void
    ) {
        requestContactAuthorization { [weak self] isGranted in
            guard let self = self else { return }
            
            if isGranted {
                self.presentContactPicker(on: viewController, completion: completion)
            } else {
                self.showPermissionAlert(on: viewController)
                completion(nil)
            }
        }
    }
}

// MARK: - Authorization Handling
private extension ContactManager {
    
    func requestContactAuthorization(completion: @escaping (Bool) -> Void) {
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
    
    func showPermissionAlert(on viewController: UIViewController) {
        let alertController = UIAlertController(
            title: LocalizedString.title,
            message: LocalizedString.permissionMessage,
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(
            title: LocalizedString.cancel,
            style: .default
        )
        
        let settingsAction = UIAlertAction(
            title: LocalizedString.settings,
            style: .cancel
        ) { _ in
            self.openAppSettings()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        
        viewController.present(alertController, animated: true)
    }
    
    func openAppSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
    }
}

// MARK: - Contact Operations
private extension ContactManager {
    
    func fetchContacts(completion: @escaping ([[String: String]]) -> Void) {
        var contacts: [[String: String]] = []
        let fetchRequest = CNContactFetchRequest(keysToFetch: Constants.contactKeys)
        
        DispatchQueue.main.async {
            do {
                try self.contactStore.enumerateContacts(with: fetchRequest) { contact, _ in
                    let contactDictionary = self.makeDictionary(from: contact)
                    contacts.append(contactDictionary)
                }
                completion(contacts)
            } catch {
                print("Contact fetch error: \(error.localizedDescription)")
                completion([])
            }
        }
    }
    
    func presentContactPicker(
        on viewController: UIViewController,
        completion: @escaping (CNContact?) -> Void
    ) {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        singleSelectCompletion = completion
        
        viewController.present(contactPicker, animated: true)
    }
    
    func makeDictionary(from contact: CNContact) -> [String: String] {
        [
            "motorways": formatPhoneNumbers(contact.phoneNumbers),
            "concurrent": formatFullName(
                givenName: contact.givenName,
                familyName: contact.familyName
            )
        ]
    }
    
    func formatFullName(givenName: String, familyName: String) -> String {
        let fullName = "\(givenName) \(familyName)"
        return fullName.trimmingCharacters(in: .whitespaces)
    }
    
    func formatPhoneNumbers(_ phoneNumbers: [CNLabeledValue<CNPhoneNumber>]) -> String {
        phoneNumbers
            .map { $0.value.stringValue }
            .joined(separator: ",")
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

// MARK: - Localized Strings
private enum LocalizedString {
    static let title = LanguageManager.localizedString(for: "Permission Required")
    static let permissionMessage = LanguageManager.localizedString(for: "Contact permission is disabled. Please enable it in Settings to allow your loan application to be processed.")
    static let cancel = LanguageManager.localizedString(for: "Cancel")
    static let settings = LanguageManager.localizedString(for: "Go to Settings")
}

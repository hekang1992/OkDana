//
//  ContactManager.swift
//  OkDana
//
//  Created by hekang on 2025/12/15.
//

import UIKit
import ContactsUI

class ContactManager: NSObject {
    
    static let shared = ContactManager()
    private let contactStore = CNContactStore()
    
    private func checkContactAuthorization(completion: @escaping (Bool) -> Void) {
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
    
    private func showPermissionAlert(on vc: UIViewController) {
        let alert = UIAlertController(
            title: LanguageManager.localizedString(for: "Permission Needed"),
            message: LanguageManager.localizedString(for: "Contact access is required to process your loan application. Please enable it in Settings to continue."),
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: LanguageManager.localizedString(for: "Cancel"), style: .cancel))
        alert.addAction(UIAlertAction(title: LanguageManager.localizedString(for: "Settings"), style: .default, handler: { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }))
        
        vc.present(alert, animated: true)
    }
    
    func fetchAllContacts(on vc: UIViewController, completion: @escaping ([[String: String]]) -> Void) {
        checkContactAuthorization { [weak self] granted in
            guard let self = self else { return }
            
            guard granted else {
                self.showPermissionAlert(on: vc)
                return
            }
            
            let keysToFetch = [
                CNContactGivenNameKey,
                CNContactFamilyNameKey,
                CNContactPhoneNumbersKey,
                CNContactEmailAddressesKey
            ] as [CNKeyDescriptor]
            
            var results: [[String: String]] = []
            let request = CNContactFetchRequest(keysToFetch: keysToFetch)
            
            do {
                try self.contactStore.enumerateContacts(with: request) { contact, _ in
                    let contactDict = self.processContactToDict(contact)
                    results.append(contactDict)
                }
                completion(results)
            } catch {
                print("==========：\(error)")
                completion([])
            }
        }
    }
    
    private func processContactToDict(_ contact: CNContact) -> [String: String] {
        let familyName = contact.familyName
        let givenName = contact.givenName
        let fullName = "\(givenName) \(familyName)".trimmingCharacters(in: .whitespaces)
        
        let phoneNumbers = contact.phoneNumbers
            .map { $0.value.stringValue }
            .joined(separator: ",")
        
        var contactDict: [String: String] = [:]
        contactDict["hull"] = phoneNumbers.isEmpty ? "" : phoneNumbers
        contactDict["concurrent"] = fullName.isEmpty ? "" : fullName
        return contactDict
    }
    
    func selectSingleContact(on vc: UIViewController, completion: @escaping (CNContact?) -> Void) {
        checkContactAuthorization { [weak self] granted in
            guard let self = self else { return }
            
            guard granted else {
                self.showPermissionAlert(on: vc)
                return
            }
            
            let picker = CNContactPickerViewController()
            picker.delegate = self
            self.singleSelectCompletion = completion
            
            vc.present(picker, animated: true)
        }
    }
    
    private var singleSelectCompletion: ((CNContact?) -> Void)?
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

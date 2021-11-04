//
//  ContactsViewModel.swift
//  GameMatch
//
//  Created by Luke Shi on 11/3/21.
//

import Foundation
import ContactsUI

class ContactsViewModel
{
    var contacts = [CNContact]()
    var activity: Activity?
    var inviteState: InviteState?

    init()
    {
        getContacts()
    }

    private func getContacts()
    {
        let contactStore = CNContactStore()
        let keys = [
                CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                CNContactPhoneNumbersKey,
                CNContactEmailAddressesKey
            ] as [Any]
        let request = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
        do {
            try contactStore.enumerateContacts(with: request) { [weak self] (contact, stop) in
                // Array containing all unified contacts from everywhere
                self?.contacts.append(contact)
                for phoneNumber in contact.phoneNumbers {
                    let number = phoneNumber.value
                    if let label = phoneNumber.label {
                        let localizedLabel = CNLabeledValue<CNPhoneNumber>.localizedString(forLabel: label)
                        print("\(contact.givenName) \(contact.familyName) tel:\(localizedLabel) -- \(number.stringValue), email: \(String(describing: contact.emailAddresses.first?.value))")
                    }
                }
            }
        } catch {
            print("unable to fetch contacts")
        }
    }

    func sendInvitation(selected: [Bool], completion: @escaping (Result<Void, Error>) -> Void)
    {
        guard let activityId = activity?.id else {
            completion(.failure(GMError(message: "No Activity")))
            return
        }

        var invites = [String]()
        for index in 0 ..< selected.count {
            if selected[index] {
                let contact = contacts[index]
                let phone = contact.phoneNumbers.first?.value.stringValue
                let email = contact.emailAddresses.first?.value
                if let invite = phone ?? (email as String?) {
                    invites.append(invite)
                }
            }
        }

        let invitation = Invitation(activityId: activityId, invites: invites)
        InviteAPIService().send(invitation: invitation) { [weak self] result in
            switch result {
            case .success(let inviteState):
                self?.inviteState = inviteState
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

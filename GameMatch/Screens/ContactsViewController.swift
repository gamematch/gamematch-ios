//
//  ContactsViewController.swift
//  Game Match
//
//  Created by Luke Shi on 8/17/21.
//

import UIKit
import ContactsUI

class ContactsViewController: UIViewController
{
    @IBOutlet var tableView: UITableView!
    
    var contacts = [CNContact]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Contacts"
        
        tableView.tableFooterView = UIView(frame: .zero)

        getContacts()
    }
    
    @IBAction func doneAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    private func getContacts() {
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
                        print("\(contact.givenName) \(contact.familyName) tel:\(localizedLabel) -- \(number.stringValue), email: \(contact.emailAddresses)")
                    }
                }
            }
            tableView.reloadData()
        } catch {
            print("unable to fetch contacts")
        }
    }
}

extension ContactsViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "Cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)

        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: cellId)
        }

        let contact = contacts[indexPath.row]
        cell?.textLabel?.text = "\(contact.givenName) \(contact.familyName)"
        cell?.detailTextLabel?.text = contact.phoneNumbers.first?.value.stringValue
        
        cell?.accessoryView = UIImageView(image: UIImage(systemName: "checkmark"), color: .clear)
        
        return cell!
    }
}

extension ContactsViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryView = UIImageView(image: UIImage(systemName: "checkmark"))
    }
}

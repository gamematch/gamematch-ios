//
//  ContactsViewController.swift
//  Game Match
//
//  Created by Luke Shi on 8/17/21.
//

import UIKit
import ContactsUI

class ContactsViewController: BaseViewController
{
    @IBOutlet var tableView: UITableView!

    private let contactsVM = ContactsViewModel()
    
    private var selected = [Bool]()

    func setup(activity: Activity?)
    {
        contactsVM.activity = activity
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationItem.title = "Contacts"
        
        tableView.tableFooterView = UIView(frame: .zero)

        for _ in contactsVM.contacts {
            selected.append(false)
        }
    }
    
    @IBAction func doneAction(_ sender: Any)
    {
        startSpinner()
        contactsVM.sendInvitation(selected: selected) { [weak self] result in
            self?.stopSpinner()
            switch result {
            case .success():
                self?.navigationController?.popViewController(animated: true)
            case .failure(let error):
                self?.showError(error)
            }
        }
    }
}

extension ContactsViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return contactsVM.contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellId = "Cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)

        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: cellId)
        }

        let contact = contactsVM.contacts[indexPath.row]
        cell?.textLabel?.text = "\(contact.givenName) \(contact.familyName)"
        cell?.detailTextLabel?.text = contact.phoneNumbers.first?.value.stringValue
        
        cell?.accessoryView = selected[indexPath.row] ? UIImageView(image: UIImage(systemName: "checkmark"))
                                                      : UIImageView(image: UIImage(systemName: "checkmark"), color: .clear)
        cell?.selectionStyle = .none
        
        return cell!
    }
}

extension ContactsViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath)

        selected[indexPath.row] = !selected[indexPath.row]
        cell?.accessoryView = selected[indexPath.row] ? UIImageView(image: UIImage(systemName: "checkmark"))
                                                      : UIImageView(image: UIImage(systemName: "checkmark"), color: .clear)
    }
}

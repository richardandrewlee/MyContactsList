//
//  ViewController.swift
//  MyContacts
//
//  Created by Richard Lee on 8/8/17.
//  Copyright © 2017 Richard Lee. All rights reserved.
//

import UIKit

protocol ContactDelegate: class {
    func pushToContact(_ contact:Contact)
}

class ViewController: BaseViewController, ContactDelegate, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
   

    // MARK: View Vars
    
    let searchController                 = UISearchController(searchResultsController: nil)
    var selectedContact                  : Contact!
    @IBOutlet weak var contactsTableView : UITableView!
    @IBOutlet weak var searchContainer   : UIView!
    
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchContainer.addSubview(searchController.searchBar)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contactsTableView.reloadData()
    }
    
    
    // MARK: Contacts Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching() {
            return ContactStorage.store.searched.count
        } else {
            return ContactStorage.store.contacts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let contact = (isSearching()) ? ContactStorage.store.searched[indexPath.row] : ContactStorage.store.contacts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
        cell.name.text = "\(contact.firstName) \(contact.lastName)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedContact = (isSearching()) ? ContactStorage.store.searched[indexPath.row] : ContactStorage.store.contacts[indexPath.row]
        performSegue(withIdentifier: "contactSegue", sender: self)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            let contact = (isSearching()) ? ContactStorage.store.searched[indexPath.row] : ContactStorage.store.contacts[indexPath.row]
            ContactStorage.store.delete(contact)
            tableView.reloadData()
        }
    }
    
    // MARK: Search
    
    func isSearching() -> Bool {
        return searchController.isActive && searchController.searchBar.text != ""
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        ContactStorage.store.searched = ContactStorage.store.contacts.filter(NSPredicate(format: "fullName contains[c] %@", searchController.searchBar.text!))
        contactsTableView.reloadData()
    }
    
    // MARK: Storyboard Navigation
    
    func pushToContact(_ contact:Contact){
        selectedContact = contact
        performSegue(withIdentifier: "contactSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // we have to do this so that when we click done no matter what we reveal the contacts view
        if (segue.identifier == "creatorSegue") {
            print("segue.destination \(segue.destination)")
            if let nc = segue.destination as? UINavigationController {
                if let vc = nc.viewControllers[0] as? CreateViewController{
                    vc.delegate = self
                }
            }
        }else if (segue.identifier == "contactSegue") {
            let contactViewController = segue.destination as! ContactViewController
            contactViewController.existingContact = selectedContact
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}



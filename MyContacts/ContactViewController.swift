//
//  ContactViewController.swift
//  MyContacts
//
//  Created by Richard Lee on 8/8/17.
//  Copyright © 2017 Richard Lee. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import MapKit

class ContactViewController : BaseViewController, UITextFieldDelegate {
    
    // MARK: Contact vars
    
    var existingContact            : Contact!
    
    @IBOutlet weak var wholeName   : UITextField!
    @IBOutlet weak var dateOfBirth : UITextField!
    @IBOutlet weak var phoneNumber : UITextField!
    @IBOutlet weak var zipCode     : UITextField!
    @IBOutlet weak var buttonRemind: UIButton!
    @IBOutlet weak var buttonCall  : UIButton!
    @IBOutlet weak var buttonLocate: UIButton!
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        populateData()
        deactivateKeyboared()
    }
    
    // MARK: Set Up UI
    
    func populateData(){
        wholeName.text   = wholeNameText()
        validateText(label: dateOfBirth, text:existingContact.dateOfBirth, activate: buttonRemind)
        validateText(label: phoneNumber, text:existingContact.phoneNumber, activate: buttonCall)
        validateText(label: zipCode,     text:existingContact.zipCode,     activate: buttonLocate)
    }
    
    func validateText(label: UITextField, text: String, activate button:UIButton){
        let notEmpty    = (text != "")
        label.text      = (notEmpty) ? text  : "N/A"
        label.alpha     = (notEmpty) ? 1.0   : 0.5
        button.isHidden = (notEmpty) ? false : true
    }
    
    func wholeNameText() -> String{
        var name = ""
        let contact   = existingContact!
        let firstName = contact.firstName
        let lastName  = contact.lastName
        let first     = (firstName != "")
        let last      = (lastName != "")
        
        if(first && last){
            name = "\(firstName) \(lastName)"
        }else if(!first){
            name = lastName
        }else if(!last){
            name = firstName
        }
        
        return name
    }
    
    // MARK: Canceling Out Of Showing Keyboard
    
    func deactivateKeyboared(){
        self.wholeName.inputView   = UIView.init()
        self.dateOfBirth.inputView = UIView.init()
        self.phoneNumber.inputView = UIView.init()
        self.zipCode.inputView     = UIView.init()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
    
    // MARK: Button Actions
    
    func openApplication(url:String){
        if let url = URL(string: url), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func createReminder(_ sender: Any) {
        let date = existingContact.dob.copy() as! NSDate
        let name = self.wholeNameText()
        EventCreation.make(name: wholeNameText(), date: date, whenDone: {
            Prompt.basicAlert(title: "Event saved to calendar", message: "as \(name)'s Birthday!", buttonTitle: "OK", parent: self)
        })
    }
    
    @IBAction func openInMap(_ sender: Any) {
        openApplication(url: "http://maps.apple.com/?address=\(existingContact.zipCode)")
    }
    
    @IBAction func callNumber(_ sender: Any) {
        openApplication(url: "telprompt://\(existingContact.phoneNumber.digits)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // we have to do this so that when we click done no matter what we reveal the contacts view
        if (segue.identifier == "editSegue") {
            
            if let nc = segue.destination as? UINavigationController {
                if let vc = nc.viewControllers[0] as? CreateViewController{
                    vc.existingContact = existingContact
                    vc.title = "Edit Contact"
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

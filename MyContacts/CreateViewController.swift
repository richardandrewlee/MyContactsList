//
//  CreateViewController.swift
//  MyContacts
//
//  Created by Richard Lee on 8/8/17.
//  Copyright © 2017 Richard Lee. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import ContactsUI
import PhoneNumberKit
import UDatePicker

class CreateViewController: BaseViewController, CNContactPickerDelegate, UITextFieldDelegate {
    
    // MARK: Create Vars
    
    weak var delegate              : ViewController?
    var existingContact            : Contact!
    var datePicker                 : UDatePicker?
    var birthDay                   : NSDate?
    var exists                     = false
    
    @IBOutlet weak var firstName   : UITextField!
    @IBOutlet weak var lastName    : UITextField!
    @IBOutlet weak var phoneNumber : PhoneNumberTextField!
    @IBOutlet weak var zipCode     : UITextField!
    @IBOutlet weak var buttonDelete: UIButton!
    @IBOutlet weak var dateOfBirth : UITextField!
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setKeyboards()
        checkAndPopulate()
    }
    
    // MARK: Set Up UI And Interaction
    
    func setKeyboards(){
        zipCode.keyboardType  = UIKeyboardType.numberPad
        dateOfBirth.inputView = UIView.init()
        phoneNumber.delegate = self
        dateOfBirth.delegate = self
        firstName.delegate = self
        lastName.delegate = self
        
        if(!exists){
            firstName.becomeFirstResponder()
        }
        
        let phoneDone = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneForPhoneNumber))
        phoneNumber.addDoneButtonOnKeyboard(button: phoneDone)
        
        let zipDone = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneForZipCode))
        zipCode.addDoneButtonOnKeyboard(button: zipDone)
        
    }
    
    func checkAndPopulate(){
        if (existingContact) != nil {
            exists = true
            firstName.text        = existingContact.firstName
            lastName.text         = existingContact.lastName
            dateOfBirth.text      = existingContact.dateOfBirth
            phoneNumber.text      = existingContact.phoneNumber
            zipCode.text          = existingContact.zipCode
            setDeleteButton()
        }
    }
    
    func setDeleteButton(){
        buttonDelete.isHidden = true // hidden for now bug with realm and dif viewcontrollers
        buttonDelete.layer.borderColor = Theme.red.cgColor
    }

    // MARK: Button Actions
    
    func doneForPhoneNumber(){
        zipCode.becomeFirstResponder()
    }
    
    func doneForZipCode(){
        dateOfBirth.becomeFirstResponder()
    }
    
    @IBAction func unwindToPreviousViewController(_ sender: Any) {
        self.popToPreviousViewController()
    }
    
    @IBAction func done(_ sender: Any) {
        trySave()
    }
    
    @IBAction func tryDelete(_ sender: Any) {
        ContactStorage.store.delete(existingContact)
        dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "deleteSegue", sender: self)
    }

    // MARK: Save, Modidfy
    
    func createSortString(first: String, last: String) -> String {
        
        if(last == ""){
            return first
        }else if(first == ""){
            return last
        }
        
        return "\(last) \(first)"
    }
    
    func createAndSaveContact(){
        let contact          = Contact()
        let fn = firstName.text ?? ""
        let ln = lastName.text ?? ""
        contact.firstName   = fn
        contact.lastName    = ln
        contact.fullName    = "\(fn) \(ln)"
        contact.sortString  = createSortString(first: fn, last: ln)
        if(birthDay != nil){
            contact.dob = birthDay!
        }
        contact.dateOfBirth = dateOfBirth.text ?? ""
        contact.phoneNumber = phoneNumber.text ?? ""
        contact.zipCode     = zipCode.text ?? ""
        ContactStorage.store.save(contact)
        existingContact = contact
    }
    
    func modifyAndSaveContact(){
        let realm = try! Realm()
        
        let fn = firstName.text ?? ""
        let ln = lastName.text ?? ""
        
        try! realm.write({
            existingContact?.firstName   = fn
            existingContact?.lastName    = ln
            existingContact?.fullName    = "\(fn) \(ln)"
            existingContact?.sortString  = createSortString(first: fn, last: ln)
            existingContact?.dateOfBirth = dateOfBirth.text ?? ""
            existingContact?.phoneNumber = phoneNumber.text ?? ""
            existingContact?.zipCode     = zipCode.text ?? ""
        })
        
        if(birthDay != nil){
            try! realm.write({
                existingContact?.dob         = birthDay!
            })
        }
    }
    
    func save(){
        if(!exists){
            createAndSaveContact()
        }else{
            modifyAndSaveContact()
        }
        exitAfterSave()
    }
    
    func trySave(){
        if(validated()){
            save()
        }else{
            Prompt.basicAlert(
                title       : "Details Needed.",
                message     : "Oops, looks like you forgot a first name or last name",
                buttonTitle : "OK",
                parent      : self
            )
        }
    }
    
    func validated() -> Bool{
        return (!firstName.empty() || !lastName.empty())
    }

    
    // MARK: Additional Form Functionality
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        switch textField {
            case firstName : lastName.becomeFirstResponder(); break;
            case lastName  : phoneNumber.becomeFirstResponder(); break;
            default: break
        }
        return false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if(textField == dateOfBirth){
            showDatePicker()
        }
        return true
    }
    
    func showDatePicker() {
        if datePicker == nil {
            datePicker = UDatePicker(
                frame: view.frame,
                callBackOne:{
                    self.resignAll()
            },
                callBackTwo:{
                    self.resignAll()
            },
                willDisappear: { date in
                    if date != nil {
                        self.dateOfBirth.text = "\(date!.toString())"
                        self.birthDay = date! as NSDate
                    }
            }, didDisappear:{ date in
                
            })
        }
        
        datePicker?.picker.date = NSDate() as Date
        datePicker?.present(self)
    }

    func resignAll(){
        self.dateOfBirth.resignFirstResponder()
        self.phoneNumber.resignFirstResponder()
        self.zipCode.resignFirstResponder()
        self.lastName.resignFirstResponder()
        self.firstName.resignFirstResponder()
    }
    
    func exitAfterSave(){
        delegate?.pushToContact(existingContact)
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

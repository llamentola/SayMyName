//
//  ViewController.swift
//  SayMyName
//
//  Created by Edna Dumas on 4/21/19.
//  Copyright © 2019 Edna Dumas. All rights reserved.
//

import UIKit
import AddressBookUI


class ViewController: UIViewController, ABPeoplePickerNavigationControllerDelegate {

    @IBOutlet weak var forenameField: UITextView!
    @IBOutlet weak var surnameField: UITextView!
    
    @IBAction func getContact(_ sender: Any) {
        if (ABAddressBookGetAuthorizationStatus() == ABAuthorizationStatus.denied ||
            ABAddressBookGetAuthorizationStatus() == ABAuthorizationStatus.restricted){
            print("Denied");
        }else if (ABAddressBookGetAuthorizationStatus() == ABAuthorizationStatus.authorized){
            self.showPeoplePicker()
        } else { //Undetermined
            var emptyDictionary: CFDictionary?
            var addressBook: ABAddressBook?
            print("requesting access...")
            addressBook = obtainAddressbook(addressbookRef: ABAddressBookCreateWithOptions(emptyDictionary,nil))
            ABAddressBookRequestAccessWithCompletion(addressBook, { success, error in if success {
                self.showPeoplePicker()
            }
            else {
                print("Denied")
                }
            }) }
    }
    
    func peoplePickerNavigationController(_ peoplePicker: ABPeoplePickerNavigationController, didSelectPerson person: ABRecord) {
        
        if let forename = ABRecordCopyValue(person, kABPersonFirstNameProperty).takeRetainedValue() as? NSString {forenameField.text = forename as String}
        
        if let surname = ABRecordCopyValue(person, kABPersonLastNameProperty).takeRetainedValue() as? NSString {surnameField.text = surname as String}
    }
    
    func peoplePickerNavigationControllerDidCancel(peoplePicker:
        ABPeoplePickerNavigationController!) {
        print("Cancelled")
    }
    
    @IBAction func sayContact(_ sender: Any) {
        let name = String(format: NSLocalizedString("SELECTED", comment: ""), forenameField, surnameField)
        let personName = String.localizedStringWithFormat(name)
        TextToSpeech.SayText(input: personName)
    }
    
    func showPeoplePicker() {
        var picker : ABPeoplePickerNavigationController =
            ABPeoplePickerNavigationController()
        picker.peoplePickerDelegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func obtainAddressbook(addressbookRef: Unmanaged<ABAddressBook>!) ->
        ABAddressBook? {
            if let addressbook = addressbookRef {
                return Unmanaged<NSObject>.fromOpaque(addressbook.toOpaque()).takeUnretainedValue()
            }
            return nil }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}


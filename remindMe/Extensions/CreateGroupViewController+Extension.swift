//
//  CreateGroupViewController+Extension.swift
//  remindMe
//
//  Created by Medi Assumani on 9/24/18.
//  Copyright © 2018 Yves Songolo. All rights reserved.
//

import UIKit

extension CreateGroupViewController: UITextFieldDelegate{
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
//        guard let segueIdentifier = segue.identifier else {return}
//
//        switch segueIdentifier {
//        case Constant.saveGroupSegueIdentifier where group == nil:
//
//            guard let address = groupAddressTextField.text, let name = groupNameTextField.text else { return }
//            GeoFence.shared.addressToCoordinate(address) { (location) in
//                if let location = location{
//
//                    let latitude = location.latitude
//                    let longitude = location.longitude
//                    let createdGroup = Group(id: "",name: name, latitude: latitude, longitude: longitude)
//                    GroupServices.create(createdGroup, completion: { (newGroup) in
//                       //leave empty for now
//                    })
//                }
//            }
//
//        default:
//            print("Unexpected Segue Identifier")
//        }
    }
    
    // FUNCTION TO HANDLE TEXT FIELDS
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
            
        case groupNameTextField:
            groupAddressTextField.becomeFirstResponder()
        default:
            groupAddressTextField.resignFirstResponder()
        }
        return true
    }
}

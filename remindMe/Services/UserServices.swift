//
//  UserServices.swift
//  Linner
//
//  Created by Yves Songolo on 8/21/18.
//  Copyright © 2018 Yves Songolo. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import GoogleSignIn
import FBSDKLoginKit


struct UserServices{
    // method to create new user
    static func create(user: User, completion: @escaping(Any)->()){
        
        let authUser = Auth.auth().currentUser
       
        let ref = Constant.user((authUser?.uid)!) //Database.database().reference().child("Users").child((authUser?.uid)!)
        ref.setValue(user.toDictionary()) { (error, _) in
            if error != nil{
                return completion(error!)
            }
            return completion(user)
        }
}
    // method to retrieve user from firebase
    static func show(completion: @escaping(User?)-> ()){
        let uid = Auth.auth().currentUser?.uid
        let ref = Constant.user(uid!)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists(){
                let user = try! JSONDecoder().decode(User.self, withJSONObject: snapshot.value!)
                return completion(user)
            }
            else{
                return completion(nil)
            }
        }
    }


static func signUp(_ email: String, _ password: String, completion: @escaping (Any)->()){
    Auth.auth().createUser(withEmail: email, password: password) { (authUser, error) in
        guard authUser != nil else {return completion(error!)}
       
        let user = User.init("", (authUser?.user.uid)!, (authUser?.user.email!)!)
        create(user: user, completion: { (newUser) in
            if (newUser as? User) != nil{
                return completion(newUser as! User)
            }
        })
    
        
        show(completion: { (user) in
            return completion(user)
        })
    }
}
}
extension JSONEncoder {
    func encodeJSONObject<T: Encodable>(_ value: T, options opt: JSONSerialization.ReadingOptions = []) throws -> Any {
        let data = try encode(value)
        return try JSONSerialization.jsonObject(with: data, options: opt)
    }
}

extension JSONDecoder {
    func decode<T: Decodable>(_ type: T.Type, withJSONObject object: Any, options opt: JSONSerialization.WritingOptions = []) throws -> T {
        let data = try JSONSerialization.data(withJSONObject: object, options: opt)
        return try decode(T.self, from: data)
    }
}


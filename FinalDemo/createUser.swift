//
//  createUser.swift
//  FinalDemo
//
//  Created by Rebecca Kraft on 4/23/22.
//
import UIKit
import HaishinKit
import HealthKit
import CoreLocation
import AVFoundation
import AVKit
import ReplayKit
import VideoToolbox
import CoreMedia
import Amplify
import AWSCognitoAuthPlugin

class createUser: UIViewController, StreamDelegate {

@IBOutlet weak var userNametext: UITextField!
@IBOutlet weak var passwordtext: UITextField!
@IBOutlet weak var emailtext: UITextField!
@IBOutlet weak var confirmationtext: UITextField!

func signUp(username: String, password: String, email: String) {
    let userAttributes = [AuthUserAttribute(.email, value: email)]
    let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
    Amplify.Auth.signUp(username: username, password: password, options: options) { result in
        switch result {
        case .success(let signUpResult):
            if case let .confirmUser(deliveryDetails, _) = signUpResult.nextStep {
                print("Delivery details \(String(describing: deliveryDetails))")
            } else {
                print("SignUp Complete")
            }
        case .failure(let error):
            print("An error occurred while registering a user \(error)")
        }
    }
}
func confirmSignUp(for username: String, with confirmationCode: String) {
    Amplify.Auth.confirmSignUp(for: username, confirmationCode: confirmationCode) { result in
        switch result {
        case .success:
            print("Confirm signUp succeeded")
        case .failure(let error):
            print("An error occurred while confirming sign up \(error)")
        }
    }
}
@IBAction func createUser(_ sender: Any) {
  //  signUp(username: userNametext.text!, password: passwordtext.text!,email: emailtext.text!)
 
}
@IBAction func confirmCode(_ sender: Any) {
    confirmSignUp(for: userNametext.text!, with: confirmationtext.text!)
}

func fetchCurrentAuthSession() {
    _ = Amplify.Auth.fetchAuthSession { result in
        switch result {
        case .success(let session):
            print("Is user signed in - \(session.isSignedIn)")
        case .failure(let error):
            print("Fetch session failed with error \(error)")
        }
    }
}
}

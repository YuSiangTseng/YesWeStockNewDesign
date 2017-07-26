//
//  LoginViewController.swift
//  AdsInTableView
//
//  Created by Chris Tseng on 28/06/2017.
//  Copyright © 2017 Tseng Yu Siang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import SCLAlertView
import Keychain
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate, UITextFieldDelegate {
    @IBOutlet weak var EmailtextF: UITextField!
    @IBOutlet weak var PaswordtextF: UITextField!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var SignUpbtn: UIButton!
    
    
    let searchURLString = "https://yeswestock.com/listing/search"
    let session = URLSession.shared
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        EmailtextF.delegate = self
        PaswordtextF.delegate = self
        
        
        //FACEBOOK
        if (FBSDKAccessToken.current() != nil)
        {
            let fbAccessToken = FBSDKAccessToken.current().tokenString
            
        }
        
    }
    // MARK: Facebook Delegate Methods
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if ((error) != nil)
        {
            print("Error is: \(error)")
        }
        else if result.isCancelled {
            // Handle cancellations
            print("Cancelled Log in: \(result.isCancelled)")
            
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                print("Logged in: \(result)")
                // Do work
                self.returnUserData()
            }
        }
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    //grab the Users Facebook data. You can call this method anytime after a user has logged in by calling self.returnUserData().
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                print("fetched user: \(result)")
                let dicResult = result as! [String: AnyObject]
                let userName : NSString = dicResult["name"] as! NSString
                print("User Name is: \(userName)")
                
                print("User logged in under facebook and the Access token is... \(FBSDKAccessToken.current().tokenString)")
            }
        })
    }
    //FACEBOOK END <
    
    // MARK: Text Field Actions
    
    @IBAction func LoginAction(_ sender: AnyObject) {
        print("Email text is :\(EmailtextF.text!)")
        print("Password text is :\(PaswordtextF.text!)")
        
        // before passing the string, call to make sure it is properly escaped
        let expectedCharSet = CharacterSet.urlQueryAllowed
        //email and password
        let emailString = EmailtextF.text!.addingPercentEncoding(withAllowedCharacters: expectedCharSet)!
        let passwordString = PaswordtextF.text!.addingPercentEncoding(withAllowedCharacters: expectedCharSet)!
        let providedEmailAddress = EmailtextF.text
        let isEmailAddressValid = isValidEmailAddress(emailAddressString: providedEmailAddress!)
        SVProgressHUD.show(withStatus: "Logging in...")
        // check if something has been written
        if  isEmailAddressValid && emailString != ("") && passwordString != ("") {
            print("Email string is ...\(emailString) password string is ...\(passwordString)")
            // YWS url
            let url = URL(string: "https://yeswestock.com/JSON/user/auth/login")
            
            let Param: Parameters = [
                "email": emailString as AnyObject,
                "password": passwordString as AnyObject
            ]
            Alamofire.request(url!, method: .post, parameters: Param, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { response in
                
                switch response.result{
                case .success(let resultdata):
                    
                    print("Success with JSON: \(resultdata)")
                    print("result text is :\(response.result)")
                    print("request text is :\(response.request!)")
                    print("response text is :\(response)")
                    //JSON response
                    let jsonres = JSON(resultdata)
                    print("JSON Result Data text is :\(jsonres["token"])")
                    if jsonres["success"] == true {
                        SVProgressHUD.dismiss()
                        
                        self.performSegue(withIdentifier: "showTabBar", sender: nil)
                        self.updateLoginStatus(isLogin: true)
                        Keychain.save("\(jsonres["token"])", forKey: "userToken")
                        
                    } else {
                        SVProgressHUD.dismiss()
                        SCLAlertView().showInfo("Unable to login!", subTitle: "Please enter a valid email or password")
                        self.updateLoginStatus(isLogin: false)
                    }
                    
                    //How many Http headers?
                    
                    let json = (response.request?.allHTTPHeaderFields?.count)
                    print("Header Count is :\(json!)")
                    //print all headers
                    
                    if let cookies = response.response?.allHeaderFields["Set-Cookie"] as? String{
                        print(cookies)
                    }
                    
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    SCLAlertView().showInfo("Unable to login!" + "\(error)", subTitle: "Please try again")
                    self.updateLoginStatus(isLogin: false)
                }
            }
        }
    }
    
    func updateLoginStatus(isLogin: Bool) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(isLogin, forKey: "isLogin")
        userDefaults.synchronize()
    }
    
    @IBAction func SingUpAction(_ sender: AnyObject) {
        print("Email text is :\(EmailtextF.text!)")
        print("Password text is :\(PaswordtextF.text!)")
    }
    @IBAction func forgotPasswordButton(_ sender: Any) {
        let forgotPasswordController = SCLAlertView()
        forgotPasswordController.addTextField("Email address")
        forgotPasswordController.showInfo("Forgot your password?", subTitle: "Please enter your email address so your password can be reset", closeButtonTitle: "Send email", duration: 30, colorStyle: 0x419493, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: .topToBottom)
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //hide keyboard
        textField.resignFirstResponder()
        print("Hide Keyboard")
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Check if email address entered is of the valid format
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
    
}

extension LoginViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

}

//
//  LoginViewController.swift
//  Tasky
//
//  Created by Tej Shah on 2020-08-29.
//  Copyright © 2020 GeekMindz Solutions LLP. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SwiftyJSON

class LoginViewController: UIViewController, AppAPIServicesDelegate {

    @IBOutlet weak var userType_Switch: UISwitch!
    @IBOutlet weak var email_TextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var password_TextField: SkyFloatingLabelTextFieldWithIcon!
    
    var selectedUserType = AppConstants.userType.user
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - UI Config
    func configureUI() {
        self.userType_Switch.layer.cornerRadius = 12.5
    }

    // MARK: - Button Action
    @IBAction func userTypeChanged_Action(_ sender: UISwitch) {
        if sender.isOn {
            selectedUserType = AppConstants.userType.user
        } else {
            selectedUserType = AppConstants.userType.admin
        }
    }
    @IBAction func login_Action(_ sender: Any) {
        self.view.endEditing(true)
        if self.verifyMandatoryDetails() {
            self.call_Signin()
        }
    }
    
    //MARK: - Data Validation
    func verifyMandatoryDetails() -> Bool {
        var localBoolValue : Bool = false
        if (email_TextField.text?.count)! <= 0 {
            AppHelper.sharedInstance.showAutoDismissAlert(delegate: self, alertContentText: "Please enter email id", time: AppConstants.alertDismissTime.shortTime)
            
            return localBoolValue
        } else  if !AppHelper.sharedInstance.isValidEmail(emailString: email_TextField.text!) {
            AppHelper.sharedInstance.showAutoDismissAlert(delegate: self, alertContentText: "Please enter valid email id", time: AppConstants.alertDismissTime.shortTime)

            return localBoolValue
        } else  if (password_TextField.text?.count)! <= 0 {
            AppHelper.sharedInstance.showAutoDismissAlert(delegate: self, alertContentText: "Please enter password", time: AppConstants.alertDismissTime.shortTime)

            return localBoolValue
        } else {
            localBoolValue = true
            return localBoolValue
        }
    }
    
    //MARK: - Service call
    func call_Signin() {
        let apiObj = AppAPIServices.sharedInstance
        AppLoader.sharedInstance.startLoader()
        apiObj.sendPostRequest(baseURL: AppURLConstants.sharedInstance.signin, dictParameters: AppRequestParam.sharedInstance.param_Signin(email: self.email_TextField.text!, password: self.password_TextField.text!, isAdmin: self.selectedUserType == AppConstants.userType.admin ? true : false), apiServicesDelegate: self, requestID: AppAPIServices.sharedInstance.REQ_SIGNIN)
    }
    // MARK: - API Response
    func apiResponse(response : JSON, reqID: Int) {
        if(reqID == AppAPIServices.sharedInstance.REQ_SIGNIN) {
            let user = User(fromJson: response)
            if self.selectedUserType == AppConstants.userType.admin {
                user.role = "admin"
            } else {
                user.role = "user"
            }
            if user.token != "" {
                AppHelper.sharedInstance.savePreferences(user: user)
                AppHelper.sharedInstance.setRootViewController(identifier: "StoryListNavigationControoler")
            } else {
                AppHelper.sharedInstance.showAutoDismissAlert(delegate: self, alertContentText: "Something went wrong please try again.", time: AppConstants.alertDismissTime.shortTime)
            }
        }
       AppLoader.sharedInstance.stopLoader()
    }

    func apiError(error : NSError, reqID : Int) {
        AppLoader.sharedInstance.stopLoader()
        AppHelper.sharedInstance.showAutoDismissAlert(delegate: self, alertContentText: error.localizedDescription, time: AppConstants.alertDismissTime.shortTime)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

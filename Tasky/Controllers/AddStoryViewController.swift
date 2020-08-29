//
//  AddStoryViewController.swift
//  Tasky
//
//  Created by Tej Shah on 2020-08-29.
//  Copyright © 2020 GeekMindz Solutions LLP. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SwiftyJSON

class AddStoryViewController: UIViewController, UITextViewDelegate, AppAPIServicesDelegate {

    @IBOutlet weak var inner_View: UIView!
    @IBOutlet weak var summary_TextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var description_TextView: UITextView!
    @IBOutlet weak var type_TextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var complexity_TextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var estimateTime_TextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var cost_TextField: SkyFloatingLabelTextFieldWithIcon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - UI Config
    func configureUI() {
        AppHelper.sharedInstance.addCornerRadiusWithOpacity(View: self.inner_View, radius: 4, shadowRadius: 4, opacity: 1, shadowOffset:  .zero, shadowColor: UIColor.black.withAlphaComponent(0.5))
        self.description_TextView.text = "Enter description"
        self.description_TextView.textColor = UIColor.lightGray
        self.description_TextView.selectedTextRange = self.description_TextView.textRange(from: self.description_TextView.beginningOfDocument, to: self.description_TextView.beginningOfDocument)
        self.cost_TextField.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
    }
    
    @objc func myTextFieldDidChange(_ textField: UITextField) {
        if let amountString = textField.text?.currencyTextFieldFormatting() {
            textField.text = amountString
        }
    }
    
    // MARK: - Button Action
    @IBAction func selectType_Action(_ sender: Any) {
        self.view.endEditing(true)
        let list = ["enhancement","bugfix", "development", "QA"]
        AppHelper.sharedInstance.presentPopUpList(selfController: self, list: list, sourceView: self.type_TextField, width: Int(self.type_TextField.frame.size.width), direction: .up) { (value) in
            self.type_TextField.text = value
        }
    }
    @IBAction func selectComplexity_Action(_ sender: Any) {
        self.view.endEditing(true)
        let list = ["Low","Mid", "High"]
        AppHelper.sharedInstance.presentPopUpList(selfController: self, list: list, sourceView: self.complexity_TextField, width: Int(self.complexity_TextField.frame.size.width), direction: .up) { (value) in
            self.complexity_TextField.text = value
        }
    }
    @IBAction func submit_Action(_ sender: Any) {
        self.view.endEditing(true)
        if self.verifyMandatoryDetails() {
            self.call_CreateStory()
        }
    }
    
    //MARK: - Data Validation
    func verifyMandatoryDetails() -> Bool {
        var localBoolValue : Bool = false
        if (self.summary_TextField.text?.count)! <= 0 {
            AppHelper.sharedInstance.showAutoDismissAlert(delegate: self, alertContentText: "Please enter summary", time: AppConstants.alertDismissTime.shortTime)
            
            return localBoolValue
        } else if (self.description_TextView.text?.count)! <= 0 {
                   AppHelper.sharedInstance.showAutoDismissAlert(delegate: self, alertContentText: "Please enter description", time: AppConstants.alertDismissTime.shortTime)
                   
                   return localBoolValue
        } else if (self.type_TextField.text?.count)! <= 0 {
                   AppHelper.sharedInstance.showAutoDismissAlert(delegate: self, alertContentText: "Please select type", time: AppConstants.alertDismissTime.shortTime)
                   
                   return localBoolValue
        } else if (self.complexity_TextField.text?.count)! <= 0 {
                   AppHelper.sharedInstance.showAutoDismissAlert(delegate: self, alertContentText: "Please select complexity", time: AppConstants.alertDismissTime.shortTime)
                   
                   return localBoolValue
        } else if (self.estimateTime_TextField.text?.count)! <= 0 {
                   AppHelper.sharedInstance.showAutoDismissAlert(delegate: self, alertContentText: "Please enter estimate time", time: AppConstants.alertDismissTime.shortTime)
                   
                   return localBoolValue
        } else if (self.cost_TextField.text?.count)! <= 0 {
                   AppHelper.sharedInstance.showAutoDismissAlert(delegate: self, alertContentText: "Please enter cost", time: AppConstants.alertDismissTime.shortTime)
                   
                   return localBoolValue
        }else {
            localBoolValue = true
            return localBoolValue
        }
    }
    
    //MARK: UITextViewDelegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText = textView.text as NSString
        let updatedText = currentText.replacingCharacters(in: range, with: text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            if textView == self.description_TextView {
                 textView.text = "Enter description"
            }
            textView.textColor = UIColor.lightGray
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            return false
        } else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, clear
            // the text view and set its color to black to prepare for
            // the user's entry
            textView.text = nil
            textView.textColor = UIColor.black
        }
        return true
    }
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
    
    //MARK: - Service call
    func call_CreateStory() {
        let apiObj = AppAPIServices.sharedInstance
        AppLoader.sharedInstance.startLoader()
        apiObj.sendPostRequestWithAccessToken(baseURL: AppURLConstants.sharedInstance.stories, dictParameters: AppRequestParam.sharedInstance.param_CreateStory(summary: self.summary_TextField.text!, description: self.description_TextView.text!, type: self.type_TextField.text!, complexity: self.complexity_TextField.text!, estimatedHrs: self.estimateTime_TextField.text!, cost: self.cost_TextField.text!), accessToken: AppPreferences.sharedInstance.pref_token!, apiServicesDelegate: self, requestID: AppAPIServices.sharedInstance.REQ_CREATE_STORIES)
    }
    
    // MARK: - API Response
    func apiResponse(response : JSON, reqID: Int) {
        if(reqID == AppAPIServices.sharedInstance.REQ_CREATE_STORIES) {
            let story = Stories(fromJson: response)
            if story.id != 0 {
                NotificationCenter.default.post(name: Notification.Name(AppConstants.notificationObserver.reloadStoryList), object: nil)
                AppHelper.sharedInstance.showAutoDismissAlert(delegate: self, alertContentText: "Story has created successfully.", time: AppConstants.alertDismissTime.shortTime) {
                    self.navigationController?.popViewController(animated: true)
                }
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

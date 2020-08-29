//
//  ReviewStoryViewController.swift
//  Tasky
//
//  Created by Tej Shah on 2020-08-29.
//  Copyright © 2020 GeekMindz Solutions LLP. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SwiftyJSON

class ReviewStoryViewController: UIViewController, AppAPIServicesDelegate {

    @IBOutlet weak var inner_View: UIView!
    @IBOutlet weak var summary_TextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var description_TextView: UITextView!
    @IBOutlet weak var type_TextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var complexity_TextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var estimateTime_TextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var cost_TextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var status_TextField: SkyFloatingLabelTextFieldWithIcon!
    
    var story: Stories!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.bindData()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - UI Config
    func configureUI() {
       AppHelper.sharedInstance.addCornerRadiusWithOpacity(View: self.inner_View, radius: 4, shadowRadius: 4, opacity: 1, shadowOffset:  .zero, shadowColor: UIColor.black.withAlphaComponent(0.5))
    }
    
    // MARK: - Bind Data
    func bindData() {
        if story != nil {
            self.inner_View.isHidden = false
            self.summary_TextField.text = story.summary ?? " - -"
            self.description_TextView.text = story.descriptionField ?? " - -"
            self.type_TextField.text = story.type ?? " - -"
            self.complexity_TextField.text = story.complexity ?? " - -"
            self.estimateTime_TextField.text = "\(story.estimatedHrs ?? 0)"
            self.cost_TextField.text = "\(story.cost ?? 0)"
            self.status_TextField.text = " - -"
        } else {
            AppHelper.sharedInstance.showAutoDismissAlert(delegate: self, alertContentText: "Something went wrong please try again.", time: AppConstants.alertDismissTime.shortTime) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // MARK: - Button Action
    @IBAction func reject_Action(_ sender: Any) {
        self.call_RejectStory()
    }
    @IBAction func accept_Action(_ sender: Any) {
        self.call_AcceptStory()
    }
    
    //MARK: - Service call
    func call_RejectStory() {
        let apiObj = AppAPIServices.sharedInstance
        AppLoader.sharedInstance.startLoader()
        apiObj.sendPutRequestWithAccessToken(baseURL: "\(AppURLConstants.sharedInstance.stories)/\(story.id ?? 0)/rejected", dictParameters: [:], accessToken: AppPreferences.sharedInstance.pref_token!, apiServicesDelegate: self, requestID: AppAPIServices.sharedInstance.REQ_REJECT_STORIES)
    }
    func call_AcceptStory() {
        let apiObj = AppAPIServices.sharedInstance
        AppLoader.sharedInstance.startLoader()
        apiObj.sendPutRequestWithAccessToken(baseURL: "\(AppURLConstants.sharedInstance.stories)/\(story.id ?? 0)/accepted", dictParameters: [:], accessToken: AppPreferences.sharedInstance.pref_token!, apiServicesDelegate: self, requestID: AppAPIServices.sharedInstance.REQ_ACCEPT_STORIES)
    }
    
    // MARK: - API Response
    func apiResponse(response : JSON, reqID: Int) {
        if(reqID == AppAPIServices.sharedInstance.REQ_REJECT_STORIES) {
            let story = Stories(fromJson: response)
            if story.id != 0 {
                NotificationCenter.default.post(name: Notification.Name(AppConstants.notificationObserver.reloadStoryList), object: nil)
                AppHelper.sharedInstance.showAutoDismissAlert(delegate: self, alertContentText: "Story has rejected successfully.", time: AppConstants.alertDismissTime.shortTime) {
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                AppHelper.sharedInstance.showAutoDismissAlert(delegate: self, alertContentText: "Something went wrong please try again.", time: AppConstants.alertDismissTime.shortTime)
            }
        } else if(reqID == AppAPIServices.sharedInstance.REQ_ACCEPT_STORIES) {
            let story = Stories(fromJson: response)
            if story.id != 0 {
                NotificationCenter.default.post(name: Notification.Name(AppConstants.notificationObserver.reloadStoryList), object: nil)
                AppHelper.sharedInstance.showAutoDismissAlert(delegate: self, alertContentText: "Story has accepted successfully.", time: AppConstants.alertDismissTime.shortTime) {
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

//
//  StoryListViewController.swift
//  Tasky
//
//  Created by Tej Shah on 2020-08-29.
//  Copyright © 2020 GeekMindz Solutions LLP. All rights reserved.
//

import UIKit
import SwiftyJSON

class StoryListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AppAPIServicesDelegate {

    @IBOutlet weak var storyList_TableView: UITableView!
    @IBOutlet weak var add_BarButtonItem: UIBarButtonItem!
    
    var stories = [Stories]()
    var isFirstTime = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.call_GetStories()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - UI Config
    func configureUI() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.call_GetStories), name: Notification.Name(AppConstants.notificationObserver.reloadStoryList), object: nil)
        self.storyList_TableView.tableFooterView = UIView()
        self.storyList_TableView.rowHeight = UITableView.automaticDimension
        self.storyList_TableView.estimatedRowHeight = 70.0
        if AppPreferences.sharedInstance.pref_role == AppConstants.userType.admin {
            self.add_BarButtonItem.isEnabled = false
            self.add_BarButtonItem.tintColor = .clear
        }
    }
    
    //MARK: Button Action
    @IBAction func signOut_Action(_ sender: Any) {
        let alertController = UIAlertController(title: "", message: "Are you sure you want to signout?", preferredStyle: .alert)
        
         let signOutAction = UIAlertAction(title: "Signout", style: .destructive) { (action) in
             AppHelper.sharedInstance.deletePreferences()
             AppHelper.sharedInstance.setRootViewController(identifier: "SigninNavigationControoler")
         }
         let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in }
         
         alertController.addAction(signOutAction)
         alertController.addAction(cancelAction)
         self.present(alertController, animated: true)
    }
    
    //MARK: UITableView Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isFirstTime {
            return 0
        }
        if stories.count == 0 && !self.isFirstTime {
            return 1
        }
        else
        {
            return stories.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if stories.count > 0 {
            if AppPreferences.sharedInstance.pref_role == AppConstants.userType.admin {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AdminStoryListCell", for: indexPath as IndexPath) as! StoryListTableViewCell
                let story = self.stories[indexPath.row]
                cell.id_Label.attributedText = AppHelper.sharedInstance.addBoldTextColor(fullString: "ID : \(story.id ?? 0)" as NSString, boldPartsOfString: ["ID :"], font: UIFont.systemFont(ofSize: 16), boldFont: UIFont.boldSystemFont(ofSize: 16), color: .white)
                cell.summary_Label.attributedText = AppHelper.sharedInstance.addBoldTextColor(fullString: "Summary : \(story.summary ?? "- -")" as NSString, boldPartsOfString: ["Summary :"], font: UIFont.systemFont(ofSize: 16), boldFont: UIFont.boldSystemFont(ofSize: 16), color: .white)
                cell.type_Label.attributedText = AppHelper.sharedInstance.addBoldTextColor(fullString: "Type : \(story.type ?? "- -")" as NSString, boldPartsOfString: ["Type :"], font: UIFont.systemFont(ofSize: 16), boldFont: UIFont.boldSystemFont(ofSize: 16), color: .white)
                cell.complexity_Label.attributedText = AppHelper.sharedInstance.addBoldTextColor(fullString: "Complexity : \(story.complexity ?? "- -")" as NSString, boldPartsOfString: ["Complexity :"], font: UIFont.systemFont(ofSize: 16), boldFont: UIFont.boldSystemFont(ofSize: 16), color: .white)
                cell.estimateTime_Label.attributedText = AppHelper.sharedInstance.addBoldTextColor(fullString: "Estimated Time : \(story.estimatedHrs ?? 0) \(story.estimatedHrs > 1 ? "Hours" : "Hour")" as NSString, boldPartsOfString: ["Estimated Time :"], font: UIFont.systemFont(ofSize: 16), boldFont: UIFont.boldSystemFont(ofSize: 16), color: .white)
                cell.cost_Label.attributedText = AppHelper.sharedInstance.addBoldTextColor(fullString: "Cost : $ \(story.cost ?? 0)" as NSString, boldPartsOfString: ["Cost :"], font: UIFont.systemFont(ofSize: 16), boldFont: UIFont.boldSystemFont(ofSize: 16), color: .white)
                cell.description_Label.attributedText = AppHelper.sharedInstance.addBoldTextColor(fullString: "Description : \(story.descriptionField ?? "- -")" as NSString, boldPartsOfString: ["Description :"], font: UIFont.systemFont(ofSize: 16), boldFont: UIFont.boldSystemFont(ofSize: 15), color: .white)
                if story.status == "accepted" {
                    cell.backgroundColor = UIColor.init(hex: "34A859")
                } else if story.status == "rejected" {
                    cell.backgroundColor = UIColor.init(hex: "C83B30")
                } else {
                    cell.backgroundColor = .black
                }
                tableView.separatorColor = .white
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "StoryListCell", for: indexPath as IndexPath) as! StoryListTableViewCell
                let story = self.stories[indexPath.row]
                cell.id_Label.attributedText = AppHelper.sharedInstance.addBoldTextColor(fullString: "ID : \(story.id ?? 0)" as NSString, boldPartsOfString: ["ID :"], font: UIFont.systemFont(ofSize: 16), boldFont: UIFont.boldSystemFont(ofSize: 16), color: .black)
                cell.summary_Label.attributedText = AppHelper.sharedInstance.addBoldTextColor(fullString: "Summary : \(story.summary ?? "- -")" as NSString, boldPartsOfString: ["Summary :"], font: UIFont.systemFont(ofSize: 16), boldFont: UIFont.boldSystemFont(ofSize: 16), color: .black)
                cell.type_Label.attributedText = AppHelper.sharedInstance.addBoldTextColor(fullString: "Type : \(story.type ?? "- -")" as NSString, boldPartsOfString: ["Type :"], font: UIFont.systemFont(ofSize: 16), boldFont: UIFont.boldSystemFont(ofSize: 16), color: .black)
                cell.complexity_Label.attributedText = AppHelper.sharedInstance.addBoldTextColor(fullString: "Complexity : \(story.complexity ?? "- -")" as NSString, boldPartsOfString: ["Complexity :"], font: UIFont.systemFont(ofSize: 16), boldFont: UIFont.boldSystemFont(ofSize: 16), color: .black)
                cell.estimateTime_Label.attributedText = AppHelper.sharedInstance.addBoldTextColor(fullString: "Estimated Time : \(story.estimatedHrs ?? 0) \(story.estimatedHrs > 1 ? "Hours" : "Hour")" as NSString, boldPartsOfString: ["Estimated Time :"], font: UIFont.systemFont(ofSize: 16), boldFont: UIFont.boldSystemFont(ofSize: 16), color: .black)
                cell.cost_Label.attributedText = AppHelper.sharedInstance.addBoldTextColor(fullString: "Cost : $ \(story.cost ?? 0)" as NSString, boldPartsOfString: ["Cost :"], font: UIFont.systemFont(ofSize: 16), boldFont: UIFont.boldSystemFont(ofSize: 16), color: .black)
                cell.description_Label.attributedText = AppHelper.sharedInstance.addBoldTextColor(fullString: "Description : \(story.descriptionField ?? "- -")" as NSString, boldPartsOfString: ["Description :"], font: UIFont.systemFont(ofSize: 16), boldFont: UIFont.boldSystemFont(ofSize: 15), color: .black)
                tableView.separatorColor = .black
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoStoryCell", for: indexPath as IndexPath)
            tableView.separatorColor = .black
            return cell
        }
    }
    
    //MARK: UITableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if AppPreferences.sharedInstance.pref_role == AppConstants.userType.admin && self.stories.count > 0 {
            self.performSegue(withIdentifier: "ReviewStory", sender: self.stories[indexPath.row])
        }
    }
    
    //MARK: - Service call
    @objc func call_GetStories() {
        let apiObj = AppAPIServices.sharedInstance
        AppLoader.sharedInstance.startLoader()
        apiObj.sendGetRequestWithAccessToken(baseURL: AppURLConstants.sharedInstance.stories, accessToken: AppPreferences.sharedInstance.pref_token!, apiServicesDelegate: self, requestID: AppAPIServices.sharedInstance.REQ_STORIES)
    }

    // MARK: - API Response
    func apiResponse(response : JSON, reqID: Int) {
        if(reqID == AppAPIServices.sharedInstance.REQ_STORIES) {
            let dataArr = response.arrayValue
            var tempStories = [Stories]()
            for data in dataArr {
                tempStories.append(Stories(fromJson: data))
            }
            self.stories = tempStories
            if self.isFirstTime {
                self.isFirstTime = false
            }
            self.storyList_TableView.reloadData()
        }
        AppLoader.sharedInstance.stopLoader()
    }
    
    func apiError(error : NSError, reqID : Int) {
        AppLoader.sharedInstance.stopLoader()
        AppHelper.sharedInstance.showAutoDismissAlert(delegate: self, alertContentText: error.localizedDescription, time: AppConstants.alertDismissTime.shortTime)
        if self.isFirstTime {
            self.isFirstTime = false
        }
        self.storyList_TableView.reloadData()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ReviewStory" {
            let controller = segue.destination as! ReviewStoryViewController
            if let story = sender as? Stories {
                controller.story = story
            }
        }
    }
    
    // MARK: - Deintit Controller
    deinit {
       NotificationCenter.default.removeObserver(self)
    }
}

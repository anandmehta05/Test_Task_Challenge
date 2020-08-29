//
//  AppHelper.swift
//  HousePark
//
//  Created by Kaushik on 12/11/19.
//  Copyright © 2019 GeekMindz Solutions LLP. All rights reserved.
//

import UIKit

class AppHelper: NSObject {

    static var sharedInstance = AppHelper()
    
    //MARK: - Set Root View Controller
    func setRootViewController(identifier: String)
    {
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nav = mainStoryBoard.instantiateViewController(withIdentifier: identifier) as! UINavigationController
        appDelegate.window?.rootViewController = nil
        appDelegate.window?.rootViewController = nav
    }
    
    
    //MARK: - Alerts
    func showAlert(delegate : UIViewController, alertContentText : String){

        let myAlertController = UIAlertController(title: "Message", message: alertContentText, preferredStyle: UIAlertController.Style.alert)

        myAlertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))

        delegate.present(myAlertController, animated: true, completion: nil)

    }
    
    //MARK: - Auto Alerts
    func showAutoDismissAlert(delegate : UIViewController, alertContentText : String, time : Double){
        
        let myAlertController = UIAlertController(title: "", message: alertContentText, preferredStyle: UIAlertController.Style.alert)
        
        delegate.present(myAlertController, animated: true, completion: nil)
        
        let when = DispatchTime.now() + time
        DispatchQueue.main.asyncAfter(deadline: when)
        {
            myAlertController.dismiss(animated: true, completion: nil)
        }
        
    }
    
    //MARK: - Auto Alerts with Completion Handler
    func showAutoDismissAlert(delegate : UIViewController, alertContentText : String, time : Double, completionHandler:@escaping () -> Void){
        
        let myAlertController = UIAlertController(title: "", message: alertContentText, preferredStyle: UIAlertController.Style.alert)
        
        delegate.present(myAlertController, animated: true, completion: nil)
        
        let when = DispatchTime.now() + time
        DispatchQueue.main.asyncAfter(deadline: when)
        {
            myAlertController.dismiss(animated: true, completion: nil)
            completionHandler()
        }
        
    }
    
    //MARK: - Save Preferences
    func savePreferences(user: User) {
        preferences.set(user.token, forKey: AppConstants.preferences.token)
        AppPreferences.sharedInstance.pref_token =  preferences.object(forKey: AppConstants.preferences.token) as? String
        
        preferences.set(user.id, forKey: AppConstants.preferences.id)
        AppPreferences.sharedInstance.pref_id =  preferences.object(forKey: AppConstants.preferences.id) as? Int
        
        preferences.set(user.firstName, forKey: AppConstants.preferences.firstName)
        AppPreferences.sharedInstance.pref_firstName =  preferences.object(forKey: AppConstants.preferences.firstName) as? String
        
        preferences.set(user.role, forKey: AppConstants.preferences.role)
        AppPreferences.sharedInstance.pref_role =  preferences.object(forKey: AppConstants.preferences.role) as? String
        
        preferences.set(user.lastName, forKey: AppConstants.preferences.lastName)
        AppPreferences.sharedInstance.pref_lastName =  preferences.object(forKey: AppConstants.preferences.lastName) as? String
    }
    
    //MARK: - Delete Preferences
    func deletePreferences() {
        preferences.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        preferences.synchronize()
        self.updatePreferenceToNil()
    }
    
    
    //MARK: - Update Preference
    func updatePreferenceToNil() {
        AppPreferences.sharedInstance.pref_token =  preferences.object(forKey: AppConstants.preferences.token) as? String
        AppPreferences.sharedInstance.pref_id =  preferences.object(forKey: AppConstants.preferences.id) as? Int
        AppPreferences.sharedInstance.pref_firstName =  preferences.object(forKey: AppConstants.preferences.firstName) as? String
        AppPreferences.sharedInstance.pref_role =  preferences.object(forKey: AppConstants.preferences.role) as? String
        AppPreferences.sharedInstance.pref_lastName =  preferences.object(forKey: AppConstants.preferences.lastName) as? String
    }
    
    //MARK: - Check is Login
    func isLogedIn() -> Bool
    {
        if (((AppPreferences.sharedInstance.pref_token) != nil) && ((AppPreferences.sharedInstance.pref_token!.count) > 0))
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    //MARK: - Email validation functions
    func isValidEmail(emailString:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailString)
    }
    
    //MARK: - Add Bold String And Color
    func addBoldTextColor(fullString: NSString, boldPartsOfString: Array<NSString>, font: UIFont!, boldFont: UIFont!, color : UIColor!) -> NSAttributedString {
        let nonBoldFontAttribute = [NSAttributedString.Key.font:font!]
        let boldFontAttribute = [NSAttributedString.Key.font:boldFont!]
        let boldString = NSMutableAttributedString(string: fullString as String, attributes:nonBoldFontAttribute)
        for i in 0 ..< boldPartsOfString.count {
            boldString.addAttributes(boldFontAttribute, range: fullString.range(of: boldPartsOfString[i] as String))
            boldString.addAttribute(NSAttributedString.Key.foregroundColor, value: color!, range: fullString.range(of: boldPartsOfString[i] as String))
        }
        return boldString
    }
    
    //MARK: - Present Popup List
    func presentPopUpList(selfController: UIViewController, list: [String], sourceView: UIView, width: Int, direction: UIPopoverArrowDirection = UIPopoverArrowDirection(rawValue:0), completion: @escaping (String) -> ()) {
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = mainStoryBoard.instantiateViewController(withIdentifier: "PopupListTableViewController") as! PopupListTableViewController
        controller.modalPresentationStyle = .popover
        controller.listArray = list
        var height = list.count * 40
        if list.count > 6 {
            height = 6 * 40
        }
        controller.preferredContentSize = CGSize(width: width, height: height)
        let presentationViewController = controller.popoverPresentationController
        presentationViewController?.permittedArrowDirections = direction
        presentationViewController?.backgroundColor = .white
        presentationViewController?.sourceView = sourceView
        presentationViewController?.sourceRect = CGRect(x: sourceView.bounds.origin.x, y: sourceView.bounds.origin.y, width: sourceView.frame.size.width, height: sourceView.frame.size.height)
        presentationViewController?.delegate = self
        controller.completionHandler = {(valueSelected : String?) in
            if let valueSelected = valueSelected {
                completion(valueSelected)
            }
        }
        selfController.present(controller, animated: true, completion: nil)
    }
    
    //MARK: - Add corner radius View
    func addCornerRadiusWithOpacity(View: UIView, radius: CGFloat, shadowRadius: CGFloat, opacity: Float,shadowOffset:CGSize, shadowColor:UIColor) {
        View.layer.shadowOffset = shadowOffset
        View.layer.shadowOpacity = opacity
        View.layer.cornerRadius = radius
        View.layer.shadowRadius = shadowRadius
        View.layer.shadowColor = shadowColor.cgColor
        View.clipsToBounds = true
        View.layer.masksToBounds = false
    }
}

extension AppHelper: UIPopoverPresentationControllerDelegate
{
    // MARK: - UIPopoverPresentationControllerDelegate
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle
    {
        return UIModalPresentationStyle.none
    }
    
    func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController?
    {
        return UINavigationController(rootViewController: controller.presentedViewController)
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        
        print("Controller did dismiss popover.")
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        
        print("Controller should dismiss popover.")
        
        return true
    }
}

//
//  NavigationExtension.swift
//  LeagueMobileChallenge
//
//  Created by Jonathan Ngabo on 2021-02-04.
//  Copyright © 2021 Kelvin Lau. All rights reserved.
//

import UIKit

/*
 This enumeration has for goal to list out every single viewController that
 we might have in the project, in order to ease the navigation between them and keep track of them.
 */
public enum ViewControllerIdentifiers : String {
    case PostTableViewController = "PostTableViewController"
    case UserDetailsViewController = "UserDetailsViewController"
}

public enum StoryboardIdenfiers : String {
    case Home = "Home"
    case UserDetail = "UserDetail"
}


extension UIViewController{
    
    public func navigateTo(storyboard : StoryboardIdenfiers, viewControllerIdentifier : ViewControllerIdentifiers? = nil) -> UIViewController? {
        var viewController : UIViewController?
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        if let identifier = viewControllerIdentifier {
            viewController = storyboard.instantiateViewController(withIdentifier: identifier.rawValue)
        }else{
            viewController = storyboard.instantiateInitialViewController()
        }
        return viewController
    }
}

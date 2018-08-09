//
//  UIStoryboard+XT.swift
//  IliadProd
//
//  Created by Luigi Aiello on 08/08/18.
//  Copyright © 2018 Luigi Aiello. All rights reserved.
//

import UIKit

extension UIStoryboard {
    /**
     Returns an instance of the view controller identified by `identifier` and defined in the specified storyboard.

     - parameter identifier: the identifier of the `UIViewController` that should be instantiated and defined in the storyboard
     - parameter identifier: the name of the storyboard that should include the view controller
     - returns: an instance of `UIViewController`
     */
    class func viewController(withIdentifier identifier: String, fromStoryboardNamed storyboardName: String) -> UIViewController {
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    /**
     Returns the initial view controller defined in the specified storyboard.
     
     - parameter identifier: the name of the storyboard that should include the view controller
     - returns:
       - an instance of `UIViewController`
       - `nil` if the storyboard does not define an initial view controller
     */
    class func initialViewController(withStoryboardNamed storyboardName: String) -> UIViewController? {
        return UIStoryboard(name: storyboardName, bundle: nil).instantiateInitialViewController()
    }
}

precedencegroup Instantiating { higherThan: CastingPrecedence }
infix operator <%> : Instantiating
/**
 Returns an instance of the view controller identified by `identifier` and defined in the specified storyboard.
 
 - parameter identifier: the identifier of the `UIViewController` that should be instantiated and defined in the storyboard
 - parameter identifier: the name of the storyboard that should include the view controller
 - returns: an instance of `UIViewController`
 */
func <%> (storyboardName: String, identifier: String) -> UIViewController {
    return UIStoryboard.viewController(withIdentifier: identifier, fromStoryboardNamed: storyboardName)
}

postfix operator <%>?
/**
 Returns the initial view controller defined in the specified storyboard.
 
 - parameter identifier: the name of the storyboard that should include the view controller
 - returns:
 - an instance of `UIViewController`
 - `nil` if the storyboard does not define an initial view controller
 */
postfix func <%>? (storyboardName: String) -> UIViewController? {
    return UIStoryboard.initialViewController(withStoryboardNamed: storyboardName)
}

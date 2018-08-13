//
//  Typealiases.swift
//  My-Simple-Instagram
//
//  Created by Luigi Aiello on 30/10/17.
//  Copyright © 2017 Luigi Aiello. All rights reserved.
//

import Foundation
import SwiftyJSON
import Moya

typealias VoidHandler = () -> Void
typealias SuccessHandler = (_ success: Bool) -> Void
typealias RefreshTokenHandler = (_ token: String?, _ success: Bool) -> Void
typealias TextFieldDidChange = (_ newString: String?) -> Void
typealias SwitchDidChange = (_ newValue: Bool?) -> Void
typealias JsonArraySuccessHandler = (_ json: [JSON]?) -> Void
typealias JsonSuccessHandler = (_ json: JSON?) -> Void
typealias TagDidSelected = (_ newString: String) -> Void
typealias UnreadMessageHandler = (_ success: Bool, _ badgeUnread: Int?) -> Void

typealias ResponseHandler = (_ response: Response?) -> Void
typealias OptionHandler = (_ key: String?, _ isOn: Bool) -> Void

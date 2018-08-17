//
//  AuthenticationErrors.swift
//  iOSAuthentication
//
//  Copyright (c) 2018 Luigi Aiello
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import LocalAuthentication

/// Authentication Errors
public enum AuthenticationError {
    
    case failed
    case appCancel
    case invalidContext
    case notInteractive
    case passcodeNotSet
    case systemCancel
    case userCancel
    case userFallback
    case biometryNotAvailable
    case biometryLockout
    case biometryNotEnrolled
    case touchIDNotAvailable
    case touchIDLockout
    case touchIDNotEnrolled
    case unkown

    public static func `init`(error: LAError) -> AuthenticationError {
        
        let code = Int32(error.errorCode)
        switch code {
        case kLAErrorAuthenticationFailed:
            return failed
        case kLAErrorAppCancel:
            return appCancel
        case kLAErrorInvalidContext:
            return invalidContext
        case kLAErrorNotInteractive:
            return notInteractive
        case kLAErrorPasscodeNotSet:
            return passcodeNotSet
        case kLAErrorSystemCancel:
            return systemCancel
        case kLAErrorUserCancel:
            return userCancel
        case kLAErrorUserFallback:
            return userFallback
        default:
           return AuthenticationError.evaluatePolicyFailErrorMessageForLA(errorCode: code)
        }
    }
    
    static func evaluatePolicyFailErrorMessageForLA(errorCode: Int32) -> AuthenticationError {
        if #available(iOS 11.0, macOS 10.13, *) {
            switch errorCode {
            case kLAErrorBiometryNotAvailable:
                return .biometryNotAvailable
            case kLAErrorBiometryLockout:
                return .biometryLockout
            case kLAErrorBiometryNotEnrolled:
                return .biometryNotEnrolled
            default:
                return .unkown
            }
        } else {
            switch errorCode {
            case kLAErrorTouchIDNotAvailable:
                return .touchIDNotAvailable
            case kLAErrorTouchIDLockout:
                return .touchIDLockout
            case kLAErrorTouchIDNotEnrolled:
                return .touchIDNotEnrolled
            default:
                return .unkown
            }
        }
    }
}

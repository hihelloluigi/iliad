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
@objc public enum AuthenticationError: Int {
    
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

    public init(error: LAError) {
        let code = Int32(error.errorCode)
        switch code {
        case kLAErrorAuthenticationFailed:
            self = .failed
        case kLAErrorAppCancel:
            self = .appCancel
        case kLAErrorInvalidContext:
            self = .invalidContext
        case kLAErrorNotInteractive:
            self = .notInteractive
        case kLAErrorPasscodeNotSet:
            self = .passcodeNotSet
        case kLAErrorSystemCancel:
            self = .systemCancel
        case kLAErrorUserCancel:
            self = .userCancel
        case kLAErrorUserFallback:
            self = .userFallback
        default:
            self = AuthenticationError.evaluatePolicyFailErrorMessageForLA(errorCode: code)
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

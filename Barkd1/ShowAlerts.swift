//
//  ShowAlerts.swift
//  Barkd1
//
//  Created by MacBook Air on 4/18/17.
//  Copyright © 2017 LionsEye. All rights reserved.
//

import Foundation
import UIKit
import SCLAlertView

func showWarningMessage(_ message: String, subTitle: String = "") {
    let appearance = SCLAlertView.SCLAppearance(
        showCloseButton: false
    )
    let alertView = SCLAlertView(appearance: appearance)
    alertView.showError(message, subTitle: subTitle)
}

func showComplete(_ message: String, subTitle: String = "") {
    let appearance = SCLAlertView.SCLAppearance(
        showCloseButton: false
    )
    let alertView = SCLAlertView(appearance: appearance)
    alertView.showSuccess(message, subTitle: subTitle)
}






//
//  ShowAlerts.swift
//  Barkd1
//
//  Created by MacBook Air on 4/18/17.
//  Copyright © 2017 LionsEye. All rights reserved.
//

import Foundation
import SCLAlertView

func showWarningMessage(_ message: String, subTitle: String = "") {
    let alert = SCLAlertView()
    alert.showError(message, subTitle: subTitle)
}





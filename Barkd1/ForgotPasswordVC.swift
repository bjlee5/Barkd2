//
//  ForgotPasswordVC.swift
//  Barkd1
//
//  Created by MacBook Air on 4/15/17.
//  Copyright © 2017 LionsEye. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func resetPW(_ sender: Any) {
        let email = emailField.text!
        
        FIRAuth.auth()?.sendPasswordReset(withEmail: email, completion: { (error) in
            if error == nil {
                showComplete("Password", subTitle: "You will receive an e-mail momentarily with instructions!")
                
            } else {
                
                print(error?.localizedDescription)
            }
        
        })
    }
    
    @IBAction func backPress(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogInVC")
        self.present(vc, animated: true, completion: nil)
    }

} 

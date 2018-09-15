//
//  LoginViewController.swift
//  htn-2018
//
//  Created by Jashan Shewakramani on 2018-09-15.
//  Copyright © 2018 Jashan Shewakramani. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, LoginFormViewDelegate {
    
    // MARK: View Properties
    @IBOutlet private var loginFormView: LoginFormView!
    
    // MARK: Other Properties
    private let userSignupService = UserSignupService()
    private let userSigninService = UserSigninService()
    
    init() {
        super.init(nibName: String(describing: LoginViewController.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginFormView.mode = .signup
        self.loginFormView.delegate = self
    }
    
    // MARK: LoginFormViewDelegate
    func loginFormViewDidTapLogin(_ view: LoginFormView) {
        
    }
}

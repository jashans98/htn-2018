//
//  LoginFormView.swift
//  htn-2018
//
//  Created by Jashan Shewakramani on 2018-09-15.
//  Copyright © 2018 Jashan Shewakramani. All rights reserved.
//

import UIKit
import SnapKit

protocol LoginFormViewDelegate: class {
    func loginFormViewDidTapLogin(_ view: LoginFormView)
}

class LoginFormView: UIView {
    enum Mode {
        case signup, signin
    }
    
    let usernameField = HTNTextField()
    let passwordField = HTNTextField()
    let confirmPasswordField = HTNTextField()
    private let switchLoginModeButton = UIButton()
    private let loginButton = UIButton()
    private let containerStackView = UIStackView()
    
    var mode: LoginFormView.Mode = .signup {
        didSet {
            self.refreshLayoutForMode()
        }
    }
    
    weak var delegate: LoginFormViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func commonInit() {
        self.translatesAutoresizingMaskIntoConstraints = false
        // base stack view
        self.containerStackView.axis = .vertical
        self.containerStackView.alignment = .fill
        self.containerStackView.spacing = Dimens.halfScreenPadding
        
        self.addSubview(self.containerStackView)
        self.containerStackView.pinToSuperview()
        
        // switch login button
        let switchLoginButtonWrapper = UIView()
        switchLoginButtonWrapper.addSubview(self.switchLoginModeButton)
        
        self.switchLoginModeButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(Dimens.screenPadding)
        }
        
        // text fields
        let orderedTextFields: [UITextField] = [
            self.usernameField, self.passwordField, self.confirmPasswordField
        ]
        
        orderedTextFields.forEach {
            $0.font = UIFont.systemFont(ofSize: Dimens.fontSizeBody)
        }
        
        self.usernameField.placeholder = NSLocalizedString("User Name", comment: "")
        self.passwordField.placeholder = NSLocalizedString("Password", comment: "")
        self.confirmPasswordField.placeholder = NSLocalizedString("Confirm Password", comment: "")
        
        // add everything to the stack view
        let orderedSubviews: [UIView] = orderedTextFields + [switchLoginButtonWrapper, self.loginButton]
        
        orderedSubviews.forEach {
            $0.snp.makeConstraints { (make) in
                make.height.equalTo(Dimens.textFieldHeight)
            }
            
            self.containerStackView.addArrangedSubview($0)
        }
        
        // buttons
        self.switchLoginModeButton.setTitleColor(Colors.gray3, for: .normal)
        self.switchLoginModeButton.titleLabel?.font = UIFont.systemFont(ofSize: Dimens.fontSizeCaption)
        self.switchLoginModeButton.addTarget(
            self,
            action: #selector(didTapSwitchLoginMode),
            for: .touchUpInside
        )
        
        self.loginButton.setTitleColor(Colors.gray1, for: .normal)
        self.loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: Dimens.fontSizeBody)
        self.loginButton.addTarget(
            self,
            action: #selector(didTapLogin),
            for: .touchUpInside
        )
        
        self.refreshLayoutForMode()
    }
    
    func refreshLayoutForMode() {
        if self.mode == .signin {
            self.confirmPasswordField.isHidden = true
            self.switchLoginModeButton.setTitle(
                NSLocalizedString("Don't have an account? Sign up", comment: ""),
                for: .normal
            )
            self.loginButton.setTitle(
                NSLocalizedString("Sign In", comment: ""),
                for: .normal
            )
        } else {
            self.confirmPasswordField.isHidden = false
            self.switchLoginModeButton.setTitle(
                NSLocalizedString("Already have an account? Sign in", comment: ""),
                for: .normal
            )
            self.loginButton.setTitle(
                NSLocalizedString("Create an Account", comment: ""),
                for: .normal
            )
        }
    }
    
    @objc private func didTapSwitchLoginMode() {
        self.mode = self.mode == .signin ? .signup : .signin
        self.endEditing(true)
        self.refreshLayoutForMode()
    }
    
    @objc private func didTapLogin() {
        self.delegate?.loginFormViewDidTapLogin(self)
    }
}

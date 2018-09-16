//
//  EditDocumentToolbarView.swift
//  htn-2018
//
//  Created by Jashan Shewakramani on 2018-09-15.
//  Copyright © 2018 Jashan Shewakramani. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

protocol EditDocumentToolbarViewDelegate: class {
    func editDocumentToolBarViewDidTapNewMathSection(_ view: EditDocumentToolbarView)
    func editDocumentToolBarViewDidTapNewTextSection(_ view: EditDocumentToolbarView)
    func editDocumentToolBarViewDidTapCompile(_ view: EditDocumentToolbarView)
}

class EditDocumentToolbarView: UIView {
    let newMathButton = UIButton()
    let newTextButton = UIButton()
    let compileButton = UIButton()
    
    weak var delegate: EditDocumentToolbarViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        self.addSubview(self.newMathButton)
        self.addSubview(self.newTextButton)
        
        self.newMathButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(Dimens.screenPadding)
        }
        
        self.newMathButton.setTitle("New Math Box", for: .normal)
        self.newMathButton.setTitleColor(Colors.gray1, for: .normal)
        
        self.newTextButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(Dimens.screenPadding)
        }
        
        self.newTextButton.setTitle("New Text Box", for: .normal)
        self.newTextButton.setTitleColor(Colors.gray1, for: .normal)
        
        self.newMathButton.addTarget(self, action: #selector(didTapMath), for: .touchUpInside)
        self.newTextButton.addTarget(self, action: #selector(didTapText), for: .touchUpInside)
        
        self.compileButton.setTitle("Compile", for: .normal)
        self.compileButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: Dimens.fontSizeLarge)
        self.compileButton.setTitleColor(Colors.gray1, for: .normal)
        
        self.addSubview(self.compileButton)
        
        self.compileButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        self.compileButton.addTarget(self, action: #selector(didTapCompile), for: .touchUpInside)
    }
    
    @objc private func didTapMath() {
        self.delegate?.editDocumentToolBarViewDidTapNewMathSection(self)
    }
    
    @objc private func didTapText() {
        self.delegate?.editDocumentToolBarViewDidTapNewTextSection(self)
    }
    
    @objc private func didTapCompile() {
        self.delegate?.editDocumentToolBarViewDidTapCompile(self)
    }
}











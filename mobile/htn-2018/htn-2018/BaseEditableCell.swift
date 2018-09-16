//
//  BaseEditableCell.swift
//  htn-2018
//
//  Created by Jashan Shewakramani on 2018-09-15.
//  Copyright © 2018 Jashan Shewakramani. All rights reserved.
//

import UIKit

protocol BaseEditableCellDelegate: class {
    func baseEditableCellPreparingForReuse(_ cell: BaseEditableCell)
    func baseEditableCellDidTapTrash(_ cell: BaseEditableCell, sourceView: UIView)
}

class BaseEditableCell: UITableViewCell {
    
    private static let trashIconSize: CGFloat = 15.0
    
    var currentIndexPath: IndexPath?
    
    weak var delegate: BaseEditableCellDelegate?
    
    var editableView: UIView!
    let cellTypeLabel = UILabel()
    let trashIcon = UIButton()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func commonInit() {
        self.backgroundColor = Colors.gray7
        self.editableView = self.getContentView()
        self.addSubview(self.editableView)
        
        
        self.editableView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(Dimens.halfScreenPadding)
            make.left.right.equalToSuperview().inset(Dimens.screenPadding)
            
            if let preferredHeight = self.preferredContentViewHeight() {
                make.height.equalTo(preferredHeight)
            }
        }
        
        self.addSubview(self.cellTypeLabel)
        
        self.cellTypeLabel.text = self.getCellTypeString()
        self.cellTypeLabel.textColor = Colors.gray4
        self.cellTypeLabel.font = UIFont.systemFont(ofSize: Dimens.fontSizeCaption)
        
        self.cellTypeLabel.snp.makeConstraints { (make) in
            make.right.bottom.equalTo(self.editableView).inset(Dimens.smallScreenPadding)
        }
        
        self.trashIcon.setImage(#imageLiteral(resourceName: "icons8-trash-50"), for: .normal)
        self.trashIcon.imageView?.contentMode = .scaleAspectFit
        self.addSubview(self.trashIcon)
        
        self.trashIcon.snp.makeConstraints { (make) in
            make.left.bottom.equalTo(self.editableView).inset(Dimens.smallScreenPadding)
            make.width.height.equalTo(BaseEditableCell.trashIconSize)
        }
        
        self.trashIcon.addTarget(self, action: #selector(didTapTrash), for: .touchUpInside)
    }
    
    @objc private func didTapTrash() {
        self.delegate?.baseEditableCellDidTapTrash(self, sourceView: self.trashIcon)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.editableView.roundCorners(withRadius: Dimens.smallCornerRadius)
        self.editableView.layer.borderColor = Colors.gray5.cgColor
        self.editableView.layer.borderWidth = 0.5
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            self.editableView.layer.borderColor = Colors.highlightedBlue.cgColor
            self.editableView.becomeFirstResponder()
        } else {
            self.editableView.layer.borderColor = Colors.gray5.cgColor
            self.editableView.resignFirstResponder()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.delegate?.baseEditableCellPreparingForReuse(self)
    }
    
    func getContentView() -> UIView {
        fatalError("Content View must be provided by subclass")
    }
    
    func getCellTypeString() -> String {
        return ""
    }
    
    func preferredContentViewHeight() -> CGFloat? {
        return nil
    }
    
}

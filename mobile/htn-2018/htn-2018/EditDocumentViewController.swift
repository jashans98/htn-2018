//
//  EditDocumentViewController.swift
//  htn-2018
//
//  Created by Jashan Shewakramani on 2018-09-15.
//  Copyright © 2018 Jashan Shewakramani. All rights reserved.
//

import UIKit


class EditDocumentViewController: UIViewController {
    
    @IBOutlet private var editDocumentToolbarView: EditDocumentToolbarView!
    @IBOutlet private var tableView: UITableView!
    
    static let textReuseIdentifier = "textCell"
    static let mathReuseIdentifier = "mathCell"
    
    init() {
        super.init(nibName: String(describing: EditDocumentViewController.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: viewDidLoad()
    }
}

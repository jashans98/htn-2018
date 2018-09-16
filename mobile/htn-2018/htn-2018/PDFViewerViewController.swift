//
//  PDFViewerViewController.swift
//  htn-2018
//
//  Created by Jashan Shewakramani on 2018-09-16.
//  Copyright © 2018 Jashan Shewakramani. All rights reserved.
//

import UIKit
import PDFKit

class PDFViewerViewController: UIViewController {
    
    let document: PDFDocument
    private let pdfView = PDFView()
    
    init(document: PDFDocument) {
        self.document = document
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = Colors.white
        
        self.view.addSubview(self.pdfView)
        self.pdfView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        self.pdfView.document = self.document
        self.pdfView.displayMode = .singlePageContinuous
        self.pdfView.maxScaleFactor = 6.0
        
        let closeButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(didTapDone)
        )
        
        self.navigationController?.navigationItem.setLeftBarButton(closeButton, animated: false)
        self.navigationController?.title = "PDF Preview"
    }
    
    @objc private func didTapDone() {
        self.dismiss(animated: true, completion: nil)
    }
}





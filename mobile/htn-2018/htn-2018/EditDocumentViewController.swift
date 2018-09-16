//
//  EditDocumentViewController.swift
//  htn-2018
//
//  Created by Jashan Shewakramani on 2018-09-15.
//  Copyright © 2018 Jashan Shewakramani. All rights reserved.
//

import UIKit
import PDFKit

class EditDocumentViewController: UIViewController, EditDocumentToolbarViewDelegate, BaseEditableCellDelegate {
    
    // MARK: Static Properties
    static let textCellReuseIdentifier = "textCell"
    static let mathCellReuseIdentifier = "mathCell"
    
    // MARK: View Properties
    @IBOutlet private var editDocumentToolbarView: EditDocumentToolbarView!
    @IBOutlet private var tableView: EditDocumentTableView!
    
    // MARK: Other Properties
    var document: Document
    private let compileService = CompileDocumentService()
    
    // TODO: add services and other things here
    
    
    // MARK: Initializers
    init(document: Document? = nil) {
        if let initializingDocument = document {
            self.document = initializingDocument
        } else {
            self.document = Document()
        }
        super.init(nibName: String(describing: EditDocumentViewController.self), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.editDocumentToolbarView.delegate = self
        
        self.tableView.backgroundColor = Colors.gray7
        self.tableView.separatorStyle = .none
        
        self.tableView.canCancelContentTouches = false
        self.tableView.delaysContentTouches = false
        self.tableView.allowsSelection = false
        
        self.tableView.register(
            TextEditableCell.self,
            forCellReuseIdentifier: EditDocumentViewController.textCellReuseIdentifier
        )
        
        self.tableView.register(
            MathEditableCell.self,
            forCellReuseIdentifier: EditDocumentViewController.mathCellReuseIdentifier
        )
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func persistChangesInModel() {
        for cell in self.tableView.visibleCells {
            guard let cell = cell as? BaseEditableCell else {
                return
            }
            
            if let indexPath = cell.currentIndexPath {
                if let mathCell = cell as? MathEditableCell {
                    self.document.orderedBlocks[indexPath.row] = Document.Block.Math(touches: mathCell.drawingCanvasView.allPoints)
                }
                if let textCell = cell as? TextEditableCell {
                    self.document.orderedBlocks[indexPath.row] = Document.Block.Text(value: textCell.textView.text)
                }
            }
        }
    }
    
    // MARK: EditDocumentToolbarDelegate
    func editDocumentToolBarViewDidTapNewMathSection(_ view: EditDocumentToolbarView) {
        let mathBlock = Document.Block.Math(touches: [])
        self.document.append(block: mathBlock)
        self.persistChangesInModel()
        self.tableView.reloadData()
    }
    
    func editDocumentToolBarViewDidTapNewTextSection(_ view: EditDocumentToolbarView) {
        let textBlock = Document.Block.Text(value: "")
        self.document.append(block: textBlock)
        self.persistChangesInModel()
        self.tableView.reloadData()
    }
    
    func editDocumentToolBarViewDidTapCompile(_ view: EditDocumentToolbarView) {
        self.persistChangesInModel()
        
        let completionBlock: CompileDocumentServiceCompletionBlock = { (pdfUrlString) in
            guard let data = try? Data(contentsOf: URL(string: pdfUrlString)!),
                let pdfDocument = PDFDocument(data: data) else {
                return
            }
            
            
            let vc = PDFViewerViewController(document: pdfDocument)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.compileService.requestService(document: self.document, completionBlock: completionBlock)
    }
    
    // MARK: BaseEditableCellDelegate
    func baseEditableCellPreparingForReuse(_ cell: BaseEditableCell) {
        self.persistChangesInModel()
    }
    
    func baseEditableCellDidTapTrash(_ cell: BaseEditableCell, sourceView: UIView) {
        guard let trashingIndex = cell.currentIndexPath?.row else {
            return
        }
        
        let alert = UIAlertController(
            title: "Delete Component",
            message: "Are you sure you want to delete this component? You cannot undo this action",
            preferredStyle: .actionSheet
        )
        
        alert.addAction(UIAlertAction(title: "No thanks", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes, delete", style: .destructive, handler: { (action) in
            self.document.deleteBlock(atIndex: trashingIndex)
            self.tableView.reloadData()
        }))
        
        
        alert.popoverPresentationController?.sourceView = sourceView
        
        self.present(alert, animated: true, completion: nil)
    }
}


extension EditDocumentViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return document.orderedBlocks.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let block = document.orderedBlocks[indexPath.row]
        let dequeuedCell: BaseEditableCell
        
        switch block {
        case .Text(let value):
            let textCell = tableView.dequeueReusableCell(
                withIdentifier: EditDocumentViewController.textCellReuseIdentifier,
                for: indexPath
                ) as! TextEditableCell
            textCell.textView.text = value
            dequeuedCell = textCell
            
        case .Math(let touches):
            let mathCell = tableView.dequeueReusableCell(
                withIdentifier: EditDocumentViewController.mathCellReuseIdentifier,
                for: indexPath
                ) as! MathEditableCell
            mathCell.drawingCanvasView.clear()
            mathCell.drawingCanvasView.setupWithCanvasPoints(touches)
            dequeuedCell = mathCell
        }
        
        dequeuedCell.currentIndexPath = indexPath
        dequeuedCell.delegate = self
        
        return dequeuedCell
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

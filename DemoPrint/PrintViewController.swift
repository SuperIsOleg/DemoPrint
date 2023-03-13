//
//  PrintViewController.swift
//  DemoPrint
//
//  Created by Oleg Kalistratov on 2.03.23.
//

import UIKit
import PDFKit

class PrintViewController: UIViewController {
    
    private let printView = PrintView()
    private var pdfDoc = PDFDocument()
    
    override func loadView() {
        super.loadView()
        self.view = printView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        printView.printButton.addTarget(self, action: #selector(printAction), for: .touchUpInside)
    }
    
    private func addPhotosToPagePdf(quantity: Int) -> PDFPage {
        var positionX: Double = 0
        var positionY: Double = 0
        
        let page = PDFPage()
        
        let pageRect = page.bounds(for: .cropBox)
        let renderer = UIGraphicsImageRenderer(bounds: pageRect, format: UIGraphicsImageRendererFormat.default())
        let image = renderer.image { (context) in
            context.cgContext.saveGState()
            context.cgContext.translateBy(x: 0, y: pageRect.height)
            context.cgContext.concatenate(CGAffineTransform.init(scaleX: 1, y: -1))
            page.draw(with: .mediaBox, to: context.cgContext)
            context.cgContext.restoreGState()
        
            Range(1...quantity).forEach { value in
                
                if positionX + 150 > pageRect.width {
                    positionY += 150
                    positionX = 0
                }
                
                let myImage = self.printView.getImage()
                let imagePosition = CGRect(x: positionX,
                                           y: positionY,
                                           width: 150,
                                           height: 150)
                
                positionX += 150
                
                myImage.draw(in: imagePosition)
            }
        }
        
        guard let newPage = PDFPage(image: image) else { return PDFPage() }
        
        return newPage
    }
    
//    private func createCustomPage() -> Data {
//        let format = UIGraphicsPDFRendererFormat()
//        let pageWidth = 8.5 * 72.0
//        let pageHeight = 11 * 72.0
//        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
//        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
//        let data = renderer.pdfData { _ in
//
//        }
//
//        return data
//    }
    
    private func quantityPage(quantity: Double) {
        let quantityPage = Double(quantity / 20) <= 1 ? 1 : Double(quantity / 20).rounded(.up)
        
        let remainder = Int(
            Double(
                Double(round(10 *
                             ((Double(quantity / 20) - Double(quantity / 20).rounded(.down)) * 20)) / 10)
            ).rounded(.up)
        )
        
        for index in 0 ... Int(quantityPage) - 1 {
            if index != Int(quantityPage) - 1 {
                pdfDoc.insert(addPhotosToPagePdf(quantity: 20), at: index)
            } else {
                pdfDoc.insert(addPhotosToPagePdf(quantity: remainder), at: index)
            }
            
        }
    }
    
    @objc
    private func printAction() {
        guard let text = self.printView.textField.text,
              let quantity = Double(text) else { return }
        
        quantityPage(quantity: quantity)
        
        let printInfo = UIPrintInfo(dictionary: nil)
        printInfo.jobName = "Printing QR-code"
        printInfo.outputType = .general
        printInfo.orientation = .portrait
        printInfo.duplex = .longEdge
        
        let printController = UIPrintInteractionController.shared
        printController.printInfo = printInfo
        printController.printingItem = pdfDoc.dataRepresentation()
        printController.showsPaperOrientation = true
        printController.showsNumberOfCopies = false
        printController.showsPaperSelectionForLoadedPapers = true
        printController.delegate = self
        
        printController.present(animated: true)
    }
}

extension PrintViewController: UIPrintInteractionControllerDelegate {
    func printInteractionControllerWillDismissPrinterOptions(_ printInteractionController: UIPrintInteractionController) {
        self.pdfDoc = PDFDocument()
    }
    
}


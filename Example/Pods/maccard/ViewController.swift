//
//  ViewController.swift
//  maccard
//
//  Created by Jonathan Hammer on 2/28/20.
//

import Cocoa
import CardScanCoreMac

class ViewController: NSViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func cropSquareCardImage(squareCardImage: CGImage) -> CGImage {
        let height = CGFloat(squareCardImage.width) * 302.0 / 480.0
        let dh = (CGFloat(squareCardImage.height) - height) * 0.5
        let cardRect = CGRect(x: 0.0, y: dh, width: CGFloat(squareCardImage.width), height: height)
        
        return squareCardImage.cropping(to: cardRect) ?? squareCardImage
    }
    
    @IBAction func chooseImage(_ sender: Any) {
        let op = NSOpenPanel();
        op.allowedFileTypes = [kUTTypeImage as String]
        
        if op.runModal() == .OK, let url = op.url {
            let image = NSImage(contentsOf: url)
            guard let cgi = image?.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
                print("no bueno")
                return
            }
            
            let ocr = Ocr()
            
            ocr.errorCorrectionDuration = 0.0;
            
            let results = ocr.performWithErrorCorrection(for: cropSquareCardImage(squareCardImage: cgi), squareCardImage: cgi, fullCardImage: cgi)
            
            print("got results \(results)")
        }
    }
}


//
//  ViewController.swift
//  Calc
//
//  Created by Bori Akinola on 18/09/2023.
//

import UIKit

class CalcVC: UIViewController {
    
    private enum PersistenceMode {
        case plist
        case json
    }
    @IBOutlet weak var calcDisplay: UILabel!
    private var inputMode = false
    private lazy var calcModel = {
        return CalcModel()
    }()
    private var persistenceMode = PersistenceMode.json
    private var displayValue: Double {
        get {
            return Double(calcDisplay.text!)!
        }
        set {
            calcDisplay.text = "\(newValue)"
            inputMode = false
            switch persistenceMode {
            case .plist:
                let defaults = UserDefaults.standard
                defaults.setValue(calcModel.session, forKey: "calcModel.session")
                defaults.synchronize()
            case .json:
                if let url = fileURL { self.save(to: url) }
            }
            
        }
    }
    
    private var fileURL: URL? {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return documentDirectory?.appendingPathComponent("calcModel.json")
    }
    
    private func save(to url: URL) {
        let thisfunction = "\(String(describing: self)).\(#function)"
        do {
            let data: Data = try calcModel.json()
            print("\(thisfunction) json = \(String(data: data, encoding: .utf8) ?? "nil")")
            try data.write(to: url)
            
            print("\(thisfunction) success!")
        } catch let encodingError where encodingError is EncodingError {
            print("\(thisfunction) couldn't encode CalcModel as JSON because \(encodingError.localizedDescription)")
        } catch {
            print("\(thisfunction) error = \(error)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        switch persistenceMode {
        case .plist:
            let defaults = UserDefaults.standard
            if let session = defaults.object(forKey: "calcModel.session") {
                calcModel.session = session
            }
        case .json:
                if let url = fileURL {
                    let thisfunction = "\(String(describing: self)).\(#function)"
                    do {
                        calcModel = try CalcModel(url: url)
                        if let result = calcModel.evaluateStack() {
                            displayValue = result
                        } else {
                            displayValue = 0
                        }
                    } catch let decodingError where decodingError is DecodingError {
                        print("\(thisfunction) couldn't decode CalcModel from JSON because \(decodingError.localizedDescription)")
                    } catch {
                        print("\(thisfunction) error = \(error)")
                    }
                }
        }
        
            if let result = calcModel.evaluateStack() {
                displayValue = result
            }
        }
    
    
    @IBAction func digitPresed(_ sender: UIButton) {
        if let digit = sender.titleLabel?.text {
            if inputMode {
                calcDisplay.text = calcDisplay.text! + digit
            } else {
                calcDisplay.text = digit
                inputMode = true
            }
        }
    }
    
    @IBAction func pushOperand() {
        inputMode = false
        displayValue = calcModel.pushOperand(displayValue) ?? 0
    }
    
    @IBAction func operationPressed(_ sender: UIButton) {
        
        if inputMode {
            pushOperand()
        }
        if let operation = sender.titleLabel?.text {
            displayValue = calcModel.performOperation(operation) ?? 0
        }
    }
}


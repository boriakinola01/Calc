//
//  ViewController.swift
//  Calc
//
//  Created by Bori Akinola on 18/09/2023.
//

import UIKit

class CalcVC: UIViewController {
    @IBOutlet weak var calcDisplay: UILabel!
    private var inputMode = false
    private lazy var calcModel = {
        return CalcModel()
    }()
    private var displayValue: Double {
        get {
            return Double(calcDisplay.text!)!
        }
        set {
            calcDisplay.text = "\(newValue)"
            inputMode = false
            let defaults = UserDefaults.standard
            defaults.setValue(calcModel.session, forKey: "calcModel.session")
            defaults.synchronize()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let defaults = UserDefaults.standard
        if let session = defaults.object(forKey: "calcModel.session") {
            calcModel.session = session
            if let result = calcModel.evaluateStack() {
                displayValue = result
            }
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


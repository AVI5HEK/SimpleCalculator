//
//  ViewController.swift
//  SimpleCalculator
//
//  Created by framgia on 10/24/16.
//  Copyright © 2016 framgia. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, ResultViewControllerDelegate {
    
    // MARK: - Properties
    @IBOutlet weak var intButton: UIButton!
    @IBOutlet weak var floatButton: UIButton!
    @IBOutlet weak var stringButton: UIButton!
    
    var topButtons = [UIButton]()
    
    @IBOutlet weak var valueOfX: UITextField!
    @IBOutlet weak var valueOfY: UITextField!
    
    @IBOutlet weak var sumButton: UIButton!
    @IBOutlet weak var mulButton: UIButton!
    @IBOutlet weak var concatButton: UIButton!
    
    @IBOutlet weak var sumLabel: UILabel!
    @IBOutlet weak var mulLabel: UILabel!
    @IBOutlet weak var conLabel: UILabel!
    
    
    var operation = ""
    var argument1 = ""
    var argument2 = ""
    var dataType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        topButtons = [intButton, floatButton, stringButton]
        sumButton.enabled = false
        mulButton.enabled = false
        concatButton.enabled = false
        
        NSNotificationCenter.defaultCenter()
            .addObserver(self,
                         selector: #selector(self.catchNotification(_:)),
                         name: NotificationKeys.notificationKey,
                         object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func selectTypeInt(sender: UIButton) {
        dataType = DataTypes.int
        updateButtons(topButtons, selectedButton: sender)
    }
    
    @IBAction func selectTypeFloat(sender: UIButton) {
        dataType = DataTypes.float
        updateButtons(topButtons, selectedButton: sender)
    }
    
    @IBAction func selectTypeString(sender: UIButton) {
        dataType = DataTypes.string
        updateButtons(topButtons, selectedButton: sender)
    }
    
    @IBAction func selectOperationSum(sender: UIButton) {
        calculate(Operations.summation)
    }
    
    @IBAction func selectOperationMultiplication(sender: UIButton) {
        calculate(Operations.multiplication)
    }
    
    @IBAction func selectOperationConcatanation(sender: UIButton) {
        calculate(Operations.concatanation)
    }
    
    // MARK: - Utils
    
    func updateButtons(buttons: [UIButton], selectedButton: UIButton) {
        for button: UIButton in buttons {
            if button == selectedButton {
                button.backgroundColor = UIColor.grayColor()
            } else {
                button.backgroundColor = UIColor.clearColor()
            }
        }
        
        switch dataType {
        case DataTypes.int:
            sumButton.enabled = true
            mulButton.enabled = true
            concatButton.enabled = false
            break
        case DataTypes.float:
            sumButton.enabled = true
            mulButton.enabled = true
            concatButton.enabled = false
            break
        case DataTypes.string:
            sumButton.enabled = false
            mulButton.enabled = false
            concatButton.enabled = true
        default:
            break
        }
    }
    
    func calculate(operation: String) {
        var result = ""
        switch operation {
        case Operations.summation:
            if(dataType == DataTypes.int){
                if let x = valueOfX.text?.componentsSeparatedByString("."), y = valueOfY.text?.componentsSeparatedByString(".") {
                    result = "\(Int(x.first!)! + Int(y.first!)!)"
                } else {
                    result = "\(Int(valueOfX.text!)! + Int(valueOfY.text!)!)"
                }
            } else {
                result = "\(Float(valueOfX.text!)! + Float(valueOfY.text!)!)"
            }
            break
        case Operations.multiplication:
            if(dataType == DataTypes.int){
                if let x = valueOfX.text?.componentsSeparatedByString("."), y = valueOfY.text?.componentsSeparatedByString(".") {
                    result = "\(Int(x.first!)! * Int(y.first!)!)"
                } else {
                    result = "\(Int(valueOfX.text!)! * Int(valueOfY.text!)!)"
                }
            } else {
                result = "\(Float(valueOfX.text!)! * Float(valueOfY.text!)!)"
            }
            break
        case Operations.concatanation:
            result = valueOfX.text! + valueOfY.text!
            break
        default:
            break
        }
        
        
        let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ResultViewController") as? ResultViewController
        secondViewController?.result = Result(argument1: valueOfX.text!, argument2: valueOfY.text!, operation: operation, result: result, dataType: dataType)
        secondViewController?.delegate = self
        secondViewController?.onClosureButtonTapped = {(data: [Result]) -> Void in
            self.updateLabels(data)
        }
        self.presentViewController(secondViewController!, animated:true, completion:nil)
    }
    
    func updateLabels(data: [Result]) {
        var sum = 0
        var mul = 0
        var con = 0
        for r: Result in data {
            if (r.operation == Operations.summation) {
                sum += 1
            } else if (r.operation == Operations.multiplication) {
                mul += 1
            } else {
                con += 1
            }
        }
        sumLabel.text = "SUM: #" + "\(sum)"
        mulLabel.text = "MUL: #" + "\(mul)"
        conLabel.text = "CON: #" + "\(con)"
    }
    
    func catchNotification(notification: NSNotification) -> Void {
        guard let userInfo = notification.userInfo,
            let message = userInfo["message"] as? [Result],
            let date = userInfo["date"] as? NSDate else {
                print("No userInfo found in notification")
                return
        }
        
        updateLabels(message)
    }
    
    //MARK: - ResultViewControllerDelegate
    func onDataSaved(data: [Result]) {
        updateLabels(data)
    }
}


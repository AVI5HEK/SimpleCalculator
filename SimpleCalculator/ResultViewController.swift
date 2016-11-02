//
//  ResultViewController.swift
//  SimpleCalculator
//
//  Created by framgia on 10/25/16.
//  Copyright © 2016 framgia. All rights reserved.
//

import UIKit

protocol ResultViewControllerDelegate {
    func onDataSaved(data: [Result])
}

class ResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Properties
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var intLabel: UILabel!
    @IBOutlet weak var stringLabel: UILabel!
    @IBOutlet weak var floatLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var result = Result(argument1: "", argument2: "", operation: "", result: "", dataType: "")
    var results = [Result]()
    var numberOfInt = 0
    var numberOfFloat = 0
    var numberOfString = 0
    
    var delegate: ResultViewControllerDelegate?
    
    var onClosureButtonTapped: ((data: [Result]) -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.reloadData()
        loadData()
        initViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() {
        results.append(result!)
        
        if let savedResults = Result.loadResults() {
            results += savedResults
        }
        
        for r: Result in results {
            if (r.dataType == DataTypes.int) {
                numberOfInt += 1
            } else if (r.dataType == DataTypes.float){
                numberOfFloat += 1
            } else {
                numberOfString += 1
            }
        }
    }
    
    func initViews() {
        valueLabel.text = result?.result
        
        intLabel.text = intLabel.text! + "\(numberOfInt)"
        stringLabel.text = stringLabel.text! + "\(numberOfString)"
        floatLabel.text = floatLabel.text! + "\(numberOfFloat)"
    }
    
    // MARK: - Actions
    
    @IBAction func delegate(sender: UIButton) {
        Result.saveResults(results)
        delegate?.onDataSaved(results)
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func closure(sender: UIButton) {
        Result.saveResults(results)
        if let onClosureButtonTapped = self.onClosureButtonTapped {
            onClosureButtonTapped(data: results)
            self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func postNotification(sender: UIButton) {
        Result.saveResults(results)
        NSNotificationCenter.defaultCenter()
            .postNotificationName(NotificationKeys.notificationKey,
                                  object: nil,
                                  userInfo: ["message": results, "date": NSDate()])
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - TableView delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LabelCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = results[indexPath.row].result
        
        return cell
    }
}

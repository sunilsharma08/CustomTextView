//
//  ViewController.swift
//  CustomTextViewExample
//
//  Created by Sunil Sharma on 08/06/16.
//  Copyright © 2016 Sunil Sharma. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CustomTextViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    let defaultTableCellIdentifier = "defaultCellIdentifier"
    let dataArray = NSMutableArray()
    let customtTextView: CustomTextView = CustomTextView(frame: CGRectZero)
    var bottomChatViewConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: defaultTableCellIdentifier)
    dataArray.addObjectsFromArray(["hello","hi","wow","hi","wow","hi","wow","hi","wow","hi","wow","hi","wow","hi","wow","hi","wow","hi","wow"])
        self.setupChatView()
        self.setupLayoutConstraints()
        self.view.layoutIfNeeded()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Comments"
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillHide(sender: NSNotification) {
        if let userInfo = sender.userInfo {
            if let _ = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size.height {
                self.bottomChatViewConstraint.constant =  0
                UIView.animateWithDuration(0.25, animations: { () -> Void in self.view.layoutIfNeeded() })
            }
        }
    }
    
    func keyboardWillShow(sender: NSNotification) {
        if let userInfo = sender.userInfo {
            if let keyboardHeight = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size.height {
                self.bottomChatViewConstraint.constant = -keyboardHeight
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    func setupChatView(){
        self.view.addSubview(customtTextView)
        customtTextView.delegate = self
        customtTextView.placeholder = "Write a comment..."
        customtTextView.maxCharCount = 250
        customtTextView.textView.keyboardDismissMode = .OnDrag
    }
    
    func setupLayoutConstraints() {
        self.customtTextView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(self.chatInputConstraints())
        self.view.addConstraints(self.tableViewConstraints())
    }
    
    func chatInputConstraints() -> [NSLayoutConstraint] {
        self.bottomChatViewConstraint = NSLayoutConstraint(item: self.customtTextView, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: 0)
        let leftConstraint = NSLayoutConstraint(item: self.customtTextView, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1.0, constant: 0.0)
        let rightConstraint = NSLayoutConstraint(item: self.customtTextView, attribute: .Right, relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1.0, constant: 0.0)
        return [leftConstraint, self.bottomChatViewConstraint, rightConstraint]
    }
    
    func tableViewConstraints() -> [NSLayoutConstraint] {
        let leftConstraint = NSLayoutConstraint(item: self.tableView, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1.0, constant: 0.0)
        let rightConstraint = NSLayoutConstraint(item: self.tableView, attribute: .Right, relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1.0, constant: 0.0)
        let topConstraint = NSLayoutConstraint(item: self.tableView, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: 0.0)
        let bottomConstraint = NSLayoutConstraint(item: self.tableView, attribute: .Bottom, relatedBy: .Equal, toItem: self.customtTextView, attribute: .Top, multiplier: 1.0, constant: 0)
        return [rightConstraint, leftConstraint, topConstraint, bottomConstraint]
    }
    
    func customTextView(chatInput: CustomTextView, didSendMessage message: String) {
        //Chat send button is pressed
    }
    
    func chatViewDidResize(chatInput: CustomTextView) {
        //ChatView size is updated
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(defaultTableCellIdentifier)
        cell?.textLabel?.text = dataArray[indexPath.row] as? String
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}


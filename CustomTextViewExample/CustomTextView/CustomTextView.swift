//
//  CustomTextView.swift
//  CustomTextViewExample
//
//  Created by Sunil Sharma on 08/06/16.
//  Copyright © 2016 Sunil Sharma. All rights reserved.
//

import UIKit

// MARK: Chat Input
@objc protocol CustomTextViewDelegate:UITextViewDelegate {
    optional func customTextViewDidResize(customTextView: CustomTextView)
    optional func customTextView(customTextView: CustomTextView, didSendMessage message: String)
    optional func updateCharacterCount(currentChar:Int,maxChar:Int)
}

class CustomTextView: UIView,SizeableTextViewDelegate {
    
    // MARK: Styling
    struct Appearance {
        static var tintColor = UIColor(red: 0.0, green: 120 / 255.0, blue: 255 / 255.0, alpha: 1.0)
        static var backgroundColor = UIColor.whiteColor()
        static var textViewFont = UIFont.systemFontOfSize(17.0)
        static var textViewTextColor = UIColor.darkTextColor()
        static var textViewBackgroundColor = UIColor.whiteColor()
    }
    
    class func setAppearanceTintColor(color: UIColor) {
        Appearance.tintColor = color
    }
    
    class func setAppearanceBackgroundColor(color: UIColor) {
        Appearance.backgroundColor = color
    }
    
    class func setAppearanceTextViewFont(textViewFont: UIFont) {
        Appearance.textViewFont = textViewFont
    }
    
    class func setAppearanceTextViewTextColor(textColor: UIColor) {
        Appearance.textViewTextColor = textColor
    }
    
    class func setAppearanceTextViewBackgroundColor(color: UIColor) {
        Appearance.textViewBackgroundColor = color
    }
    
    var placeholder:String? {
        didSet {
            if let placeholderText = self.placeholder{
                self.textView.placeholderAttributedText = NSAttributedString(string: "\(placeholderText)", attributes: [NSFontAttributeName: self.textView.font, NSForegroundColorAttributeName: UIColor(white: 0.8, alpha: 1)])
            }
        }
    }
    
    var includeBlur:Bool = true {
        didSet{
            self.blurredBackgroundView.hidden = !includeBlur
        }
    }
    
    var textViewInsets:UIEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    weak var delegate: CustomTextViewDelegate?
    var maxCharCount:Int?
    var showCharCount:Bool? {
        didSet{
            self.wordLimitLabel.hidden = !showCharCount!
        }
    }
    let textView = SizeableTextView(frame: CGRectZero, textContainer: nil)
    //Private Properties
    private let sendButton = UIButton(type: .System)
    private let blurredBackgroundView: UIToolbar = UIToolbar()
    private var heightConstraint: NSLayoutConstraint!
    private var sendButtonHeightConstraint: NSLayoutConstraint!
    private var sendButtonWidthConstraint:NSLayoutConstraint!
    private var wordLimitLabel:UILabel = UILabel()
    private let sendButtonDefaultWidth:CGFloat = 50
    private let sendButtonDefaultHeight:CGFloat = 0.0
    
    var showSendButton:Bool = true {
        didSet{
            if (showSendButton == true){
                self.sendButtonWidthConstraint.constant = sendButtonDefaultWidth
                self.animateContraintsChange(nil)
            }
            else{
                self.sendButtonWidthConstraint.constant = 0
                self.animateContraintsChange(nil)
            }
        }
    }
    
    private func animateContraintsChange(compeletionHandler:((isAnimationCompleted:Bool) -> Void)?){
        UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [.CurveEaseInOut, .BeginFromCurrentState , .LayoutSubviews], animations: { () -> Void in
            self.layoutIfNeeded()
        }) { (finished) -> Void in
            compeletionHandler?(isAnimationCompleted: true)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect = CGRectZero) {
        super.init(frame: frame)
        self.setup()
        self.stylize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("custom chat view xib")
        self.setup()
        self.stylize()
    }
    
    private func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.showCharCount = true
        self.opaque = true
        self.setupSendButton()
        self.setupSendButtonConstraints()
        self.setupWordLimitLabel()
        self.setupWordLimitLabelConstraints()
        self.setupTextView()
        self.setupTextViewConstraints()
        self.setupBlurredBackgroundView()
        self.setupBlurredBackgroundViewConstraints()
    }
    
    private func setupWordLimitLabel(){
        if let charCount = self.maxCharCount{
            self.wordLimitLabel.text = "0/\(charCount)"
        }
        self.wordLimitLabel.textColor = UIColor.lightGrayColor()
        self.wordLimitLabel.backgroundColor = UIColor.clearColor()
        self.wordLimitLabel.numberOfLines = 1
        self.wordLimitLabel.autoresizesSubviews = false
        self.wordLimitLabel.font = UIFont.systemFontOfSize(14)
        self.wordLimitLabel.bounds = CGRect(x: 0, y: 0, width: 40, height: 1)
        self.wordLimitLabel.hidden = true
        self.wordLimitLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(wordLimitLabel)
    }
    
    private func setupWordLimitLabelConstraints(){
        self.wordLimitLabel.translatesAutoresizingMaskIntoConstraints = false
        self.wordLimitLabel.removeConstraints(self.wordLimitLabel.constraints)
        let rightConstraint = NSLayoutConstraint(item: self, attribute: .Right, relatedBy: .Equal, toItem: self.wordLimitLabel, attribute: .Right, multiplier: 1.0, constant: textViewInsets.right)
        let topConstraint = NSLayoutConstraint(item: self, attribute: .Top , relatedBy: .Equal, toItem: self.wordLimitLabel, attribute: .Top, multiplier: 1.0, constant: -textViewInsets.top)
        
        let widthConstraint = NSLayoutConstraint(item: self.wordLimitLabel, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 40)
        
        let heightContraints = NSLayoutConstraint(item: self.wordLimitLabel, attribute: .Height, relatedBy: .LessThanOrEqual, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 20)
        
        self.addConstraints([heightContraints, widthConstraint, rightConstraint, topConstraint])
    }
    
    private func setupTextView() {
        textView.bounds = UIEdgeInsetsInsetRect(self.bounds, self.textViewInsets)
        textView.sizeableTextViewDelegate = self
        textView.delegate = self
        textView.keyboardType = .EmailAddress
        textView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
        self.styleTextView()
        if let placeholderText = self.placeholder{
            self.textView.placeholderAttributedText = NSAttributedString(string: "\(placeholderText)", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(14), NSForegroundColorAttributeName: UIColor(white: 0.8, alpha: 1)])
        }
        self.addSubview(textView)
    }
    
    private func styleTextView() {
        textView.layer.rasterizationScale = UIScreen.mainScreen().scale
        textView.layer.shouldRasterize = true
        textView.layer.cornerRadius = 5.0
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor(white: 0.0, alpha: 0.2).CGColor
        textView.inputAccessoryView = UIView()
        textView.keyboardDismissMode = .Interactive
    }
    
    private func setupSendButton() {
        self.sendButton.enabled = false
        self.sendButton.setTitle("Send", forState: .Normal)
        self.sendButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        self.sendButton.addTarget(self, action: #selector(CustomTextView.sendButtonPressed(_:)), forControlEvents: .TouchUpInside)
        self.sendButton.bounds = CGRect(x: 0, y: 0, width: sendButtonDefaultWidth, height: 1)
        self.addSubview(sendButton)
        self.enableDisableSendButton(self.textView)
    }
    
    private func setupSendButtonConstraints() {
        self.sendButton.translatesAutoresizingMaskIntoConstraints = false
        let rightConstraint = NSLayoutConstraint(item: self, attribute: .Right, relatedBy: .Equal, toItem: self.sendButton, attribute: .Right, multiplier: 1.0, constant: textViewInsets.right)
        let bottomConstraint = NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: self.sendButton, attribute: .Bottom, multiplier: 1.0, constant: textViewInsets.bottom)
        sendButtonWidthConstraint = NSLayoutConstraint(item: self.sendButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: sendButtonDefaultWidth)
        sendButtonHeightConstraint = NSLayoutConstraint(item: self.sendButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: sendButtonDefaultHeight)
        self.addConstraints([sendButtonHeightConstraint, sendButtonWidthConstraint, rightConstraint, bottomConstraint])
    }
    
    private func setupTextViewConstraints() {
        self.textView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: self.textView, attribute: .Top, multiplier: 1.0, constant: -textViewInsets.top)
        let leftConstraint = NSLayoutConstraint(item: self, attribute: .Left, relatedBy: .Equal, toItem: self.textView, attribute: .Left, multiplier: 1, constant: -textViewInsets.left)
        let bottomConstraint = NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: self.textView, attribute: .Bottom, multiplier: 1, constant: textViewInsets.bottom)
        let rightConstraint = NSLayoutConstraint(item: self.textView, attribute: .Right, relatedBy: .Equal, toItem: self.sendButton, attribute: .Left, multiplier: 1, constant:0.0)
        heightConstraint = NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.00, constant: 40)
        self.addConstraints([topConstraint, leftConstraint, bottomConstraint, rightConstraint, heightConstraint])
    }
    
    private func setupBlurredBackgroundView() {
        self.addSubview(self.blurredBackgroundView)
        self.sendSubviewToBack(self.blurredBackgroundView)
    }
    
    private func setupBlurredBackgroundViewConstraints() {
        self.blurredBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: self.blurredBackgroundView, attribute: .Top, multiplier: 1.0, constant: 0)
        let leftConstraint = NSLayoutConstraint(item: self, attribute: .Left, relatedBy: .Equal, toItem: self.blurredBackgroundView, attribute: .Left, multiplier: 1.0, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: self.blurredBackgroundView, attribute: .Bottom, multiplier: 1.0, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: self, attribute: .Right, relatedBy: .Equal, toItem: self.blurredBackgroundView, attribute: .Right, multiplier: 1.0, constant: 0)
        self.addConstraints([topConstraint, leftConstraint, bottomConstraint, rightConstraint])
    }
    
    private func stylize() {
        self.textView.backgroundColor = Appearance.textViewBackgroundColor
        self.sendButton.tintColor = Appearance.tintColor
        self.textView.tintColor = Appearance.tintColor
        self.textView.textColor = Appearance.textViewTextColor
        self.backgroundColor = Appearance.backgroundColor
    }
    
    func sizeableTextViewDidChangeSize(textView: SizeableTextView) {
        let textViewHeight = CGRectGetHeight(textView.bounds)
        if textView.text.characters.count == 0 {
            let minHeight = self.textView.font.lineHeight + textViewInsets.top + textViewInsets.bottom
            self.sendButtonHeightConstraint.constant = minHeight
        }
        let targetConstant = textViewHeight + textViewInsets.top + textViewInsets.bottom
        self.heightConstraint.constant = targetConstant
        self.delegate?.customTextViewDidResize?(self)
        
        var contentHeight = textView.contentSize.height
        contentHeight -= textView.textContainerInset.top + textView.textContainerInset.bottom
        let lines = fabsf(Float(contentHeight)/Float(textView.font.lineHeight))
        if (lines >= 2 && showCharCount == true){
            self.wordLimitLabel.hidden = false
            self.updateCharCounter()
        }
        else{
            self.wordLimitLabel.hidden = true
        }
    }
    
    func cTRangeIntersectsRange(range1:NSRange,range2:NSRange) -> Bool{
        if(range1.location > range2.location + range2.length)
        {
            return false
        }
        if(range2.location > range1.location + range1.length)
        {
            return false
        }
        return true;
    }
    
    func updateCharCounter(){
        if (showCharCount == true){
            if let maxChar = self.maxCharCount{
                let currentChar = self.textView.text.characters.count
                self.wordLimitLabel.text = "\(currentChar)/\(maxChar)"
                self.delegate?.updateCharacterCount?(currentChar, maxChar: maxChar)
            }
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        self.updateCharCounter()
        self.enableDisableSendButton(textView)
        self.delegate?.textViewDidChange?(textView)
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if(self.isCharCountAllowed(textView, text: text, range: range)){
            if (range.location == 0 && (text == " " || text == "\n")) {
                return false
            }
            else {
                return true
            }
        }
        else {
            return false
        }
    }
    
    func isCharCountAllowed(textView:UITextView,text:String,range:NSRange) -> Bool{
        if maxCharCount != nil {
            return textView.text.characters.count + (text.characters.count - range.length) <= maxCharCount
        }
        else{
            return true
        }
    }
    
    func textViewDidChangeSelection(textView: UITextView) {
        self.textView.correctExtraBottomSpace()
        self.delegate?.textViewDidChangeSelection?(textView)
    }
    
    func sendButtonPressed(sender: UIButton) {
        
        if self.textView.text.characters.count > 0 {
            self.delegate?.customTextView?(self, didSendMessage: self.textView.text)
            self.textView.text = ""
        }
        self.updateCharCounter()
        self.enableDisableSendButton(self.textView)
    }
    
    func enableDisableSendButton(textView: UITextView){
        if var text = textView.text{
            let spaceNewLineChar = NSCharacterSet.whitespaceAndNewlineCharacterSet()
            text = text.stringByTrimmingCharactersInSet(spaceNewLineChar)
            if (text.characters.count > 0){
                self.sendButton.enabled = true
            }
            else{
                self.sendButton.enabled = false
            }
        }
        else{
            self.sendButton.enabled = false
        }
    }

}

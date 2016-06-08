//
//  SizeableTextView.swift
//  CustomTextViewExample
//
//  Created by Sunil Sharma on 08/06/16.
//  Copyright © 2016 Sunil Sharma. All rights reserved.
//

import UIKit

//Delegate
@objc protocol SizeableTextViewDelegate:UITextViewDelegate {
    func sizeableTextViewDidChangeSize(chatTextView: SizeableTextView)
}

class SizeableTextView: UITextView,NSLayoutManagerDelegate {
    weak var sizeableTextViewDelegate: SizeableTextViewDelegate?
    
    var minHeight:CGFloat = 30{
        didSet{
            if (minHeight > maxHeight){
                minHeight = maxHeight
            }
        }
    }
    var maxHeight: CGFloat = 90 {
        didSet{
            if (maxHeight < minHeight){
                maxHeight = minHeight
            }
        }
    }
    
    // MARK: Private Properties
    private var maxSize: CGSize {
        get {
            return CGSize(width: CGRectGetWidth(self.bounds), height: self.maxHeight)
        }
    }
    
    private let sizingTextView = UITextView()
    
    private var displayPlaceholder: Bool = true {
        didSet {
            if oldValue != self.displayPlaceholder {
                self.setNeedsDisplay()
            }
        }
    }
    
    private func updatePlaceholder() {
        self.displayPlaceholder = self.text.characters.count == 0
    }
    
    // MARK: Property Overrides
    override var contentSize: CGSize {
        didSet {
            resize()
        }
    }
    
    override var font: UIFont! {
        didSet {
            sizingTextView.font = font
        }
    }
    
    override var textContainerInset: UIEdgeInsets {
        didSet {
            sizingTextView.textContainerInset = textContainerInset
        }
    }
    
    override var text: String! {
        didSet {
            self.updatePlaceholder()
        }
    }
    
    override var attributedText: NSAttributedString!{
        didSet{
            self.updatePlaceholder()
        }
    }
    
    var placeholderAttributedText: NSAttributedString? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setNeedsDisplay()
    }
    
    
    
    override func drawRect(rect: CGRect) {
        
        super.drawRect(rect)
        guard self.displayPlaceholder == true else {
            return
        }
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = self.textAlignment
        let targetRect = CGRect(x: 8, y: 5 + self.contentInset.top, width: self.frame.size.width - self.contentInset.left, height: self.frame.size.height - self.contentInset.top)
        let attributedString = self.placeholderAttributedText
        attributedString?.drawInRect(targetRect)
        
    }
    
    override init(frame: CGRect = CGRectZero, textContainer: NSTextContainer? = nil) {
        super.init(frame: frame, textContainer: textContainer);
        self.contentMode = .Redraw
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        //fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        font = UIFont.systemFontOfSize(16.0)
        textContainerInset = UIEdgeInsets(top: 5, left: 2, bottom: 5, right: 2)
        self.addNotifications()
        self.dataDetectorTypes = .All
        self.selectable = true
        self.layoutManager.allowsNonContiguousLayout = false
    }
    
    func layoutManager(layoutManager: NSLayoutManager, lineSpacingAfterGlyphAtIndex glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return 5
    }
    
    func addNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SizeableTextView.textDidChangeNotification(_:)), name: UITextViewTextDidChangeNotification, object: self)
    }
    
    func removeNotifications(){
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: Sizing
    
    func resize() {
        bounds.size.height = self.targetHeight()
        sizeableTextViewDelegate?.sizeableTextViewDidChangeSize(self)
    }
    
    func targetHeight() -> CGFloat {
        sizingTextView.text = self.text
        let targetSize = sizingTextView.sizeThatFits(maxSize)
        var targetHeight = targetSize.height
        let maxHeights = self.maxHeight
        if (targetHeight < minHeight){
            targetHeight = minHeight
        }
        else if(targetHeight > maxHeight){
            targetHeight = maxHeights
        }
        return targetHeight
    }
    
    func correctExtraBottomSpace() {
        guard let end = self.selectedTextRange?.end, let caretRect: CGRect = self.caretRectForPosition(end) else { return }
        
        let topOfLine = CGRectGetMinY(caretRect)
        let bottomOfLine = CGRectGetMaxY(caretRect)
        
        let contentOffsetTop = self.contentOffset.y
        let bottomOfVisibleTextArea = contentOffsetTop + CGRectGetHeight(self.bounds)
        
        /*
         If the caretHeight and the inset padding is greater than the total bounds then we are on the first line.
         */
        
        let caretHeightPlusInsets = CGRectGetHeight(caretRect) + self.textContainerInset.top + self.textContainerInset.bottom
        if caretHeightPlusInsets < CGRectGetHeight(self.bounds) {
            var overflow: CGFloat = 0.0
            if topOfLine < contentOffsetTop + self.textContainerInset.top {
                overflow = topOfLine - contentOffsetTop - self.textContainerInset.top
            } else if bottomOfLine > bottomOfVisibleTextArea - self.textContainerInset.bottom {
                overflow = (bottomOfLine - bottomOfVisibleTextArea) + self.textContainerInset.bottom
            }
            self.contentOffset.y += overflow
        }
    }
    
    private dynamic func textDidChangeNotification(notification: NSNotification) {
        self.updatePlaceholder()
    }

    deinit {
        self.removeNotifications()
    }
}


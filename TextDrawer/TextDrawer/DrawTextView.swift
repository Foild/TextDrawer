//
//  DrawTextView.swift
//
//
//  Created by Remi Robert on 11/07/15.
//
//

import Masonry

class CustomLabel: UILabel {
    override func drawTextInRect(rect: CGRect) {
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(0, 5, 0, 5)))
    }
}

public class DrawTextView: UIView {
    
    var labels = NSMutableArray()
    var currentLabel: CustomLabel?
    
    var text: String! {
        didSet {
            if let current = currentLabel {
                current.text = text
                self.sizeTextLabel(current)
            }
        }
    }
    
    init() {
        super.init(frame: CGRectZero)
        layer.masksToBounds = true
        backgroundColor = UIColor.clearColor()
    }
    
    func addLabel(completion: ((label: UILabel) -> Void)? = nil) {
        let label = CustomLabel()
        label.text = "Enter text"
        label.font = label.font.fontWithSize(44)
        label.textAlignment = NSTextAlignment.Center
        label.numberOfLines = 0
        label.textColor = UIColor.blackColor()
        label.userInteractionEnabled = true
        label.center = self.center
        self.sizeTextLabel(label)
        
        addSubview(label)
        
        //        label.mas_makeConstraints { (make: MASConstraintMaker!) -> Void in
        //            make.right.and().left().equalTo()(self)
        //            make.centerY.equalTo()(self)
        //            make.centerX.equalTo()(self)
        //        }
        
        completion?(label: label)
        
        self.labels.addObject(label)
        self.currentLabel = label
    }
    
    func removeCurrentLabel() {
        if currentLabel != nil {
            labels.removeObject(currentLabel!)
            currentLabel?.removeFromSuperview()
            currentLabel = nil
        }
    }
    
    func removeLabel(label: CustomLabel) {
        if labels.containsObject(label) {
            label.removeFromSuperview()
            labels.removeObject(label)
            
            if label == currentLabel {
                currentLabel = nil
            }
        }
    }
    
    func removeLast() {
        labels.removeLastObject()
    }
    
    func removeAll() {
        labels.removeAllObjects()
    }
    
    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            if labels.containsObject(touch.view!) {
                if let label = touch.view as? CustomLabel {
                    self.currentLabel = label
                }
            }
        }
    }
    
    func sizeTextLabel(textLabel: CustomLabel) {
        let transform = textLabel.transform
        textLabel.transform = CGAffineTransformIdentity
        let oldCenter = textLabel.center
        let styleText = NSMutableParagraphStyle()
        styleText.alignment = NSTextAlignment.Center
        let attributsText = [NSParagraphStyleAttributeName:styleText, NSFontAttributeName:UIFont.boldSystemFontOfSize(textLabel.font.pointSize)]
        let sizeParentView = CGSizeMake(CGRectGetWidth(superview!.frame) - 10, CGRectGetHeight(superview!.frame) - 10)
        let sizeTextLabel = (NSString(string: textLabel.text!)).boundingRectWithSize(superview!.frame.size, options: NSStringDrawingOptions.UsesDeviceMetrics, attributes: attributsText, context: nil)
        textLabel.frame.size = CGSizeMake(sizeTextLabel.width + 10, sizeTextLabel.height + 10)
        textLabel.center = oldCenter
        textLabel.transform = transform
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

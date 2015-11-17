//
//  DrawTextView.swift
//
//
//  Created by Remi Robert on 11/07/15.
//
//

import Masonry

class CustomLabel: UILabel {
    
    var rotateView: UIView!
    var currentRadians: CGFloat = 0.0
    
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
        //        layer.masksToBounds = true
        self.clipsToBounds = false
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
        for label in labels {
            hideHandles(label as! CustomLabel)
        }
        showHandles(label)
        //        rotateView = UIView(frame: CGRectMake(label.frame.width - 25, label.frame.height - 25, 25, 25))
        //        rotateView.backgroundColor = UIColor.greenColor()
        //        label.addSubview(rotateView)
        
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
    
    func hideHandles(label: CustomLabel) {
        label.rotateView.alpha = 0
    }
    
    func showHandles(label: CustomLabel) {
        label.rotateView.alpha = 1.0
    }
    
    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            if labels.containsObject(touch.view!) {
                for label in labels {
                    hideHandles(label as! CustomLabel)
                }
                if let label = touch.view as? CustomLabel {
                    self.currentLabel = label
                    showHandles(currentLabel!)
                }
            } else {
                for label in labels {
                    hideHandles(label as! CustomLabel)
                }
            }
        }
    }
    
    public override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            if labels.containsObject(touch.view!) {
                for label in labels {
                    hideHandles(label as! CustomLabel)
                }
                if let label = touch.view as? CustomLabel {
                    self.currentLabel = label
                    showHandles(currentLabel!)
                }
            }
        }
    }
    
    public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            if labels.containsObject(touch.view!) {
                for label in labels {
                    hideHandles(label as! CustomLabel)
                }
                if let label = touch.view as? CustomLabel {
                    self.currentLabel = label
                    showHandles(currentLabel!)
                }
            }
        }
        for label in labels {
            label.layer.borderWidth = 0
        }
    }
    
    func applyRotation(byAmount: CGFloat) {
        
        self.currentLabel?.transform = CGAffineTransformRotate((currentLabel?.transform)!, byAmount)
        self.currentLabel?.currentRadians += byAmount
        self.currentLabel?.layer.borderColor = self.currentLabel?.textColor.CGColor
        self.currentLabel?.layer.borderWidth = 1
        print("Transforming")
    }
    
    func sizeTextLabel(textLabel: CustomLabel) {
        for sub in textLabel.subviews {
            sub.removeFromSuperview()
        }
        let transform = textLabel.transform
        textLabel.transform = CGAffineTransformIdentity
        let oldCenter = textLabel.center
        let styleText = NSMutableParagraphStyle()
        styleText.alignment = NSTextAlignment.Center
        let attributsText = [NSParagraphStyleAttributeName:styleText, NSFontAttributeName:UIFont.boldSystemFontOfSize(textLabel.font.pointSize)]
        let sizeParentView = CGSizeMake(CGRectGetWidth(superview!.frame) - 10, CGRectGetHeight(superview!.frame) - 10)
        let sizeTextLabel = (NSString(string: textLabel.text!)).boundingRectWithSize(superview!.frame.size, options: NSStringDrawingOptions.UsesDeviceMetrics, attributes: attributsText, context: nil)
        textLabel.frame.size = CGSizeMake(sizeTextLabel.width + 50, sizeTextLabel.height + 50)
        textLabel.center = oldCenter
        textLabel.transform = transform
        textLabel.rotateView = UIView(frame: CGRectMake(textLabel.bounds.width - 15, textLabel.bounds.height - 15, 30, 30))
        let image = UIImageView()
        image.bounds = textLabel.rotateView.bounds
        image.image = UIImage(named: "text-rotate")
        image.layer.cornerRadius = 15
        image.layer.borderColor = UIColor.whiteColor().CGColor
        image.layer.borderWidth = 1
        image.contentMode = UIViewContentMode.ScaleToFill
        image.clipsToBounds = true
        image.backgroundColor = UIColor(red: 80/255, green: 227/255, blue: 194/255, alpha: 1)
        textLabel.addSubview(textLabel.rotateView)
        textLabel.rotateView.addSubview(image)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
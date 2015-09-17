//
//  DrawView.swift
//  
//
//  Created by Remi Robert on 11/07/15.
//
//

//Scrux

import UIKit
import Masonry

public typealias TextDrawerTouched = ((drawerView: TextDrawer) -> Void)

public class TextDrawer: UIView, TextEditViewDelegate {
    
    private var textEditView: TextEditView!
    private var drawTextView: DrawTextView!
    
    private var initialTransformation: CGAffineTransform!
    private var initialCenterDrawTextView: CGPoint!
    private var initialRotationTransform: CGAffineTransform!
    private var initialReferenceRotationTransform: CGAffineTransform!
    
    private var activieGestureRecognizer = NSMutableSet()
    private var activeRotationGesture: UIRotationGestureRecognizer?
    private var activePinchGesture: UIPinchGestureRecognizer?
    
    private lazy var tapRecognizer: UITapGestureRecognizer! = {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "handleTapGesture:")
        tapRecognizer.delegate = self
        tapRecognizer.cancelsTouchesInView = false
        return tapRecognizer
        }()
    
    private lazy var panRecognizer: UIPanGestureRecognizer! = {
        let panRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        panRecognizer.delegate = self
        panRecognizer.cancelsTouchesInView = false
        return panRecognizer
        }()
    
    private lazy var rotateRecognizer: UIRotationGestureRecognizer! = {
        let rotateRecognizer = UIRotationGestureRecognizer(target: self, action: "handlePinchGesture:")
        rotateRecognizer.delegate = self
        rotateRecognizer.cancelsTouchesInView = false
        return rotateRecognizer
        }()
    
    private lazy var zoomRecognizer: UIPinchGestureRecognizer! = {
        let zoomRecognizer = UIPinchGestureRecognizer(target: self, action: "handlePinchGesture:")
        zoomRecognizer.delegate = self
        zoomRecognizer.cancelsTouchesInView = false
        return zoomRecognizer
        }()
    
    private lazy var deleteArea: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        return view
        }()
    
    private lazy var deleteIconView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.clearColor()
        view.clipsToBounds = true
        view.image = self.deleteIcon
        view.contentMode = UIViewContentMode.ScaleAspectFit
        
        view.transform = CGAffineTransformMakeScale(0.1, 0.1)
        view.alpha = 0
        
        return view
        }()
    
    public var deleteIcon: UIImage? {
        didSet {
            deleteIconView.image = deleteIcon
        }
    }
    
    public var textEditOffset: CGFloat = 0 {
        didSet {
            textEditView.topOffset = textEditOffset
        }
    }
    
    public var hasLabels: Bool {
        get {
            return self.drawTextView.labels.count > 0
        }
    }
    
    public var touchedDrawerBlock: TextDrawerTouched?
    
    public func clearText() {
        text = ""
    }
    
    public func resetTransformation() {
        drawTextView.transform = initialTransformation
        drawTextView.mas_updateConstraints({ (make: MASConstraintMaker!) -> Void in
            make.edges.equalTo()(self)
            make.centerX.and().centerY().equalTo()(self)
        })
        drawTextView.center = center
        //drawTextView.sizeTextLabel()
    }
    
    //MARK: -
    //MARK: Setup DrawView
    
    private func setup() {
        self.layer.masksToBounds = true
        drawTextView = DrawTextView()
        initialTransformation = drawTextView.transform
        addSubview(drawTextView)
        drawTextView.mas_makeConstraints { (make: MASConstraintMaker!) -> Void in
            make.edges.equalTo()(self)
        }
        
        textEditView = TextEditView()
        textEditView.delegate = self
        
        addSubview(textEditView)
        textEditView.mas_makeConstraints { (make: MASConstraintMaker!) -> Void in
            make.edges.equalTo()(self)
        }
        
        deleteArea.addSubview(deleteIconView)
        addSubview(deleteArea)
        
        deleteIconView.mas_makeConstraints { (make: MASConstraintMaker!) -> Void in
            make.center.equalTo()(self.deleteArea)
            make.height.mas_equalTo()(30)
            make.width.mas_equalTo()(30)
        }
        
        deleteArea.mas_makeConstraints { (make: MASConstraintMaker!) -> Void in
            make.right.and().left().equalTo()(self)
            make.height.equalTo()(50)
            make.centerX.equalTo()(self)
            make.bottom.equalTo()(self)
        }
        
        self.sendSubviewToBack(deleteArea)
        //        addGestureRecognizer(panRecognizer)
        addGestureRecognizer(rotateRecognizer)
        addGestureRecognizer(zoomRecognizer)
        
        initialReferenceRotationTransform = CGAffineTransformIdentity
    }
    
    public func addNewLabel() {
        self.drawTextView.addLabel { (label) -> Void in
            let tap = UITapGestureRecognizer(target: self, action: "handleTapGesture:")
            tap.delegate = self
            tap.cancelsTouchesInView = false
            label.addGestureRecognizer(tap)
            label.font = label.font.fontWithSize(44)
            
            let zoomRecognizer = UIPinchGestureRecognizer(target: self, action: "handlePinchGesture:")
            zoomRecognizer.delegate = self
            zoomRecognizer.cancelsTouchesInView = false
            
            let rotateRecognizer = UIRotationGestureRecognizer(target: self, action: "handlePinchGesture:")
            rotateRecognizer.delegate = self
            rotateRecognizer.cancelsTouchesInView = false
            
            let panRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
            panRecognizer.delegate = self
            panRecognizer.cancelsTouchesInView = false
            
            label.addGestureRecognizer(panRecognizer)
            
        }
    }
    
    //MARK: -
    //MARK: Initialisation
    
    init() {
        super.init(frame: CGRectZero)
        setup()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func textEditViewFinishedEditing(text: String) {
        textEditView.hidden = true
        drawTextView.text = text
    }
    
    //MARK: -
    //MARK: Editing
    public func removeAll() {
        self.drawTextView.removeAll()
    }
    
    public func removeLast() {
        self.drawTextView.removeLast()
    }
}

//MARK: -
//MARK: Proprety extension

public extension TextDrawer {
    
    public var fontSize: CGFloat! {
        set {
            drawTextView.currentLabel?.font = drawTextView.currentLabel?.font.fontWithSize(newValue)
        }
        get {
            return  drawTextView.currentLabel?.font.pointSize
        }
    }
    
    public var font: UIFont! {
        set {
            drawTextView.currentLabel?.font = newValue
        }
        get {
            return drawTextView.currentLabel?.font
        }
    }
    
    public var textColor: UIColor! {
        set {
            drawTextView.currentLabel?.textColor = newValue
        }
        get {
            return drawTextView.currentLabel?.textColor
        }
    }
    
    public var textAlignement: NSTextAlignment! {
        set {
            drawTextView.currentLabel?.textAlignment = newValue
        }
        get {
            return drawTextView.currentLabel?.textAlignment
        }
    }
    
    public var textBackgroundColor: UIColor! {
        set {
            drawTextView.currentLabel?.backgroundColor = newValue
        }
        get {
            return drawTextView.currentLabel?.backgroundColor
        }
    }
    
    public var text: String! {
        set {
            drawTextView.text = newValue
        }
        get {
            return drawTextView.text
        }
    }
    
    public var textSize: Int! {
        set {
            textEditView.textSize = newValue
        }
        get {
            return textEditView.textSize
        }
    }
}

//MARK: -
//MARK: Gesture handler extension

extension TextDrawer: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if gestureRecognizer.isKindOfClass(UITapGestureRecognizer) {
            return true
        } else {
            return drawTextView.currentLabel != nil
        }
    }
    
    func handleTapGesture(recognizer: UITapGestureRecognizer) {
        if let label = recognizer.view as? CustomLabel {
            self.drawTextView.currentLabel = label
        }
        
        textEditView.textEntry = drawTextView.currentLabel?.text
        textEditView.isEditing = true
        textEditView.hidden = false
        touchedDrawerBlock?(drawerView: self)
    }
    
    func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translationInView(self)
        switch recognizer.state {
        case .Began, .Ended, .Failed, .Cancelled:
            if let label = recognizer.view as? CustomLabel {
                self.drawTextView.currentLabel = label
            }
            initialCenterDrawTextView = drawTextView.currentLabel?.center
            touchedDrawerBlock?(drawerView: self)
            
            UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 2, options: UIViewAnimationOptions(), animations: {
                self.deleteIconView.transform = recognizer.state == .Began ? CGAffineTransformIdentity : CGAffineTransformMakeScale(0.1, 0.1)
                self.deleteIconView.alpha = recognizer.state == .Began ? 1 : 0
                }, completion: nil)
            
            if recognizer.state == .Ended {
                let convertedCenter = self.convertPoint(self.drawTextView.currentLabel!.center, fromView: self.drawTextView)
                var deletePoint = CGRectMake(CGRectGetMinX(deleteIconView.frame)-10, CGRectGetMinY(self.deleteArea.frame), 50, 50)
                
                if CGRectContainsPoint(self.deleteArea.frame, convertedCenter) {
                    self.drawTextView.removeCurrentLabel()
                }
            }
        case .Changed:
            let convertedCenter = self.convertPoint(self.drawTextView.currentLabel!.center, fromView: self.drawTextView)
            var deletePoint = CGRectMake(CGRectGetMinX(deleteIconView.frame)-10, CGRectGetMinY(self.deleteArea.frame), 50, 50)
            
            let isHoveringDelete = CGRectContainsPoint(self.deleteArea.frame, convertedCenter)
            UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 2, options: UIViewAnimationOptions(), animations: {
                self.deleteIconView.transform = isHoveringDelete ? CGAffineTransformMakeScale(1.2, 1.2) : CGAffineTransformIdentity
                }, completion: nil)
            
            drawTextView.currentLabel?.center = CGPointMake(initialCenterDrawTextView.x + translation.x,
                initialCenterDrawTextView.y + translation.y)
        default: return
        }
    }
    
    func handlePinchGesture(recognizer: UIGestureRecognizer) {
        var transform = initialRotationTransform
        
        switch recognizer.state {
        case .Began:
            if let label = recognizer.view as? CustomLabel {
                self.drawTextView.currentLabel = label
            }
            if activieGestureRecognizer.count == 0 {
                initialRotationTransform = drawTextView.currentLabel?.transform
            }
            activieGestureRecognizer.addObject(recognizer)
            break
            
        case .Changed:
            for currentRecognizer in activieGestureRecognizer {
                transform = applyRecogniser(currentRecognizer as? UIGestureRecognizer, currentTransform: transform)
            }
            drawTextView.currentLabel?.transform = transform
            break
            
        case .Ended, .Failed, .Cancelled:
            initialRotationTransform = applyRecogniser(recognizer, currentTransform: initialRotationTransform)
            activieGestureRecognizer.removeObject(recognizer)
            touchedDrawerBlock?(drawerView: self)
        default: return
        }
        
    }
    
    private func applyRecogniser(recognizer: UIGestureRecognizer?, currentTransform: CGAffineTransform) -> CGAffineTransform {
        if let recognizer = recognizer {
            if recognizer is UIRotationGestureRecognizer {
                return CGAffineTransformRotate(currentTransform, (recognizer as! UIRotationGestureRecognizer).rotation)
            }
            if recognizer is UIPinchGestureRecognizer {
                let scale = (recognizer as! UIPinchGestureRecognizer).scale
                return CGAffineTransformScale(currentTransform, scale, scale)
            }
        }
        return currentTransform
    }
}

//MARK: -
//MARK: Render extension

public extension TextDrawer {
    
    public func render() -> UIImage? {
        return renderTextOnView(self)
    }
    
    public func renderTextOnView(view: UIView) -> UIImage? {
        let size = UIScreen.mainScreen().bounds.size
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
        
        view.layer.renderInContext(UIGraphicsGetCurrentContext())
        let img = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return renderTextOnImage(img)
    }
    
    public func renderTextOnImage(image: UIImage) -> UIImage? {
        let size = image.size
        let scale = size.width / CGRectGetWidth(self.bounds)
        let color = layer.backgroundColor
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
        
        image.drawInRect(CGRectMake(CGRectGetWidth(self.bounds) / 2 - (image.size.width / scale) / 2,
            CGRectGetHeight(self.bounds) / 2 - (image.size.height / scale) / 2,
            image.size.width / scale,
            image.size.height / scale))
        layer.backgroundColor = UIColor.clearColor().CGColor
        layer.renderInContext(UIGraphicsGetCurrentContext())
        layer.backgroundColor = color
        
        
        let drawnImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return UIImage(CGImage: drawnImage.CGImage, scale: 1, orientation: drawnImage.imageOrientation)
    }
}

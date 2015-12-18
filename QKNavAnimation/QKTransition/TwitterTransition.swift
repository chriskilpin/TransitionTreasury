//
//  PingTransition.swift
//  StudyAnimation
//
//  Created by 宋宋 on 12/11/15.
//  Copyright © 2015 宋宋. All rights reserved.
//

/*   支持横屏。但不支持实时旋转
*/

import UIKit
/// OMIN 具体实现
public class TwitterTransition: NSObject, QKViewControllerAnimatedTransitioning {
    
    public var transitionStatus: TransitionStatus?
    
    public var transitionContext: UIViewControllerContextTransitioning?
    
    public var cancelPop: Bool = false
    
    public var interacting: Bool = false
    
    private var anchorPointBackup: CGPoint?
    
    private var positionBackup: CGPoint?
    
    init(status: TransitionStatus) {
        transitionStatus = status
        super.init()
    }
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        var fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        var toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        let containView = transitionContext.containerView()
        let screenBounds = UIScreen.mainScreen().bounds
        var angle = M_PI/48
        var transform = CATransform3DIdentity
        
        var startFrame = CGRectOffset(screenBounds, 0, screenBounds.size.height)
        var finalFrame = screenBounds
        
        if transitionStatus == .Dismiss {
            swap(&fromVC, &toVC)
            swap(&startFrame, &finalFrame)
            angle = -angle
        }
        if transitionStatus == .Present {
            transform.m34 = -1.0/500.0
            transform = CATransform3DRotate(transform, CGFloat(angle), 1, 0, 0)
            anchorPointBackup = fromVC?.view.layer.anchorPoint
            positionBackup = fromVC?.view.layer.position
            fromVC?.view.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
            fromVC?.view.layer.position = CGPoint(x: fromVC!.view.layer.position.x, y: fromVC!.view.layer.position.y + fromVC!.view.layer.bounds.height / 2)
        }
        
        toVC?.view.layer.frame = startFrame

        containView?.addSubview(fromVC!.view)
        containView?.addSubview(toVC!.view)

        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: .CurveEaseInOut, animations: {
            fromVC?.view.layer.transform = transform
            toVC?.view.layer.frame = finalFrame
            }) { (finished) -> Void in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                if self.transitionStatus == .Dismiss {
                    fromVC?.view.layer.anchorPoint = self.anchorPointBackup ?? CGPoint(x: 0.5, y: 0.5)
                    fromVC?.view.layer.position = self.positionBackup ?? CGPoint(x: fromVC!.view.layer.position.x, y: fromVC!.view.layer.position.y - fromVC!.view.layer.bounds.height / 2)
                    print(fromVC?.view.layer.position)
                }
        }
    }
}

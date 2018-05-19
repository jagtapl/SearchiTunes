//
//  DimmingPresentationController.swift
//  SearchiTunes
//
//  Created by LALIT JAGTAP on 5/18/18.
//  Copyright © 2018 LALIT JAGTAP. All rights reserved.
//

import UIKit

class DimmingPresentationController: UIPresentationController {
    override var shouldRemovePresentersView: Bool {
        return false
    }
    
    lazy var dimmingView = GradientView(frame: CGRect.zero)
    
    override func presentationTransitionWillBegin() {
        dimmingView.frame = containerView!.bounds
        containerView!.insertSubview(dimmingView, at: 0)
        
        // Animate background gradient view
        dimmingView.alpha = 0
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { _ in self.dimmingView.alpha = 1}, completion: nil)
        }
    }
    
    // animate gradient view out of sight when detail pop is dismissed
    // animates alpha back to 0% to make gradient view fade out
    override func dismissalTransitionWillBegin() {
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { _ in self.dimmingView.alpha = 0}, completion: nil)
        }
    }
}

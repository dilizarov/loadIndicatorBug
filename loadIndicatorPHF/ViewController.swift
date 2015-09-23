//
//  ViewController.swift
//  loadIndicatorPHF
//
//  Created by David Ilizarov on 9/23/15.
//  Copyright (c) 2015 Bug. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PHFComposeBarViewDelegate {

    // This is used to mitigate the iOS 8 bug regarding inputAccessoryView
    @IBOutlet var containerView: ContainerView!
    
    var composeBarView: PHFComposeBarView {
        var viewBounds = self.view
        var frame = CGRectMake(0, viewBounds.frame.height - PHFComposeBarViewInitialHeight, viewBounds.frame.width, PHFComposeBarViewInitialHeight)
        
        var composeBarView = PHFComposeBarView(frame: frame)
        
        composeBarView.maxLinesCount = 6
        composeBarView.placeholder = "Write some text"
        composeBarView.buttonTitle = "Reply"
        composeBarView.delegate = self
        
        composeBarView.textView.backgroundColor = UIColor.whiteColor()
        
        return composeBarView
    }
    
    // Press the button after typing a bit to enable it. Then, wait 5 seconds. It should, but won't stopLoading.
    func composeBarViewDidPressButton(composeBarView: PHFComposeBarView!) {
        composeBarView.startLoading()
        
        let delay = 5.0 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(time, dispatch_get_main_queue(), {
            self.composeBarView.stopLoading()
        })
    }
    
    override var inputAccessoryView: UIView {
        return self.containerView.customInputView
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.containerView.customInputView = self.composeBarView
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


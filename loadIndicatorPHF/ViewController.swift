//
//  ViewController.swift
//  loadIndicatorPHF
//
//  Created by David Ilizarov on 9/23/15.
//  Copyright (c) 2015 Bug. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PHFComposeBarViewDelegate, UITableViewDataSource, UITableViewDelegate {

    // This is used to mitigate the iOS 8 bug regarding inputAccessoryView
    @IBOutlet var containerView: ContainerView!
    @IBOutlet var tableView: UITableView!
    
    var strings = ["placeholder", "wow", "this", "is", "a", "comment", "for the ages", "YEP YEP YEP YEP AEWPTOMA AWET AWT AMWT LAWT WLT LAWKE GAWL GALW KT", "WETATAWTAWTE AWT AWTAWTAWT'W ,", "WATLQWT QT AE", "waegla gaew gal;kw g wlegka wjgwgwalg we gka fkjwaef akwjef jwaekf kwae fkajwe fjka gke wkag awgja;g ", "wgnkawg akwgl gwa gawl gaj aw fkwa eawjlq rj wreqoiradfa", "k wawlgnaw wefiebf wk kw vka k wkjf wek gkjaw ge g tewr oiqweuroaweurpasf pasfu pfu pup aupurp awu pwetu p uoa uputapwutwout waputpawu tpaweut pwue tpuatpueawpt uawpt uawpetu wtu we tuowu ouut oewutpawut pawuetp aup upasue tuwpghgoah oghao ahohhqtwej la", "wow", "this", "is", "a", "comment", "for the ages", "YEP YEP YEP YEP AEWPTOMA AWET AWT AMWT LAWT WLT LAWKE GAWL GALW KT", "WETATAWTAWTE AWT AWTAWTAWT'W ,", "WATLQWT QT AE", "waegla gaew gal;kw g wlegka wjgwgwalg we gka fkjwaef akwjef jwaekf kwae fkajwe fjka gke wkag awgja;g ", "wgnkawg akwgl gwa gawl gaj aw fkwa eawjlq rj wreqoiradfa", "k wawlgnaw wefiebf wk kw vka k wkjf wek gkjaw ge g tewr oiqweuroaweurpasf pasfu pfu pup aupurp awu pwetu p uoa uputapwutwout waputpawu tpaweut pwue tpuatpueawpt uawpt uawpetu wtu we tuowu ouut oewutpawut pawuetp aup upasue tuwpghgoah oghao ahohhqtwej la", "wow", "this", "is", "a", "comment", "for the ages", "YEP YEP YEP YEP AEWPTOMA AWET AWT AMWT LAWT WLT LAWKE GAWL GALW KT", "WETATAWTAWTE AWT AWTAWTAWT'W ,", "WATLQWT QT AE", "waegla gaew gal;kw g wlegka wjgwgwalg we gka fkjwaef akwjef jwaekf kwae fkajwe fjka gke wkag awgja;g ", "wgnkawg akwgl gwa gawl gaj aw fkwa eawjlq rj wreqoiradfa", "k wawlgnaw wefiebf wk kw vka k wkjf wek gkjaw ge g tewr oiqweuroaweurpasf pasfu pfu pup aupurp awu pwetu p uoa uputapwutwout waputpawu tpaweut pwue tpuatpueawpt uawpt uawpetu wtu we tuowu ouut oewutpawut pawuetp aup upasue tuwpghgoah oghao ahohhqtwej la", "wow", "this", "is", "a", "comment", "for the ages"]

    
    var cachedHeights = [Int: CGFloat]()
    
    @IBAction func scrollDown(sender: AnyObject) {
        self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: self.strings.count - 1, inSection: 0), atScrollPosition: .Bottom, animated: true)
    }
    
    
    lazy var composeBarView: PHFComposeBarView = {
        var viewBounds = self.view
        var frame = CGRectMake(0, viewBounds.frame.height - PHFComposeBarViewInitialHeight, viewBounds.frame.width, PHFComposeBarViewInitialHeight)
        
        var composeBarView = PHFComposeBarView(frame: frame)
        
        composeBarView.maxLinesCount = 6
        composeBarView.placeholder = "Write some text"
        composeBarView.buttonTitle = "Reply"
        composeBarView.delegate = self
        
        composeBarView.textView.backgroundColor = UIColor.whiteColor()
        
        return composeBarView
    }()
    
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
    
    func stop() {
        self.composeBarView.stopLoading()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.strings.count
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        self.cachedHeights[indexPath.row] = cell.frame.size.height
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let height = cachedHeights[indexPath.row] {
            return height
        } else {
            return 70
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as!UITableViewCell
        
        (cell.viewWithTag(5) as! UILabel).text = strings[indexPath.row]
        
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "stop", name: "STOP", object: nil)
        
        self.containerView.customInputView = self.composeBarView
        tableView.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


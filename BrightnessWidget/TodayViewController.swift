//
//  TodayViewController.swift
//  BrightnessWidget
//
//  Created by 何榮森 on 2020/3/18.
//  Copyright © 2020 何榮森. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet weak var levelOneBtn: UIButton!
    @IBOutlet weak var levelTwoBtn: UIButton!
    @IBOutlet weak var levelThreeBtn: UIButton!
    
    @IBOutlet weak var customOneBtn: UIButton!
    @IBOutlet weak var customTwoBtn: UIButton!
    @IBOutlet weak var customThreeBtn: UIButton!
    
    /***********************************
     * LifeCycle Methods
     ***********************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        self.extensionContext?
            .widgetLargestAvailableDisplayMode = .expanded
        
        print("Widget is Loaded.")
        
        // read userdefault and modify the title of custom buttons
        customOneBtn.setTitle("自定:\n20%", for: UIControl.State.init())
        customTwoBtn.setTitle("自定:\n40%", for: UIControl.State.init())
        customThreeBtn.setTitle("自定:\n70%", for: UIControl.State.init())
        
        // set custom btns long clickable
        setCustomBtnLongPressGesture()
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetActiveDisplayModeDidChange(
        _ activeDisplayMode: NCWidgetDisplayMode,
        withMaximumSize maxSize: CGSize) {
        
        if activeDisplayMode == .expanded {
            // set widget max size
            self.preferredContentSize = CGSize(width: maxSize.width, height: 300)
            
            // show custom btns
            alphaAnimateCustomBtns(1.0)
        } else {
            // set widget back to original size
            self.preferredContentSize = maxSize
            
            // hide custom btns
            alphaAnimateCustomBtns(0)
        }
    }
    
    /***********************************
     * Click Listeners
     ***********************************/
    @IBAction func tappedOfOne(_ sender: UIButton) {
        adjustBrightness(0.0)
    }
    
    @IBAction func tappedOfTwo(_ sender: UIButton) {
        adjustBrightness(0.5)
    }
    
    @IBAction func tappedOfThree(_ sender: UIButton) {
        adjustBrightness(1.0)
    }
    
    @IBAction func tappedOfCusOne(_ sender: UIButton) {
        adjustBrightness(0.2)
    }
    
    @IBAction func tappedOfCusTwo(_ sender: UIButton) {
        adjustBrightness(0.4)
    }
    
    @IBAction func tappedOfCusThree(_ sender: UIButton) {
        adjustBrightness(0.7)
    }
    
    @objc private func cOneLongPressed(gesture: UILongPressGestureRecognizer) {
        longPressed(gesture, Btn.FirstBtn)
    }
    
    @objc private func cTwoLongPressed(gesture: UILongPressGestureRecognizer) {
        longPressed(gesture, Btn.SecondBtn)
    }
    
    @objc private func cThreeLongPressed(gesture: UILongPressGestureRecognizer) {
        longPressed(gesture, Btn.ThirdBtn)
    }
    
    private func longPressed(_ gesture: UILongPressGestureRecognizer, _ btn: Btn) {
        if gesture.state == UIGestureRecognizer.State.began {
            print("\(btnToInt(btn)) custom btn is long pressed.")
            goToApp(customBtn: btn)
        }
    }
    
    /***********************************
     * Custom Methods
     ***********************************/
    private func adjustBrightness(_ brightness: Double) {
        // set message
        var message = "調整亮度: "
        
        switch brightness {
        case 0.0 ..< 0.4:
            message += "暗"
        case 0.4 ..< 0.8:
            message += "普通"
        case 0.8 ... 1.0:
            message += "亮"
        default:
            message += "未知"
        }
        
        // show message
        showToast(message: "\(message)")
        
        // adjust brightness
        if (0.0...1.0).contains(brightness) {
            goToApp(brightness: brightness)
        } else {
            print("illegal brightness value")
        }
    }
    
    private func showToast(message : String) {
        // output
        print(message)
        
        // show toast label
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-50, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        
        // animate it
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    private func goToApp(brightness: Double) {
        let application = UIApplication.shared
        
        let targetAppPath = "brightness://adjust/\(brightness)"
        
        let appUrl = URL(string: targetAppPath)!
        
        let websiteUrl = URL(string: "http://google.com")!
        
        if application.canOpenURL(appUrl) {
            application.open(appUrl, options: [:], completionHandler: nil)
        } else {
            application.open(websiteUrl)
        }
    }
    
    private func goToApp(customBtn: Btn) {
        let application = UIApplication.shared
        
        let targetAppPath = "brightness://set/\(btnToInt(customBtn))"
        
        let appUrl = URL(string: targetAppPath)!
        
        let websiteUrl = URL(string: "http://google.com")!
        
        if application.canOpenURL(appUrl) {
            application.open(appUrl, options: [:], completionHandler: nil)
        } else {
            application.open(websiteUrl)
        }
    }
    
    private func alphaAnimateCustomBtns(_ alpha: Float) {
        UIView.animate(withDuration: 0.5) {
            let alpha = CGFloat(alpha)
            self.customOneBtn.alpha = alpha
            self.customTwoBtn.alpha = alpha
            self.customThreeBtn.alpha = alpha
        }
    }
    
    private func setCustomBtnLongPressGesture() {
        let duration = 1.5
        
        let firstLongPressedRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(cOneLongPressed(gesture:)))
        firstLongPressedRecognizer.minimumPressDuration = duration
        customOneBtn.addGestureRecognizer(firstLongPressedRecognizer)
        
        let secondLongPressedRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(cTwoLongPressed(gesture:)))
        secondLongPressedRecognizer.minimumPressDuration = duration
        customTwoBtn.addGestureRecognizer(secondLongPressedRecognizer)
        
        let thirdLongPressedRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(cThreeLongPressed(gesture:)))
        thirdLongPressedRecognizer.minimumPressDuration = duration
        customThreeBtn.addGestureRecognizer(thirdLongPressedRecognizer)
    }
    
    private func btnToInt(_ btn: Btn) -> Int{
        switch btn {
        case Btn.FirstBtn:
            return 1
        case Btn.SecondBtn:
            return 2
        case Btn.ThirdBtn:
            return 3
        }
    }
    
    enum Btn {
        case FirstBtn
        case SecondBtn
        case ThirdBtn
    }
}

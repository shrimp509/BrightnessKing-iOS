//
//  ViewController.swift
//  Practice
//
//  Created by 何榮森 on 2020/3/17.
//  Copyright © 2020 何榮森. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ViewControllerDelegate {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var indicator: UILabel!
    @IBOutlet weak var confirmChangeBtn: UIButton!
    @IBOutlet weak var modifyModeDescription: UILabel!
    @IBOutlet weak var modifyTargetIndicator: UILabel!
    
    private var backgroundAnimationLock = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialize slider value with current brightness
        print("initialize slider")
        updateThemeByBrightness()

        // fade out logo img
        animateAlphaLogoImg(show: false)
    }
    
    // value of slider is from 0.0 to 1.0
    @IBAction func adjustBrightness(_ sender: UISlider) {
        // adjust brightness
        adjust(sender.value)
    }
    
    func fromWidgetBackToApp(brightness: Float) {
        adjust(brightness)
    }
    
    func fromWidgetBackToApp(customNum: Int) {
        print("get custom num: \(customNum)")
        modifyModeDescription.isHidden = false
        confirmChangeBtn.isHidden = false
        modifyTargetIndicator.isHidden = false
        modifyTargetIndicator.text = "-- 現在修改的是 自訂\(customNum) --"
    }
    
    private func adjust(_ brightness: Float) {
        // set value
        UIScreen.main.brightness = CGFloat(brightness)
        
        // animate background with brightness level
        updateThemeByBrightness()
    }
    
    private func animateTheme(_ state: Bool) {
        var background = "off_background"
        var textColor = UIColor.white
        
        // check state
        if state {
            background = "on_background"
            textColor = UIColor.black
        }
        
        // animate theme
        if !backgroundAnimationLock {
            UIView.transition(with: self.background, duration: 1.0, options: .transitionCrossDissolve, animations: {
                // lock
                self.backgroundAnimationLock = true
                
                // change title color
                self.titleLabel.textColor = textColor
                
                // change indicator text color
                self.indicator.textColor = textColor
                
                // change background img
                self.background.image = UIImage.init(named: background)
            }, completion: { _ in
                // unlock
                self.backgroundAnimationLock = false
                
                // check current brightness level and adjust animation
                self.updateThemeByBrightness()
            })
        }
        
    }
    
    private func updateThemeByBrightness() {
        
        // background
        let currentBrightness = UIScreen.main.brightness
        if (currentBrightness <= 0.5) {
            self.animateTheme(false)
        } else {
            self.animateTheme(true)
        }
        
        // slider
        brightnessSlider.setValue(Float(currentBrightness), animated: true)
        
        // indicator
        indicator.text = String(format: "現在亮度: %.0f %%", currentBrightness * 100)
    }
    
    private func animateAlphaLogoImg(show: Bool) {
        var alpha = 0.0
        
        if show {
            alpha = 1.0
        }
        
        // animate logo img
        UIView.animate(withDuration: 1.0, delay: 0.8, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.logoImg.alpha = CGFloat(alpha)
        }, completion: nil)
    }
}


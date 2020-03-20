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
    
    private var backgroundAnimationLock = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialize slider value with current brightness
        print("initialize slider")
        checkThemeByBrightness()

        // fade out logo img
        animateAlphaLogoImg(show: false)
    }
    
    @IBAction func adjustBrightness(_ sender: UISlider) {
        // value of slider is from 0.0 to 1.0
        
        // adjust brightness
        adjust(sender.value)
    }
    
    func fromWidgetBackToApp(brightness: Float) {
        adjust(brightness)
    }
    
    private func adjust(_ brightness: Float) {
        // set value
        UIScreen.main.brightness = CGFloat(brightness)
        
        // animate background with brightness level
        checkThemeByBrightness()
    }
    
    private func animateTheme(_ state: Bool) {
        var background = "off_background"
        var titleColor = UIColor.white
        
        // check state
        if state {
            background = "on_background"
            titleColor = UIColor.black
        }
        
        // animate theme
        if !backgroundAnimationLock {
            UIView.transition(with: self.background, duration: 1.0, options: .transitionCrossDissolve, animations: {
                // lock
                self.backgroundAnimationLock = true
                
                // change title color
                self.titleLabel.textColor = titleColor
                
                // change background img
                self.background.image = UIImage.init(named: background)
            }, completion: { _ in
                // unlock
                self.backgroundAnimationLock = false
                
                // check current brightness level and adjust animation
                self.checkThemeByBrightness()
            })
        }
        
    }
    
    private func checkThemeByBrightness() {
        
        // background
        let currentBrightness = UIScreen.main.brightness
        if (currentBrightness <= 0.5) {
            self.animateTheme(false)
        } else {
            self.animateTheme(true)
        }
        
        // slider
        brightnessSlider.setValue(Float(currentBrightness), animated: true)
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


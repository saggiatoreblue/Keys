//
//  ViewController.swift
//  keys
//
//  Created by Michael Botelho  on 9/24/16.
//  Copyright © 2016 michaelbotelho. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {
    @IBOutlet weak var keys: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var checkLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var keysImage: UIImageView!
    let keysArray:Array = ["A", "B", "C", "D", "E", "F", "G"]
    var timer:Timer = Timer()
    var imageTimer:Timer = Timer()
    var currentValue:Int = 1
    var counter:TimeInterval = 1
    var currentIndex:Int = 0
    var timeType:String = "second"
    var prevValue:Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.translatesAutoresizingMaskIntoConstraints = true
        checkLabel.translatesAutoresizingMaskIntoConstraints = true
        slider.translatesAutoresizingMaskIntoConstraints = true
        timeLabel.text = "Refresh every \(Int(slider.maximumValue)) seconds"
        checkLabel.layer.zPosition = 9
        checkLabel.center = CGPoint(x: checkLabel.center.x,  y: checkLabel.frame.height * -1)
        currentValue = Int(slider.maximumValue - slider.value) + 1
        counter = TimeInterval(currentValue)
        initTimer()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
    @IBAction func sliderChanged(_ sender: UISlider) {
        timer.invalidate()
        currentValue  = Int(slider.maximumValue - sender.value) + 1
        if(currentValue > 0 ) {
            if currentValue > 1 {
                timeType   = "seconds"
            }
            else {
                timeType = "second"
            }
            timeLabel.text = "Refresh every \(currentValue) \(timeType)"
            counter = TimeInterval(currentValue)
            initTimer()
        }
    }

    @IBAction func keyPressed(_ sender: UIButton) {
        evaluateAnswer(Int(sender.tag))
        keysImage.image = UIImage(named: "\(sender.tag).png")
        imageTimer = Timer.scheduledTimer(timeInterval: 0.3, target:self, selector: #selector(ViewController.resetImage), userInfo: nil, repeats: false)
    }
    
    func resetImage() {
        keysImage.image = UIImage(named: "default.png")
    }
    
    func initTimer() {
        timer = Timer.scheduledTimer(timeInterval: counter, target:self, selector: #selector(ViewController.updateKey), userInfo: nil, repeats: true)
    }
    
    func updateKey() {
        currentIndex = Int(arc4random_uniform(UInt32(keysArray.count)))
        if currentIndex == prevValue {
			self.updateKey()
        }
		else {
			keys.text = keysArray[currentIndex]
			prevValue = currentIndex
		}
		
    }
    
    func evaluateAnswer(_ val:Int) {
  
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.checkLabel.center = CGPoint(x: self.checkLabel.center.x, y: 30)
            }, completion: { finished in
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, options: UIViewAnimationOptions.curveEaseOut, animations: {
                        self.checkLabel.center = CGPoint(x: self.checkLabel.center.x, y: self.checkLabel.frame.height * -1)
                    }, completion: nil)
        })
        if val == currentIndex {
            checkLabel.text = "CORRECT!!"
            checkLabel.backgroundColor = hexStringToUIColor("#68b021")
        }
        else {
            checkLabel.text = "INCORRECT!!"
            checkLabel.backgroundColor = hexStringToUIColor("#a51f1f")
        }
    }
    
    func hexStringToUIColor (_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = cString.substring(from: cString.characters.index(cString.startIndex, offsetBy: 1))
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}


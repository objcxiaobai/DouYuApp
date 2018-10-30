//
//  XBProgressHUD.swift
//  DouYus
//
//  Created by 冼 on 2018/10/30.
//  Copyright © 2018 Null. All rights reserved.
//

import UIKit

class XBProgressHUD: NSObject {
    
    static var timerTimes = 0
    static var timer: DispatchSource!
    static let rv = UIApplication.shared.keyWindow?.subviews.first as UIView?
    static var showViews = Array<UIView>()
    static var hubBackGroundColor: UIColor = UIColor.clear
    
    public class func showAnimationImages(supView : UIView ,bgFrame: CGRect, imgArr : [UIImage] = [UIImage](),timeMilliseconds: Int = 0,bgColor : UIColor? = UIColor.white, scale:Double = 1.0){
        
        
    }
    
    static func showProgress(supView : UIView,bgFrame: CGRect? = nil,imagArr: [UIImage] = [UIImage](),timeMilliseconds: Int = 0,bgCOlor:UIColor?=UIColor.white,scale : Double = 1.0){
        
        var supFrame = supView.frame
        if bgFrame != nil {
            supFrame = bgFrame!
        }
        
        let bgView = UIView()
        bgView.isHidden = false
        bgView.backgroundColor = bgCOlor
        
        
        let imgViewFrame = CGRect(x: Double(supFrame.size.width) * (1-scale) * 0.5, y: Double(supFrame.size.height)*(1-scale) * 0.5, width: Double(supFrame.size.width) * scale, height: Double(supFrame.size.height) * scale)
        
        
        if imagArr.count > 0 {
            
            if imagArr.count > timerTimes{
                
                let iv = UIImageView(frame: imgViewFrame)
                iv.image = imagArr.first!
                iv.contentMode = UIView.ContentMode.scaleAspectFit
                bgView.addSubview(iv)
                
                timer = (DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags(rawValue: UInt(0)), queue: DispatchQueue.main) as! DispatchSource)
                timer.schedule(deadline: DispatchTime.now(), repeating: DispatchTimeInterval.milliseconds(timeMilliseconds))
                
                timer.setEventHandler {
                    let name = imagArr[timerTimes % imagArr.count]
                    iv.image = name
                    timerTimes += 1
                    
                }
                timer.resume()
                
            }
            
        }
        
        bgView.frame = supFrame
        supView.addSubview(bgView)
        showViews.append(bgView)
        
        bgView.alpha = 0.0
        UIView.animate(withDuration: 0.2) {
            bgView.alpha = 1
        }
        
    }
    
    static func clear(){
        self.cancelPreviousPerformRequests(withTarget: self)
        if let _ = timer{
            timer.cancel()
            timer = nil
            timerTimes  = 0
        }
        showViews.removeAll()
    }
    
    public class func hideAllHUD(){
        self.closePUB()
    }
    
    static func closePUB(){
        self.cancelPreviousPerformRequests(withTarget: self)
        if let _ = timer {
            timer.cancel()
            timer = nil
            timerTimes = 0
        }
        
        for (_,view) in showViews.enumerated() {
            view.isHidden = true
        }
        
    }
    
}

extension UIViewController{
    class func xb_currentViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController {
        
        if let nav = base as? UINavigationController{
            return xb_currentViewController(base:nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return xb_currentViewController(base: tab.selectedViewController)
        }
        
        if let presented = base?.presentedViewController{
            return xb_currentViewController(base:presented)
        }
        return base!
        
        
    }
}

//
//  AddSMSegmentView.swift
//  JYCalendarNew
//
//  Created by 何川 on 16/1/26.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

import Foundation
import UIKit

@objc open class AddSMSegmentView: NSObject, SMSegmentViewDelegate {
    
    var segmentView: SMSegmentView!
    //var margin: CGFloat = 10.0
    
    open func createSlider(_ parentView:UIView, withReact react:CGRect) {
        
        //let segmentFrame = CGRect(x:self.margin*8, y:0.0, width: parentView.frame.size.width - self.margin*16, height: 28.0)
        
        let userSkin = UserDefaults.standard.object(forKey: "kUserSkin")as!String
        var nowColor = UIColor(red: 255.0/255.0, green: 59.0/255.0, blue: 48.0/255.0, alpha: 1.0)
       if userSkin == "蓝色"{
        
          nowColor =
            UIColor(red: 18 / 255.0, green: 183 / 255.0, blue: 245 / 255.0, alpha: 1);

        }else if userSkin == "绿色"{
         
            nowColor = UIColor(red: 9 / 255.0, green: 187 / 255.0, blue: 7 / 255.0, alpha: 1)
            
        }else if userSkin == "粉色"{
        
            nowColor = UIColor(red: 255 / 255.0, green: 96 / 255.0, blue: 143 / 255.0, alpha: 1)
            
        }else{
         
//            nowColor = UIColor(red: 255 / 255.0, green: 59 / 255.0, blue: 48 / 255.0, alpha: 1)
            nowColor = UIColor(red: 208 / 255.0, green: 63 / 255.0, blue: 63 / 255.0, alpha: 1)
        }
        
        self.segmentView = SMSegmentView(frame: react, separatorColour: UIColor(white: 0.95, alpha: 0.3), separatorWidth: 0.5, segmentProperties: [keySegmentTitleFont: UIFont.systemFont(ofSize: 13), keySegmentOnSelectionColour: nowColor, keySegmentOffSelectionColour: UIColor.white, keySegmentOffSelectionTextColour: nowColor, keyContentVerticalMargin: Float(0.0) as AnyObject])
        
        self.segmentView.delegate = self
        
        self.segmentView.backgroundColor = UIColor.clear
        self.segmentView.layer.cornerRadius = 8.0
        self.segmentView.layer.borderColor = nowColor.cgColor
        self.segmentView.layer.borderWidth = 1.5
        
        let view = self.segmentView
        
        //Add segments
        view?.addSegmentWithTitle("已发送"/*, onSelectionImage: UIImage(named: "clip_light"), offSelectionImage: UIImage(named: "clip")*/)
        view?.addSegmentWithTitle("已接收"/*, onSelectionImage: UIImage(named: "bulb_light"), offSelectionImage: UIImage(named: "bulb")*/)
        
        parentView.addSubview(view!)
        
        view?.selectSegmentAtIndex(0)
        
    }


    
    //SMSegment Delegate
    open func segmentView(_ segmentView: SMBasicSegmentView, didSelectSegmentAtIndex index: Int) {
        


        
    NotificationCenter.default.post(name: Notification.Name(rawValue: "SMSegmentNotify"), object:self, userInfo:["index":index])
    }
    
}

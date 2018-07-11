//
//  LocalViewController.h
//  JYCalendarNew
//
//  Created by 张静 on 16/3/11.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


#define IOS [[[UIDevice currentDevice]systemVersion]floatValue]



@interface LocationViewController : UIViewController<CLLocationManagerDelegate>

@property (nonatomic ,copy)void (^actionForGetLocationString)(NSString *remindLoaction);


@end

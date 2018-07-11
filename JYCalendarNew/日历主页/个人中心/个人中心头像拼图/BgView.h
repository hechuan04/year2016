//
//  BgView.h
//  Header
//
//  Created by 吴冬 on 16/3/16.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BgView : UIView

@property (nonatomic ,strong)NSArray *arrForImage;

@property (nonatomic ,assign)int number; //第几个头像
@property (nonatomic ,assign)int type;   //有多少张头像

@property (nonatomic ,strong)NSArray *imageArr;

@end

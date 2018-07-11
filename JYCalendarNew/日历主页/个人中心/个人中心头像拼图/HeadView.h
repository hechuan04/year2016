//
//  HeadView.h
//  Header
//
//  Created by 吴冬 on 16/3/16.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadView : UIView

@property (nonatomic ,assign)int two;
@property (nonatomic ,assign)int three;
@property (nonatomic ,assign)int four;
@property (nonatomic ,assign)int type;

@property (nonatomic ,strong)NSArray *imageArr;

- (instancetype)initWithFrame:(CGRect)frame andType:(int )type andArr:(NSArray *)imageArr;

@end

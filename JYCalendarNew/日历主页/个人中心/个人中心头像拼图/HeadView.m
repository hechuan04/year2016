//
//  HeadView.m
//  Header
//
//  Created by 吴冬 on 16/3/16.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "HeadView.h"
#import "BgView.h"

@implementation HeadView

- (instancetype)initWithFrame:(CGRect)frame andType:(int )type andArr:(NSArray *)imageArr
{
 
    if (self = [super initWithFrame:frame]) {
        
        _two = 2;
        _three = 3;
      
        if (type == _two) {
            
            [self _twoImage:frame andArr:imageArr];

        }else if(type == _three){
        
            [self _threeImage:frame andArr:imageArr];

        }else if(type == 1){
         
            UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
            headImage.image = imageArr[0];
            [self addSubview:headImage];
            headImage.layer.cornerRadius = headImage.width / 2.0;
            headImage.layer.masksToBounds = YES;
            
        }else{
           
            [self _fourImage:frame andArr:imageArr];

        }
   
    
    }
    
   
    return self;
}



- (void)_fourImage:(CGRect )rect andArr:(NSArray *)imageArr
{
 
    CGFloat _width = rect.size.width;
    
    BgView *bg1 = [[BgView alloc] initWithFrame:CGRectMake(2,2,_width - 4, _width - 4)];
    bg1.number = 1;
    bg1.type = 4 ;
    bg1.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    bg1.layer.masksToBounds = YES;
    bg1.layer.cornerRadius = (_width - 8) / 2.0;
    bg1.arrForImage = imageArr;
    [self addSubview:bg1];
    
    BgView *bg2 = [[BgView alloc] initWithFrame:CGRectMake(2, 2, _width - 4, _width - 4)];
    bg2.number = 2;
    bg2.type = 4;
    bg2.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    bg2.layer.masksToBounds = YES;
    bg2.layer.cornerRadius = (_width - 8) / 2.0;
    bg2.arrForImage = imageArr;
    [self addSubview:bg2];
    
    BgView *bg3 = [[BgView alloc] initWithFrame:CGRectMake(2, 2, _width - 4, _width - 4)];
    bg3.number = 3;
    bg3.type = 4;
    bg3.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    bg3.layer.masksToBounds = YES;
    bg3.layer.cornerRadius = (_width - 8) / 2.0;
    bg3.arrForImage = imageArr;
    [self addSubview:bg3];
    
    BgView *bg4 = [[BgView alloc] initWithFrame:CGRectMake(2, 2, _width - 4, _width - 4)];
    bg4.number = 4;
    bg4.type = 4;
    bg4.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    bg4.layer.masksToBounds = YES;
    bg4.layer.cornerRadius = (_width - 8) / 2.0;
    bg4.arrForImage = imageArr;
    [self addSubview:bg4];

    

}



- (void)_twoImage:(CGRect )rect andArr:(NSArray *)imageArr
{
    CGFloat _width = rect.size.width;
    
    BgView *bg1 = [[BgView alloc] initWithFrame:CGRectMake(2,2 ,_width - 4, _width - 4)];
    bg1.number = 1;
    bg1.type = 2;
    bg1.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    bg1.layer.masksToBounds = YES;
    bg1.layer.cornerRadius = (_width - 8) / 2.0;
    bg1.arrForImage = imageArr;
    [self addSubview:bg1];
    
    BgView *bg2 = [[BgView alloc] initWithFrame:CGRectMake(2, 2, _width - 4, _width - 4)];
    bg2.number = 2;
    bg2.type = 2;
    bg2.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    bg2.layer.masksToBounds = YES;
    bg2.layer.cornerRadius = (_width - 8) / 2.0;
    bg2.arrForImage = imageArr;
    [self addSubview:bg2];

    
}

- (void)_threeImage:(CGRect )rect andArr:(NSArray *)imageArr
{
    CGFloat _width = rect.size.width;
 
    BgView *bg1 = [[BgView alloc] initWithFrame:CGRectMake(2,2 ,_width - 4, _width - 4)];
    bg1.number = 1;
    bg1.type = 3;
    bg1.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    bg1.layer.masksToBounds = YES;
    bg1.layer.cornerRadius = (_width - 8) / 2.0;
    bg1.arrForImage = imageArr;
    [self addSubview:bg1];
    
    BgView *bg2 = [[BgView alloc] initWithFrame:CGRectMake(2, 2, _width - 4, _width - 4)];
    bg2.number = 2;
    bg2.type = 3;
    bg2.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    bg2.layer.masksToBounds = YES;
    bg2.layer.cornerRadius = (_width - 8) / 2.0;
    bg2.arrForImage = imageArr;
    [self addSubview:bg2];
    
    BgView *bg3 = [[BgView alloc] initWithFrame:CGRectMake(2, 2, _width - 4, _width - 4)];
    bg3.number = 3;
    bg3.type = 3;
    bg3.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    bg3.layer.masksToBounds = YES;
    bg3.layer.cornerRadius = (_width - 8) / 2.0;
    bg3.arrForImage = imageArr;
    [self addSubview:bg3];

}

@end

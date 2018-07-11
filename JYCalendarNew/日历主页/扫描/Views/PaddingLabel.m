//
//  PaddingLabel.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/6/15.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "PaddingLabel.h"

@implementation PaddingLabel
-(instancetype)init
{
    self = [super init];
    if(self){
        self.edgeInsets = UIEdgeInsetsMake(6, 8, 6, 8);
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.edgeInsets = UIEdgeInsetsMake(6, 8, 6, 8);
    }
    return self;
}
    
- (void)drawTextInRect:(CGRect)rect {
    
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}

-(CGSize)intrinsicContentSize

{
    CGSize size = [super intrinsicContentSize];
    size.width += self.edgeInsets.left + self.edgeInsets.right;
    size.height += self.edgeInsets.top + self.edgeInsets.bottom;
    
    return size;
}
- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize oldSize = [super sizeThatFits:size];
    CGFloat newWidth= oldSize.width+self.edgeInsets.left+self.edgeInsets.right;
    CGFloat newHeight = oldSize.height+self.edgeInsets.top+self.edgeInsets.bottom;
    return CGSizeMake(newWidth, newHeight);
}
@end

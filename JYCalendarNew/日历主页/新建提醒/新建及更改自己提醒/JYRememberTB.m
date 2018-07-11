//
//  JYRememberTB.m
//  JYCalendarNew
//
//  Created by 吴冬 on 17/1/11.
//  Copyright © 2017年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYRememberTB.h"
#import "JYRememberCell.h"
static NSString *cellIndentifier = @"cellIndentifier";
@implementation JYRememberTB

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
        
        self.delegate = self;
        self.dataSource = self;
        
        [self registerClass:[JYRememberCell class] forCellReuseIdentifier:cellIndentifier];
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JYRememberCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell = [[JYRememberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        
    }
    
    //cell.backgroundColor = RGB_COLOR(244, 244, 244);
    cell.contentView.backgroundColor = RGB_COLOR(244, 244, 244);
    
    if (_modelArr) {
        RemindModel *model = _modelArr[indexPath.row];
        cell.titleLable.text = model.content;
        cell.timeLabel.text = [NSString stringWithFormat:@"%d年%d月%d日 %d:%d",model.year,model.month,model.day,model.hour,model.minute];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_modelArr) {
        self.hidden = NO;
        return _modelArr.count;
    }else{
        self.hidden = YES;
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (_modelArr) {
        RemindModel *model = _modelArr[indexPath.row];
        
        if ([self.modelDelegate respondsToSelector:@selector(passModel:)]) {
            [self.modelDelegate passModel:model];
        }
    }
  
}

@end

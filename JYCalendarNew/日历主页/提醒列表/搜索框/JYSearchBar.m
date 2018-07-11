//
//  JYSearchBar.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/2/26.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYSearchBar.h"
#define yForTextFiled 60 / 1334.0 * kScreenHeight
#define xForTextFiled 224 / 750.0 * kScreenWidth

#define heightForTextFiled 70 / 1334.0 * kScreenHeight
@implementation JYSearchBar
{
 
    CGFloat _yForSearchBar;
    CGFloat _xForEditBtn;
    CGFloat _xForCalendarBtn;
}


- (instancetype)initWithSuperView:(UINavigationController *)nav
                      andEditBtnX:(CGFloat )editX
                        calendarX:(CGFloat )calendarX
{
 
    if (self = [super init]) {
        
        self.delegate = self;
        self.backgroundImage = [UIImage imageNamed:@"白背景.png"];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5.f;
        self.layer.borderColor = lineColor.CGColor;
        self.layer.borderWidth = 0.5f;
        self.backgroundColor = [UIColor whiteColor];
        
        CGFloat yForSearchBar = 0;
        
        if (IS_IPHONE_4_SCREEN) {
 
        }else if(IS_IPHONE_5_SCREEN){
        
            yForSearchBar = 7.0;
            
        }else if(IS_IPHONE_6_SCREEN){
         
            yForSearchBar = 7.0;
            
        }else if(IS_IPHONE_6P_SCREEN){
        
            yForSearchBar = 6.0;
        
        }
        
        
        _xForEditBtn = editX ;
        _xForCalendarBtn = kScreenWidth - calendarX + 20;
        _yForSearchBar = [[UIApplication sharedApplication] statusBarFrame].size.height + yForSearchBar;
        self.frame = CGRectMake(20, _yForSearchBar, 271 - 40, 30);
        self.placeholder = @"搜索";
        [nav.view addSubview:self];
        
    

    }
    
    return self;
}





- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
 
    _endSearch(self.text);
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
 
    //传递输入框内容
    _searchBarText(searchText);
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
 
    //开始编辑
    _beginSearch();
    
    [UIView animateWithDuration:0.2 animations:^{
        
        //self.frame = CGRectMake(10, _yForSearchBar, kScreenWidth - 20 - _xForEditBtn, 30);
    }];
    
}

- (void)changeSearchBar:(CGRect)rect
{
      [UIView animateWithDuration:0.1 animations:^{
          self.frame = rect;
      }];
}


@end

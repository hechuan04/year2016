//
//  JYRemindView.m
//  JYCalendar
//
//  Created by 吴冬 on 15/10/13.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "JYRemindView.h"
#import "JYRemindView+ArrAction.h"
#import "SliderBtn.h"

#define kWidhtRemind  80 / 750.0 * kScreenWidth

//编辑按钮
#define xForEdit 37 / 1334.0 * kScreenHeight
#define yForEdit 25 / 1334.0 * kScreenHeight
#define heightForEdit 60 / 1334.0 * kScreenHeight
#define widthForEdit 135 / 750.0 * kScreenWidth

//table与按钮间隔
#define pageForTBAndBtn 52 / 1334.0 * kScreenHeight

//按钮宽度
#define widthForSliderBtn 255 / 750.0 * kScreenWidth
#define heigthForSliderBtn 56 / 1334.0 * kScreenHeight
#define yForSliderBtn 15 / 1334.0 * kScreenHeightlabel

//“我”和“他”标签
#define xHeOrMe()(IS_IPHONE_4_SCREEN?14:(IS_IPHONE_5_SCREEN?12:(IS_IPHONE_6_SCREEN?10:10)))

@implementation JYRemindView {
   
    NSInteger _senderTag;
    NSArray   *_arrForAll;
    NSArray   *_arrForAlready;
    NSArray   *_arrForAwait;
    
    //SliderBtn *_sliderBtn;

}

- (instancetype)initWithFrame:(CGRect)frame {
   
    if (self = [super initWithFrame:frame]) {
       
        //换肤
        JYSkinManager *manager = [JYSkinManager shareSkinManager];
        
        
//        _dragImageView = [[UIImageView alloc]init];
//        _dragImageView.image = [UIImage imageNamed:@"下拉_红"];
//        [self addSubview:_dragImageView];
//        
//        [self.dragImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.centerX.equalTo(self);
//        }];
        
        _btnForEdit = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnForEdit.frame = CGRectMake(15, 20, 45, 20);
        [_btnForEdit addTarget:self action:@selector(actionForEdit:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnForEdit];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 45, 20)];
        _label.text = @"编辑";
        _label.textColor = manager.colorForDateBg;
        _label.font = [UIFont systemFontOfSize:15];
        //label.userInteractionEnabled = YES;
        _label.textAlignment = NSTextAlignmentCenter;
        [_btnForEdit addSubview:_label];
        
        manager.remindEditLabel = _label;
        
        CGFloat widthForAddBtn = 0;
        CGFloat heightForAddBtn = 0;
 
        
        if (IS_IPHONE_4_SCREEN) {
   
            
            widthForAddBtn = 40;
            heightForAddBtn = 40;
  
            
        }else if(IS_IPHONE_5_SCREEN){
            
     
            
            widthForAddBtn = 44;
            heightForAddBtn = 44;

            
        }else if(IS_IPHONE_6_SCREEN){
            
 
            widthForAddBtn = 47;
            heightForAddBtn = 47;
 
            
        }else if(IS_IPHONE_6P_SCREEN){
            

            widthForAddBtn = 40 ;
            heightForAddBtn = 40 ;
            
        }

        
        _btnForAdd = [UIButton buttonWithType:UIButtonTypeCustom];
       // _btnForAdd.frame = CGRectMake(kScreenWidth - 15 - 40, xHeOrMe(), 40, 40);
        [_btnForAdd addTarget:self action:@selector(actionForAdd:) forControlEvents:UIControlEventTouchUpInside];
        [_btnForAdd setImage:manager.remindAddBtnImage forState:UIControlStateNormal];
        [self addSubview:_btnForAdd];
        
        [_btnForAdd mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.mas_right).offset(-18.f);
            make.top.equalTo(self.mas_top).offset(20.f);
            make.width.mas_equalTo(23.5f);
            make.height.mas_equalTo(20.5f);
            
        }];
        
        
        
        NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(AddSMSegmentViewDidSet:) name:@"SMSegmentNotify" object:nil];
        
        //“我”和“他”标签
        _sobj = [[AddSMSegmentView alloc] init];
        [_sobj createSlider:self withReact:CGRectMake(kScreenWidth / 2.0 - widthForSliderBtn / 2.0, xHeOrMe()+5, widthForSliderBtn, heigthForSliderBtn)];
        
     
        
        //有几条没看的提醒
        _labelForLookNumber = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2.0 - widthForSliderBtn / 2.0 + widthForSliderBtn - 10, 10, 20, 20)];
        _labelForLookNumber.text = @"9";
        _labelForLookNumber.font = [UIFont systemFontOfSize:13];
        _labelForLookNumber.layer.masksToBounds = YES;
        _labelForLookNumber.layer.cornerRadius = _labelForLookNumber.width / 2.0;
        _labelForLookNumber.layer.borderColor = [UIColor whiteColor].CGColor;
        _labelForLookNumber.layer.borderWidth = 0.5;
        _labelForLookNumber.textAlignment = NSTextAlignmentCenter;
        _labelForLookNumber.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:59 / 255.0 blue:48 / 255.0 alpha:1];
        _labelForLookNumber.textColor = [UIColor whiteColor];
        _labelForLookNumber.hidden = YES;
        [self addSubview:_labelForLookNumber];
        
        //他
//        _alreayTableView = [[JYAlreadyTableView alloc] initWithFrame:CGRectMake(0,  heigthForSliderBtn + pageForTBAndBtn, kScreenWidth, kScreenHeight - 66 - kHeightForWeek - kHeightForCalendar - heigthForSliderBtn - pageForTBAndBtn - 52) style:UITableViewStylePlain andAlreadyArr:nil];
         _alreayTableView = [[JYAlreadyTableView alloc] initWithFrame:CGRectMake(0,  heigthForSliderBtn + pageForTBAndBtn+5, kScreenWidth, kScreenHeight - 66 - heigthForSliderBtn - pageForTBAndBtn -kHeightForWeather - 13 - 58) style:UITableViewStylePlain andAlreadyArr:nil];
        _alreayTableView.rowHeight = 44.0;
        _alreayTableView.hidden = YES;
        
        UIView *viewForBg1 = [UIView new];
        viewForBg1.backgroundColor = [UIColor clearColor];
        [_alreayTableView setTableFooterView:viewForBg1];
        [self addSubview:_alreayTableView];
        
        //传递几个没看的提醒
        __block JYRemindView *jyremindView = self;
        [_alreayTableView setActionForChangeLookLabel:^(int numberForPeople) {
            
            if (numberForPeople != 0) {
                
                jyremindView.labelForLookNumber.text = [NSString stringWithFormat:@"%d",numberForPeople];
                jyremindView.labelForLookNumber.hidden = NO;
                
            }else{
                
                jyremindView.labelForLookNumber.hidden = YES;
                
            }
            
        }];
        
        //我
        _awaitTableView = [[JYAwaitTableView alloc] initWithFrame:CGRectMake(0, heigthForSliderBtn + pageForTBAndBtn+5, kScreenWidth,kScreenHeight - 66 - heigthForSliderBtn - pageForTBAndBtn -kHeightForWeather - 13 - 58) style:UITableViewStylePlain andWaitArr:nil];
        _awaitTableView.hidden = NO;
        _awaitTableView.rowHeight = 44.0;
        
        UIView *viewForBg2 = [UIView new];
        viewForBg2.backgroundColor = [UIColor clearColor];
        [_awaitTableView setTableFooterView:viewForBg2];
        [self addSubview:_awaitTableView];
        
        

    }

    return self;
    
}

- (void)AddSMSegmentViewDidSet:(id)sender {
    
    NSDictionary *dict = [sender userInfo];
    if([[dict objectForKey:@"index"] integerValue] == 0) {
        [self actionForAwait];
    }else {
        [self actionForAlready];
    }

}

//选择“我列表”
- (void)actionForAwait {
    
    _awaitTableView.hidden = NO;
    _alreayTableView.hidden = YES;
    
   
}

//选择“他列表”
- (void)actionForAlready {

    _alreayTableView.hidden = NO;
    _awaitTableView.hidden = YES;
    
   
}

//编辑按钮
- (void)actionForEdit:(UIButton *)sender {

    [self.alreayTableView setEditing:NO];
    [self.awaitTableView setEditing:NO];
    
    _isEdit = !_isEdit;
    _label.textColor = [JYSkinManager shareSkinManager].colorForDateBg;
    if (_isEdit) {
        
        _label.text = @"完成";
        
    }else {
    
        _label.text = @"编辑";
        
    }
    
    if (sender) {
        
        _editAction(_isEdit,YES);

    }else{
     
        _editAction(_isEdit,NO);
    }
    
}

//增加新提醒按钮
- (void)actionForAdd:(UIButton *)sender {
    _addAction();
   
}

@end

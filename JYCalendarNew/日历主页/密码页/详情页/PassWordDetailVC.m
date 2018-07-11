//
//  PassWordDetailVC.m
//  PassWord
//
//  Created by 吴冬 on 16/5/16.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "PassWordDetailVC.h"
#import "PassWordDetail.h"
#import "DetailCell.h"
#import <objc/runtime.h>

#define kDeleteBtnHeight 44

static NSString *indetifierCell = @"indetifierCell";
static void *deleteAlertView = "deleteAlertView";
static void *confirmAlertView = "confirmAlertView";


@interface PassWordDetailVC ()
{
    UIButton *_addBtn;
    UITapGestureRecognizer *tap;
    
    UITableView *_tableView;
    UIScrollView *_bgScrollView;
    
    NSMutableArray *_mutable;
    NSMutableArray *_heightArr;
    NSMutableArray *_textViewHeight;
    
    
    NSMutableArray *_arrForDetailView;
    
    
    UITextView *_nowTextView;
    UITextField *_nowTextField;
    
    CGFloat _scrollHeigth;
    
    int _index;
    CGFloat oneLine;
    BOOL    _isChange;
    
}
@end

@implementation PassWordDetailVC

static int imageTag = 456;

- (void)editAction:(UIButton *)sender
{
    NSLog(@"%@",sender.titleLabel.text);
    
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        
        for (PassWordDetail *detailV in _arrForDetailView) {
            
            detailV.deleteBtn.hidden = NO;
            
        }
        tap.enabled = NO;
        
    }else{
     
        for (PassWordDetail *detailV in _arrForDetailView) {
            
            detailV.deleteBtn.hidden = YES;
            
        }
        tap.enabled = YES;
    }
    
    NSLog(@"编辑");
}

- (void)cancelBack:(UIAlertView *)alert
{
    void (^confirmBack)(NSInteger index) = ^(NSInteger index){
    
        if (index == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            
        }
    };
    
    objc_setAssociatedObject(alert, confirmAlertView, confirmBack, OBJC_ASSOCIATION_COPY);
    

}

- (void)actionForLeft:(UIButton *)sender
{
    
    PassWordTitleList *titleList = [PassWordTitleList sharePassWordTitleList];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        //没有mid证明没有存入服务器
        NSMutableArray *arr = [NSMutableArray array];
        for (PassWordModel *model in _arrForModel) {
            if (model.mid != 0) {
                [arr addObject:model];
            }
        }
        
     
        if (arr.count != _arrForModel.count) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您还有未保存的内容，确定返回？" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                [alert show];
                
                [self cancelBack:alert];
            });
        }else{
         
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
                
            });
        }
        
        _titleModel.number = [NSString stringWithFormat:@"%ld",arr.count];
        
        [titleList upWithModel:_titleModel];
        _reloadDataBlock(_arrIndex,_arrForModel);

    });

    
    
}

- (void)actionForSetLeftBtn
{
    
    UIButton *btnForLeft = [Tool actionForReturnLeftBtnWithTarget:self];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btnForLeft];
    
    self.navigationItem.leftBarButtonItem = item;
    
}

- (void)dealloc
{
    [_addBtn removeFromSuperview];
    _addBtn = nil;
}

#pragma mark 左按钮方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _firstIn = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addBtn addTarget:self action:@selector(editDetail:) forControlEvents:UIControlEventTouchUpInside];
    _addBtn.frame = CGRectMake(0, 0, 30, 30);
    [_addBtn setImage:[JYSkinManager shareSkinManager].addPassDetail forState:UIControlStateNormal];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:_addBtn];
    
    self.navigationItem.rightBarButtonItem = right;
 
    _arrForDetailView = [NSMutableArray array];
    
    [self actionForSetLeftBtn];    
    [self _createScrollView];
}

#pragma mark 底部按钮
- (void)_createBottomView
{
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.view.mas_bottom);
        make.right.equalTo(self.view.mas_right);
        make.left.equalTo(self.view.mas_left);
        make.height.mas_equalTo(60.0);
        
    }];
    UIView *lineView = [UIView new];
    lineView.backgroundColor = lineColor;
    [bottomView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(bottomView.mas_top);
        make.right.equalTo(bottomView.mas_right);
        make.left.equalTo(bottomView.mas_left);
        make.height.mas_equalTo(0.5);
        
    }];
    
    UIButton *btn = [UIButton new];
    [btn addTarget:self action:@selector(editDetail:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[JYSkinManager shareSkinManager].addPassDetail forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.view.mas_bottom).offset(-15.0);
        make.right.equalTo(self.view.mas_right).offset(-15.0);
        make.height.mas_equalTo(30.0);
        make.width.mas_equalTo(30.0);
        
    }];

}

- (BOOL)isEmptyModel
{
 
    if (_arrForModel.count > 0) {
        
        PassWordModel *model = [_arrForModel firstObject];
        
        //未输入任何内容
        if ([model.title isEqualToString:@""]&&[model.passWord isEqualToString:@""]&&[model.userName isEqualToString:@""]&&[model.detail isEqualToString:@""]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您当前文本未编写，请编辑" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            
            [alert show];
            
            return YES;
        }
        
    }
    
    return NO;
}

//新建页面
- (void)editDetail:(UIButton *)sender
{
//    @property (nonatomic ,assign)int oid;
//    @property (nonatomic ,copy)NSString *type;
//    @property (nonatomic ,copy)NSString *title;
//    @property (nonatomic ,copy)NSString *userName;
//    @property (nonatomic ,copy)NSString *passWord;
//    @property (nonatomic ,copy)NSString *detail;
//    @property (nonatomic ,copy)NSString *createTime;
    
    if ([self isEmptyModel]) {
        
        return;
    }
    
    //添加新页面
    [self _addDetail];
    
 
}

#pragma mark scrollView实现
- (void)_createScrollView
{
 
    _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
    _bgScrollView.delegate = self;
    [self.view addSubview:_bgScrollView];
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_bgScrollView addGestureRecognizer:tap];
    
    if (_arrForModel.count == 0) {
        
        [self _createNoDetail:NO];
        
    }else{
     
        //计算高度
        [self _calculateHeight];
        //创建内容
        [self _createDetail];
        
        [self _createNoDetail:YES];

    }
 
}

#pragma mark - 添加
- (void)_addDetail
{
 

    UIImageView *imageV = [self.view viewWithTag:imageTag];
    imageV.hidden = YES;
    _firstIn = NO;
    PassWordModel *model = [[PassWordModel alloc] init];
    model.type_id = _titleModel.mid;
    model.title = @"";
    model.userName = @"";
    model.passWord = @"";
    model.detail = @"";
    NSDate *date = [NSDate date];
    NSDateFormatter *dateF = [[NSDateFormatter alloc] init];
    [dateF setDateFormat:@"YYYYMMddhhmm"];
    NSString *time = [dateF stringFromDate:date];
    model.createTime = time;
    model.mid = 0;
    
//创建新密码
    [_arrForModel insertObject:model atIndex:0];
    
    for (int i = 0; i < _arrForDetailView.count; i++) {
        
        PassWordDetail *detailV1 = _arrForDetailView[i];
        detailV1.origin = CGPointMake(0, 435 / 2 + detailV1.origin.y+ kDeleteBtnHeight);
        detailV1.index = i+1;
    }
    
    
    //计算高度
    [self _calculateHeight];
    
    PassWordDetail *detailV = [[PassWordDetail alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,435 / 2.0 + kDeleteBtnHeight) model:model index:(int)(0)];
    
    //回调
    [self detailBlock:detailV];
    
    [_bgScrollView addSubview:detailV];
    
    [_arrForDetailView insertObject:detailV atIndex:0];

    //跳转
    if (_arrForDetailView.count > 2) {
        
        [_bgScrollView setContentOffset:CGPointMake(0,0) animated:YES];
    }
    
    detailV.nextHeight = oneLine;
    
    

}

#pragma mark - detail回调
//detail回调
- (void)detailBlock:(PassWordDetail *)detailV
{
  
    [self editEnd:detailV];
    
    [self selectDetailV:detailV];
    
    [self deleteActionWithDetailView:detailV];
    
    [self saveAction:detailV];
    
    //更改frame
    [self changeFrameWithView:detailV];
    
    //没有更改内容的情况下刷新页面
    [self changeFrame:detailV];
}

#pragma mark - 刷新页面
- (void)changeFrame:(PassWordDetail *)detailV
{
    __weak PassWordDetailVC *vc = self;
    [detailV setReloadFrameBlock:^{
        
        [vc _calculateHeight];

    }];
}

#pragma mark - 选中detailV
- (void)selectDetailV:(PassWordDetail *)detailV
{
    //选中当前detailV
    __weak typeof(self) weekSelf = self;
    __block UIScrollView *weekScroll = _bgScrollView;
    __block UITextView   *weekTextView = _nowTextView;
    __block int weekIndex = _index;
    __block CGFloat weekOnLine = oneLine;
    [detailV setSelectTextViewBlock:^(UITextView *textView ,int index) {
                
        weekIndex = index;
        weekTextView = textView;
        
        PassWordDetail *nowDetailV = weekSelf.arrForDetailView[index];
        NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
        
        CGFloat gao = [textView.text boundingRectWithSize:CGSizeMake(textView.width, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size.height;
        
        if (gao != weekOnLine) {
            
            [weekScroll setContentOffset:CGPointMake(0, nowDetailV.origin.y  + gao) animated:YES];
        }else{
            
            [weekScroll setContentOffset:CGPointMake(0, nowDetailV.origin.y  ) animated:YES];
        }
        
    }];
   
    //textField回调
    __block UITextField *weekTextField = _nowTextField;
    [detailV setSelectTextFieldBlock:^(UITextField *textField ,int index) {
        
        
        weekTextField = textField;
        weekIndex = index;
        PassWordDetail *nowDetailV = weekSelf.arrForDetailView[index];
        
        [weekScroll setContentOffset:CGPointMake(0, nowDetailV.origin.y) animated:YES];
        
    }];
    


    
}

#pragma mark - 删除选中detailV
- (void)deleteActionWithDetailView:(PassWordDetail *)detailV
{
    __weak PassWordDetailVC *vc = self;
    [detailV setDeleteModel:^(PassWordModel *model, int index ,PassWordDetail *nowDetail) {

        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除不可恢复，确定删除？" message:@"" delegate:vc cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alert show];
  
        [vc _deleteActionWithModel:model index:index passWordDetail:nowDetail alert:alert];
   
    }];
    
}

- (void)_deleteActionWithModel:(PassWordModel *)model index:(int )index passWordDetail:(PassWordDetail *)nowDetail alert:(UIAlertView *)alert
{

    void (^deleteBlock)(NSInteger btnIndex) = ^(NSInteger btnIndex){
        
        if (btnIndex == 0) {
            
            [RequestManager deleteNewPassWordDetailWithModel:model complish:^(BOOL success, int mid) {
                
                if (success) {
                    
                    //改变位置
                    //最后一个不需要改
                    if (index != _arrForModel.count - 1) {
                        nowDetail.changeFrameBlock(index,0,0);
                    }
                    
                    //删除数组中的东西
                    [_arrForModel removeObjectAtIndex:index];
                    [_heightArr removeObjectAtIndex:index];
                    [_arrForDetailView removeObjectAtIndex:index];
                    
                    [nowDetail removeFromSuperview];
                    
                    [self _calculateHeight];
                    
                    PassWordList *passList = [PassWordList sharePassList];
                    [passList deleteDataWithModel:model completionBlock:^(BOOL isDelete) {
                        
                        if (isDelete) {
                            
                            NSLog(@"删除成功");
                            
                        }else{
                            
                            NSLog(@"删除失败");
                        }
                        
                    }];
                    
                    if (_arrForDetailView.count == 0) {
                        UIImageView *imageV = [self.view viewWithTag:imageTag];
                        imageV.hidden = NO;
                    }
                }
                
            }];
            
        }
        
    };
    
    objc_setAssociatedObject(alert, deleteAlertView, deleteBlock, OBJC_ASSOCIATION_COPY);
}

#pragma mark - 保存deltailV
- (void)saveAction:(PassWordDetail *)detailV
{
    __weak PassWordDetailVC *vc = self;
    
    [detailV setSaveModel:^(PassWordModel *select_model, int select_index, PassWordDetail *select_detail) {
       
       
        if (select_model.mid == 0) {
            
            //创建
            [vc postDetail:select_model detail:select_detail];
            
        }else{
        
            //修改
            [vc postEditDetail:select_model detail:select_detail];
        }
 
    }];
}

#pragma mark - 修改保存到服务器
- (void)postEditDetail:(PassWordModel *)model detail:(PassWordDetail *)detail

{

    [RequestManager editNewPassWordDetailWithModel:model complish:^(BOOL success, int mid) {
        
        if (success) {
            
            [self successOrNotAlertView:@"更新成功!"];
                      //更新数据库
            PassWordList *list = [PassWordList sharePassList];
            [list upDataWithModel:model completionBlock:^(BOOL isUp) {
                
                if (isUp) {
                    
                    NSLog(@"更新成功！");
                    detail.confirmBtn.selected = YES;
                }else{
                    
                    NSLog(@"更新失败！");
                }
                
            }];
        }else{
            [self successOrNotAlertView:@"更新失败!"];
        }
    }];
}

- (void)successOrNotAlertView:(NSString *)str
{
  
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:str message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}

#pragma mark - 新建保存到服务器
- (void)postDetail:(PassWordModel *)model detail:(PassWordDetail *)detail
{
 
    [RequestManager addNewPassWordDetailWithModel:model typeId:_titleModel.mid complish:^(BOOL success, int mid) {
        
        PassWordList *list = [PassWordList sharePassList];

        if (success) {
            
            [self successOrNotAlertView:@"保存成功!"];
            model.mid = mid;
            [list insertDataWithModel:model completionBlock:^(BOOL insert) {
                
                if (insert) {
                    
                    NSLog(@"插入成功");
                    detail.confirmBtn.selected = YES;
                    
                }else{
                    
                    NSLog(@"插入失败");
                }
                
            }];
            
        }else{
            
            [self successOrNotAlertView:@"保存失败!"];
            NSLog(@"新建失败");
        }
        
    }];
}

//alertView代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    void (^block)(NSInteger btnIndex) = objc_getAssociatedObject(alertView, deleteAlertView);
    if (block) {
        block(buttonIndex);
    }
    
    void (^backBlock)(NSInteger index) = objc_getAssociatedObject(alertView, confirmAlertView);
    if (backBlock) {
        backBlock(buttonIndex);
    }
    
}

#pragma mark - 编辑detailV完成回调
- (void)editEnd:(PassWordDetail *)detailV
{
    //编辑完成
    __weak PassWordDetailVC *vc = self;
    [detailV setEndEditBlock:^(PassWordModel *model, int index) {
        
        if (index == vc.arrForModel.count) {
            return ;
        }

        //[_arrForModel replaceObjectAtIndex:index withObject:model];
        //根据内容从新计算高度
        [vc _calculateHeight];

    }];
    
}

#pragma mark - 动态更改frame
- (void)changeFrameWithView:(PassWordDetail *)detailV
{
    
    __weak typeof(self) weekSelf = self;
    __block BOOL weekIsChange = _isChange;
    [detailV setChangeFrameBlock:^(int index, CGFloat height ,CGFloat textHeight) {
        
      
        CGFloat y = 0;
        for (int i = 0; i < weekSelf.arrForDetailView.count; i++) {
            
            
            if (i >= index) {
                
                if (index == i) {
                    
                    PassWordDetail *detailv = weekSelf.arrForDetailView[i];
    
                    detailv.frame = CGRectMake(0, detailv.origin.y, kScreenWidth, height);
                    
                    detailv.detail.scrollsToTop = YES;
                    
                    //替换
                    [weekSelf.heightArr replaceObjectAtIndex:i withObject:@(height)];
                    [weekSelf.textViewHeight replaceObjectAtIndex:i withObject:@(textHeight)];
                    
                }else{
                    
                    
                    PassWordDetail *detailv = weekSelf.arrForDetailView[i];
                    //所有的index都要转换
                    if (height == 0) {
                        
                        detailv.index = i - 1;
                    }
                    
                    detailv.origin = CGPointMake(0, y);
                }
                
            }
            
            y += [weekSelf.heightArr[i] floatValue];
    
        }
        
        PassWordDetail *detailv = weekSelf.arrForDetailView[index];
        detailv.selectTextViewBlock(detailv.detail,index);
        weekIsChange = YES;
        
    }];
    
    
}


//初始化detailView
- (void)_createDetail
{
    CGFloat y = 0;
    for (int i = 0; i < _heightArr.count; i++) {
        
        
        PassWordDetail *detailV = [[PassWordDetail alloc] initWithFrame:CGRectMake(0, y, kScreenWidth,[_heightArr[i] floatValue]) model:_arrForModel[i] index:i];
        //回调
        [self detailBlock:detailV];
   
        [_bgScrollView addSubview:detailV];
        
        //[detailV setNeedsLayout];
        
        [_arrForDetailView addObject:detailV];
        
        y += [_heightArr[i] floatValue];
        
        detailV.confirmBtn.selected = YES;

    }
    
    
}


//计算textView高度
- (void)_calculateHeight
{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15.5]};
    oneLine = [@"一行" boundingRectWithSize:CGSizeMake(_widthForText, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size.height;
    _scrollHeigth = 0;
    _heightArr = [NSMutableArray array];
    _textViewHeight = [NSMutableArray array];
    for (PassWordModel *model in _arrForModel) {
        
        CGFloat height = [model.detail boundingRectWithSize:CGSizeMake(_widthForText, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size.height;
        //每一行文字高
        [_textViewHeight addObject:@(height)];
        
        [_heightArr addObject:@(height - oneLine + 435 / 2.0 + kDeleteBtnHeight)];
        
        _scrollHeigth += (height - oneLine + 435.0 / 2.0 + kDeleteBtnHeight);
    }

    [_bgScrollView setContentSize:CGSizeMake(0, _scrollHeigth)];

    if (_index == _arrForModel.count - 1) {
    
     
        if (_arrForDetailView.count > 0) {
            //不是第一响应者，说明编辑完成，如果没有编辑完成，会出现问题
            if (_arrForModel.count >= 2 && (![_nowTextField isFirstResponder] && ![_nowTextView isFirstResponder])) {
              
                //PassWordDetail *detail = _arrForDetailView[_index-1];
                [_bgScrollView setContentOffset:CGPointMake(0,0) animated:YES];
                
            }else{
                //PassWordDetail *detail = _arrForDetailView[_index];
                [_bgScrollView setContentOffset:CGPointMake(0,0) animated:YES];
            }
            
        }
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    NSLog(@"点击空白区域了");
    [_nowTextField resignFirstResponder];
    [_nowTextView resignFirstResponder];
}

#pragma mark -scrollView滚动方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_nowTextField resignFirstResponder];
    [_nowTextView resignFirstResponder];
    
}

#pragma mark 无内容的情况下
- (void)_createNoDetail:(BOOL)isHidden
{
 
    UIImageView *imageV = [UIImageView new];
    imageV.image = [UIImage imageNamed:@"password默认.png"];
    imageV.tag = imageTag;
    [self.view addSubview:imageV];
    imageV.hidden = isHidden;
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view.mas_top).offset((240) / 1334.0 * kScreenHeight);
        make.bottom.equalTo(self.view.mas_bottom).offset((-654) / 1334.0 * kScreenHeight);
        make.left.equalTo(self.view.mas_left).offset(170 / 750.0 * kScreenWidth);
        make.right.equalTo(self.view.mas_right).offset(-170 / 750.0 * kScreenWidth);

        
    }];
    

}



#pragma mark tableView实现
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

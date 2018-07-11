//
//  TextViewController.m
//  ScanDemo
//
//  Created by Gaolichao on 16/6/3.
//  Copyright © 2016年 Test. All rights reserved.
//

#import "TextViewController.h"
#import "PhotoEditorViewController.h"
#import "CameraNavigationController.h"

#define kToolBarHeight 44.f

@interface TextViewController ()<UITextViewDelegate>

@property (nonatomic,strong) UITextView *textView;
@property (nonatomic,strong) UIView *toolBarView;
@property (nonatomic,strong) UIButton *editButton;
@property (nonatomic,assign) BOOL contentHasChanged;
@end

@implementation TextViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.toolBarView];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.toolBarView.mas_bottom);
    }];
    
    [self.toolBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@(kToolBarHeight));
    }];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
  
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(self.file){
        self.textView.text = self.file.textContent;
    }
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    NSLog(@"CameraViewController========:dealloc");
    
}
#pragma mark - Public


#pragma mark - Private
#pragma mark - Keyboard NSNotification
- (void)closeButtonClicked:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)keyboardWillShow:(NSNotification *)notification
{
    if([self.textView isFirstResponder]){
        CGFloat height = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
        if(height>0){
            self.textView.contentInset = UIEdgeInsetsMake(0, 0, height+30.f, 0);
        }
    }
    
    
    
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    if([self.textView isFirstResponder]){
        
        self.textView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.editButton.selected = NO;
        self.textView.editable = NO;
    }
}

- (void)editButtonClicked:(UIButton *)sender
{
    sender.selected = !sender.selected;
    self.textView.editable = sender.selected;

    if(sender.selected){
        [self.textView becomeFirstResponder];
    }else{
        [self.textView resignFirstResponder];
    }
}
- (void)doneButtonClicked:(UIButton *)sender
{
    if(self.editButton.selected){
        [self editButtonClicked:self.editButton];
    }
    sender.enabled = NO;
    __weak typeof(self) ws = self;
    
    //图片编辑进入此页，调创建接口
    if([self.superViewController isKindOfClass:[PhotoEditorViewController class]]){
                ScanUploadModel *model = [ScanUploadModel new];
        model.name = self.file.name;
        model.fileType = 1;
        if(self.file.dirId>0){
            model.dirId = self.file.dirId;
        }else{
            NSInteger defaultId = [[NSUserDefaults standardUserDefaults] integerForKey:kDefaultDirId];
            if(defaultId>0){
                model.dirId = defaultId;
            }
        }
        model.isSingle = YES;
        model.textContent = self.textView.text;
        PhotoEditorViewController *editorVC = (PhotoEditorViewController *)self.superViewController;
        
        [RequestManager uploadNewFile:model complete:^(id data, NSError *error) {
            __strong typeof(self) ss = ws;
            [ss dismissViewControllerAnimated:YES completion:^{
                if(editorVC.isFromCameraVC){
                    [ss.superViewController.navigationController dismissViewControllerAnimated:NO completion:^{
                        NSInteger defaultId = [[NSUserDefaults standardUserDefaults] integerForKey:kDefaultDirId];
                        if(defaultId>0){
                            CameraNavigationController *navVC = (CameraNavigationController*)ss.superViewController.navigationController;
                            if(navVC.fromModelVC&&navVC.fromModelVC.navigationController){
                                [navVC.fromModelVC.navigationController popViewControllerAnimated:NO];
                            }
                        }
                    }];
                }else{
                    if(ss.superViewController.navigationController&&[ss.superViewController.navigationController.viewControllers count]>1){
                        
                        UIViewController *destVC = ss.superViewController.navigationController.viewControllers[1];
                        [ss.superViewController.navigationController popToViewController:destVC animated:NO];
                    }
                }
             }];
        }];
        
    }else{
        if(self.contentHasChanged){
            //文件页点击文字文件进入，调更新接口
            self.file.textContent = self.textView.text;
            [RequestManager updateFile:self.file complete:^(id data, NSError *error) {
                __strong typeof(self) ss = ws;
                [ss dismissViewControllerAnimated:YES completion:^{}];
            }];
        }else{
            [self dismissViewControllerAnimated:YES completion:^{}];
        }
        
    }

}

#pragma mark - Protocol
#pragma mark UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        textView.editable = NO;
        self.editButton.selected = NO;
        return NO;
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    self.contentHasChanged = YES;
}
#pragma mark - Custom Accessors
- (UITextView *)textView
{
    if(!_textView){
        _textView = [UITextView new];
        _textView.editable = NO;
        _textView.font = [UIFont systemFontOfSize:17.f];
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.delegate = self;
    }
    return _textView;
}
- (UIView *)toolBarView
{
    if(!_toolBarView){
        _toolBarView = [UIView new];
        _toolBarView.backgroundColor = [UIColor whiteColor];
        
//        UIView *lineView = [UIView new];
//        lineView.backgroundColor = [UIColor lightGrayColor];
//        [_toolBarView addSubview:lineView];
//        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@0.5f);
//            make.left.right.top.equalTo(_toolBarView);
//        }];
//        
//        lineView = [UIView new];
//        lineView.backgroundColor = [UIColor lightGrayColor];
//        [_toolBarView addSubview:lineView];
//        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.bottom.centerX.equalTo(_toolBarView);
//            make.width.equalTo(@0.5f);
//        }];
//        UIButton *editButton = [UIButton new];
//        editButton.tintColor = [JYSkinManager shareSkinManager].colorForDateBg;
//        [editButton setImage:[[UIImage imageNamed:@"扫描_编辑_红"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
//        [editButton setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateHighlighted];
//        [editButton setBackgroundImage:[[JYSkinManager shareSkinManager].btnBackGroundColor image] forState:UIControlStateSelected];
//        [editButton addTarget:self action:@selector(editButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//        editButton.adjustsImageWhenHighlighted = NO;
//        [_toolBarView addSubview:editButton];
//        self.editButton= editButton;
//        
//        [editButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.bottom.equalTo(_toolBarView);
//            make.top.equalTo(_toolBarView).offset(0.5);
//        }];
//        
//        UIButton *doneButton = [UIButton new];
//        [doneButton setTitle:@"完成" forState:UIControlStateNormal];
//        [doneButton setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateNormal];
//        [doneButton addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//        doneButton.adjustsImageWhenHighlighted = NO;
//        [_toolBarView addSubview:doneButton];
//        
//        [doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(editButton.mas_right);
//            make.right.bottom.equalTo(_toolBarView);
//            make.top.equalTo(editButton);
//            make.width.equalTo(editButton);
//        }];
        
        UIButton *closeButton = [[UIButton alloc]init];
        [closeButton setImage:[[UIImage imageNamed:@"关闭_红"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        closeButton.tintColor = [JYSkinManager shareSkinManager].colorForDateBg;
        [_toolBarView addSubview:closeButton];
        [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_toolBarView).offset(15.f);
            make.centerY.equalTo(_toolBarView);
            make.width.height.equalTo(@20.f);
        }];
        
        UIButton *saveButton = [[UIButton alloc]init];
        [saveButton setTitle:@"保存" forState:UIControlStateNormal];
        saveButton.titleLabel.font = [UIFont systemFontOfSize:17.f];
        [saveButton setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateNormal];
        [saveButton addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_toolBarView addSubview:saveButton];
        [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_toolBarView).offset(-15.f);
            make.centerY.equalTo(_toolBarView);
            make.height.equalTo(@40.f);
            make.width.equalTo(@40.f);
        }];
        
        UIButton *editButton = [[UIButton alloc]init];
        [editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [editButton setTitle:@"完成" forState:UIControlStateSelected];
        editButton.titleLabel.font = [UIFont systemFontOfSize:17.f];
        [editButton setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateNormal];
        [editButton addTarget:self action:@selector(editButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_toolBarView addSubview:editButton];
        [editButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(saveButton.mas_left).offset(-10.f);
            make.centerY.equalTo(_toolBarView);
            make.height.equalTo(@40.f);
            make.width.equalTo(@40.f);
        }];
        self.editButton = editButton;
        
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [_toolBarView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0.5);
            make.left.right.bottom.equalTo(_toolBarView);
        }];
    }
    return _toolBarView;
}
@end

//
//  JYAboutSecret.m
//  JYCalendar
//
//  Created by 吴冬 on 15/10/27.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "JYAboutSecret.h"

@interface JYAboutSecret () {

    int _xForBtn;
    int _count;
    NSMutableArray *arrForPic;
    
}

@end

@implementation JYAboutSecret

- (void)actionForLeft:(UIButton *)sender {
   
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)changeSkin
{
        _JYTextView.layer.borderColor = [JYSkinManager shareSkinManager].colorForDateBg.CGColor;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    
    //换肤通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin) name:kNotificationForListSkin object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionForPop) name:kNotificationForBackSetView object:@""];
    
    arrForPic = [NSMutableArray array];
    
    UIView *viewForLine = [[UIView alloc] initWithFrame:CGRectMake(0, 1, kScreenWidth, 0.5)];
    viewForLine.backgroundColor = lineColor;
    [self.view addSubview:viewForLine];
    
    
    UIButton *btnView = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnView addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    btnView.frame = CGRectMake(0, 0, 50, 50);
    [btnView setTitle:@"发送" forState:UIControlStateNormal];
    
    [btnView setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateNormal];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:btnView];
    
    self.navigationItem.rightBarButtonItem = right;
    
    UIButton *btnForLeft = [Tool actionForReturnLeftBtnWithTarget:self];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btnForLeft];
    
    self.navigationItem.leftBarButtonItem = item;
    
    _JYTextView.delegate = self;
    _JYTextView.layer.masksToBounds = YES;
    _JYTextView.layer.borderWidth = 1;
    _JYTextView.layer.borderColor = [JYSkinManager shareSkinManager].colorForDateBg.CGColor;
    _JYTextView.layer.cornerRadius = 15;

    
    _selected2Btn.hidden = YES;
    _selected3Btn.hidden = YES;
    _secondImage.hidden = YES;
    _thirdImage.hidden = YES;
    
    
    
}

- (void)sendAction:(UIButton *)sender {

    if ([_JYTextView.text isEqualToString:@""]) {
        
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"您的意见不能为空！" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alterView show];
        
        return;
        
    }
    
    [RequestManager actionForSendFeedWithImageArr:arrForPic text:_JYTextView.text];

}

//通知调用
- (void)actionForPop {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)SelectedPicker:(UIButton *)sender {
    
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
        
    }
    
    pickerImage.delegate = self;
    pickerImage.allowsEditing = NO;
    [self presentModalViewController:pickerImage animated:YES];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    _count ++;
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [arrForPic addObject:image];
        
        if (_count == 1) {
            
            _firstImage.image = image;
            _secondImage.hidden = NO;
            _selected2Btn.hidden = NO;
            
        }else if(_count == 2){
        
            _secondImage.image = image;
            _thirdImage.hidden = NO;
            _selected3Btn.hidden = NO;
            
        }else{
        
            _thirdImage.image = image;
            
        }

    }];

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:^{
    
    }];
    
}

-(void)textViewDidChange:(UITextView *)textView {
    
    if (textView.text.length == 0) {
        
        _placeHolder.hidden = NO;
        
    }else {
    
        _placeHolder.hidden = YES;
        
    }
    
}

- (IBAction)backgroundTouchDown:(id)sender {

    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //Dispose of any resources that can be recreated.
}

@end
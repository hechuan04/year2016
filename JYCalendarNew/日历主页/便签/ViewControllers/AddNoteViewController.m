//
//  AddNoteViewController.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/4/26.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "AddNoteViewController.h"
#import "JYNote.h"
#import "NoteTableManager.h"
#import "JYBatchSelectionVC.h"
#import "CamerManager.h"
#import "SDPhotoBrowser.h"

//#define kContentLengthLimit 150

#define kImageContainerViewTopOffset 20.f
#define kBottomOffset 10.f //图片距底部距离
#define kTextViewHorMargin 10.f
#define kImageContainerViewHorMargin 10.f
#define kImageColumnCount 4   //图片列数
#define kImageVerMargin 20 / 750.0 * kScreenWidth    //图片上下间隔
#define kImageHorMargin 20 / 1334.0 * kScreenWidth   //图片水平间隔
#define kImageViewHeight (self.contentTextView.bounds.size.width-2*kImageContainerViewHorMargin-(kImageColumnCount-1)*kImageHorMargin)/kImageColumnCount         //图片宽、高
#define kImageRowHeight (kImageViewHeight+kImageVerMargin)//一行图片+间隔的高度

@interface AddNoteViewController ()<UITextFieldDelegate,UITextViewDelegate,NSLayoutManagerDelegate,SDPhotoBrowserDelegate>

@property (nonatomic,assign) CGFloat bottomContentInset;
@property (nonatomic,assign) UIEdgeInsets oldInset;
@property (nonatomic,strong) UIButton *rightButton;
@property (nonatomic,strong) UIButton *putKeyBoardBtn;
@end

@implementation AddNoteViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"记事";
//    self.view.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240 / 255.0 alpha:1];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    
    [self setupUI];
    
    
    [self setCancelKeyBoardBtn];
}

- (void)setCancelKeyBoardBtn
{
        //取消键盘弹出按钮
    _putKeyBoardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _putKeyBoardBtn.frame = CGRectMake( kScreenWidth - 42 - 35 / 2.0 ,kScreenHeight, 42, 42);
    [_putKeyBoardBtn setImage:[JYSkinManager shareSkinManager].putKeyBoardImage forState:UIControlStateNormal];
    [_putKeyBoardBtn addTarget:self action:@selector(cancelKeyBoardPut:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_putKeyBoardBtn];
}

- (void)cancelKeyBoardPut:(UIButton *)sender
{
//    [_titleField resignFirstResponder];
    [_contentTextView resignFirstResponder];
}




- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pop) name:kNotificationForPopNote object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification   object:self.titleField];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - Public


#pragma mark - Private
- (void)setupUI
{
    //导航
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[JYSkinManager shareSkinManager].backImage forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 0, 23.5, 20.5);
    [leftBtn addTarget:self action:@selector(actionForLeft:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
//    UIButton *btnView = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btnView addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    btnView.frame = CGRectMake(0, 0, 50, 50);
//    [btnView setTitle:@"完成" forState:UIControlStateNormal];
//    [btnView setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateNormal];
//    btnView.hidden = YES;
//    self.rightButton = btnView;
//    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:btnView];
//    self.navigationItem.rightBarButtonItem = right;

    //标题
 /*   
    UITextField *textField = [UITextField new];
    textField.placeholder = @"新建标题";
    textField.backgroundColor = [UIColor whiteColor];
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.returnKeyType = UIReturnKeyNext;
    textField.delegate = self;
    textField.font = [UIFont systemFontOfSize:17];
    UIView *viewForLeft = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 60)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = viewForLeft;
    [self.view addSubview:textField];
    self.titleField = textField;
//    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = UIColorFromRGB(0xbdbdbd);
    [self.view addSubview:lineView];
    self.lineView = lineView;
    
    */
    
    //内容
    UITextView *textView = [UITextView new];
    textView.backgroundColor = [UIColor whiteColor];
    textView.font = [UIFont systemFontOfSize:17];
    textView.textContainerInset = UIEdgeInsetsMake(5, 10, 5, 10);
    textView.returnKeyType = UIReturnKeyDefault;
    textView.delegate = self;
    textView.layoutManager.delegate = self;
    
    [self.view addSubview:textView];
    self.contentTextView = textView;
    [self.contentTextView addSubview:self.imageContainerView];
    
    UILabel *placeholderLabel = [[UILabel alloc]init];
    placeholderLabel.backgroundColor= [UIColor clearColor];
    placeholderLabel.textColor = [UIColor lightGrayColor];
    placeholderLabel.textColor = UIColorFromRGB(0xc2c2c2);
    placeholderLabel.font= textView.font;
    placeholderLabel.text = @"新建内容";
    [self.view addSubview:placeholderLabel];
    self.placeholderLabel= placeholderLabel;
    
    //toolbar
    UIToolbar *toolbar = [[UIToolbar alloc]init];
    toolbar.translucent = NO;
    [self.view addSubview:toolbar];
    self.toolbar.tintColor = [JYSkinManager shareSkinManager].colorForDateBg;
    self.toolbar = toolbar;
    UIBarButtonItem *sapceLeft = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *sapceRight = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    sapceRight.width = 20.f;
//    UIBarButtonItem *brushItem = [[UIBarButtonItem alloc]initWithCustomView:self.brushButton];
    UIBarButtonItem *cameraItem = [[UIBarButtonItem alloc]initWithCustomView:self.cameraButton];
    self.toolbar.items = @[sapceLeft,cameraItem,sapceRight];
    
    
    
//    [self.titleField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.view);
//        make.top.equalTo(self.view).offset(10.f);
//        make.height.equalTo(@(40.f));
//    }];
//    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view).offset(13.f);
//        make.right.equalTo(self.view.mas_right).offset(-13.f);
//        make.top.equalTo(self.titleField.mas_bottom);
//        make.height.equalTo(@(0.5f));
//    }];
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(5.f);
        make.bottom.equalTo(self.toolbar.mas_top);
    }];
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentTextView).offset(13.f);
        make.top.equalTo(self.contentTextView).offset(5.f);
        
    }];
    [self.toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(49.f));
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    
    
}
- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)actionForLeft:(UIButton *)sender
{
    [self.view endEditing:YES];
    if([self checkData]){
        [self saveData];
    }
    if([self.note.images count]==0){//没图片可以直接返回，有图片等待接受到通知时返回（有图片时存储时间长）
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (void)rightBtnClicked:(UIButton *)sender
{
    [self.view endEditing:YES];
}
- (void)saveData
{
    self.note.tId = @"";
//    self.note.title = self.titleField.text;
    if(self.contentTextView.text.trimWhitespace.length==0){
        self.note.title = @"新建内容";
    }else if(self.contentTextView.text.trimWhitespace.length<7){
        self.note.title = self.contentTextView.text.trimWhitespace;
    }else{
        self.note.title = [self.contentTextView.text.trimWhitespace subEmojiStringToIndex:7];
    }
    self.note.content = self.contentTextView.text;
    NSDate *date = [NSDate date];
    self.note.createTime = date;
    self.note.updateTime = date;
    self.note.imagePathRemote = @"";
    
    //生成图片相对路径名
    NSMutableArray *tmpArr = [NSMutableArray arrayWithCapacity:[self.note.images count]];
    for(int i=0;i<[self.note.images count];i++){
        JYNoteImage *jyImg = self.note.images[i];
        if(jyImg.imageType==JYImageTypeLocal){
            [tmpArr addObject:jyImg.path];
        }
    }
    self.note.imagePathLocal = [tmpArr componentsJoinedByString:@","];

    [[NoteTableManager sharedManager]insertNoteByLocal:self.note];
}
- (BOOL)checkData
{
    //无题，无内容，无图
//    if([self.titleField.text length]==0&&[self.contentTextView.text length]==0&&[self.note.images count]==0){
    if([self.contentTextView.text length]==0&&[self.note.images count]==0){
        return NO;
    }else{
        return YES;
    }
}
- (void)brushButtonClicked:(id)sender{
    
}
- (void)cameraButtonClicked:(id)sender{
    if (self.imageContainerView.subviews.count >= 8) {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"照片最多可添加8张" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        
    }else{
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
        [sheet showInView:self.view];
    }

}
/**
 *  刷新图片容器Frame
 */
- (void)refreshImageContainerViewFrame{
    
    if([self.note.images count]==0){
        self.imageContainerView.frame = CGRectZero;
        //        return;
    }
    
    CGSize newSize = [self.contentTextView sizeThatFits:CGSizeMake(self.contentTextView.bounds.size.width, MAXFLOAT)];
    
    CGFloat imageContainerViewHeight = ceilf(([self.note.images count]/(CGFloat)kImageColumnCount))*kImageRowHeight;
    CGFloat imageContainerViewWidth = self.contentTextView.bounds.size.width-kImageContainerViewHorMargin*2;
    
    self.imageContainerView.frame = CGRectMake(kImageContainerViewHorMargin,newSize.height+kImageContainerViewTopOffset,imageContainerViewWidth,imageContainerViewHeight);
    
//    CGFloat contentHeight = MAX(self.contentTextView.bounds.size.height,imageContainerViewHeight+newSize.height+kImageContainerViewTopOffset);
    
//    [self.contentTextView setContentSize:CGSizeMake(self.contentTextView.bounds.size.width,contentHeight)];
    
    NSLog(@"%@",[NSValue valueWithCGRect:self.contentTextView.frame]);
    NSLog(@"%@",[NSValue valueWithCGSize:self.contentTextView.contentSize]);
}
- (void)layoutImageViews{

    [self refreshImageContainerViewFrame];
    
    CGFloat imageContainerViewHeight = ceilf(([self.note.images count]/(CGFloat)kImageColumnCount))*kImageRowHeight;
    self.contentTextView.contentInset = UIEdgeInsetsMake(0, 0, imageContainerViewHeight+kImageContainerViewTopOffset, 0);

    [self.imageContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSInteger row,column;
    for(int i=0;i<[self.note.images count];i++){
        row = i/kImageColumnCount;
        column = i%kImageColumnCount;
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((kImageViewHeight+kImageHorMargin)*column,row*kImageRowHeight,kImageViewHeight,kImageViewHeight)];
        id data = self.note.images[i];
        if([data isKindOfClass:[UIImage class]]){
            imageView.image = data;
        }else if([data isKindOfClass:[JYNoteImage class]]){
            JYNoteImage *jyImg = (JYNoteImage *)data;
            if(jyImg.image){
                imageView.image = jyImg.image;
            }else if(jyImg.imageType==JYImageTypeLocal){
                NSArray *pathcaches = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString* cacheDirectory  = [pathcaches objectAtIndex:0];
                NSString *imgPath = [cacheDirectory stringByAppendingPathComponent:jyImg.path];
                imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imgPath]];
            }else if(jyImg.imageType==JYImageTypeRemote){
                [imageView sd_setImageWithURL:[NSURL URLWithString:jyImg.path] placeholderImage:[UIImage imageNamed:@"相册默认图片"]];
            }
        }
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.tag = i+kImageViewBaseTag;
        [self.imageContainerView addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
        //点击图片删除
        [imageView addGestureRecognizer:tap];
        
        UIButton *deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(kImageViewHeight-15,0,15, 15)];
        [deleteBtn setImage:[UIImage imageNamed:@"deletePhoto"] forState:(UIControlStateNormal)];
        [deleteBtn addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
        [imageView addSubview:deleteBtn];
    }

    NSLog(@"-----%@",self.imageStoragePath);
}
/**
 *  点击删除按钮删除图片
 */
- (void)deleteImage:(UIButton *)sender{
    [self.view endEditing:YES];
    _contentHasChanged = YES;
//    if([sender.superview isKindOfClass:[UIImageView class]]){
//        UIImage *image = ((UIImageView *)sender.superview).image;
//        if(image&&[self.note.images containsObject:image]){
//            [self.note.images removeObject:image];
//            [self layoutImageViews];
//        }
//    }
    NSInteger index = sender.superview.tag-kImageViewBaseTag;
    if(index<[self.note.images count]){
        [self.note.images removeObjectAtIndex:index];
        [self layoutImageViews];
    }
}
- (void)tapImageView:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
    
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *)tap;
    
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.hideSaveButton = YES;
    browser.sourceImagesContainerView = self.imageContainerView;
    browser.imageCount = [self.note.images count];
    browser.currentImageIndex = gesture.view.tag-kImageViewBaseTag;
    browser.delegate = self;
    [browser show];
}
#pragma mark - SDPhotoBrowserDelegate
// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    UIImageView *imgView = [self.imageContainerView viewWithTag:index+kImageViewBaseTag];
    if([imgView isKindOfClass:[UIImageView class]]){
        UIImage *image = imgView.image;
        return image;
    }else{
        return [UIImage imageNamed:@"相册默认图片"];
    }
}
// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    return nil;
}
#pragma mark - Keyboard NSNotification
- (void)keyboardWillShow:(NSNotification *)notification
{
    if([self.contentTextView isFirstResponder]){
        CGFloat height = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
        if(height>0){
            self.contentTextView.contentInset = UIEdgeInsetsMake(0, 0, height+30.f, 0);
        }
    }
    self.rightButton.hidden = NO;
    [self keyBoardAppear:notification];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    if([self.contentTextView isFirstResponder]){
        CGFloat imageContainerViewHeight = ceilf(([self.note.images count]/(CGFloat)kImageColumnCount))*kImageRowHeight;
        self.contentTextView.contentInset = UIEdgeInsetsMake(0, 0, imageContainerViewHeight+kImageContainerViewTopOffset, 0);
    }
    self.rightButton.hidden = YES;
    [self keyBoardHidden:notification];
}

- (void)keyBoardHidden:(NSNotification *)notification
{
    CGFloat duration = [[[notification userInfo]objectForKey:UIKeyboardAnimationDurationUserInfoKey]floatValue];
    [UIView animateWithDuration:duration animations:^{
        _putKeyBoardBtn.origin = CGPointMake(kScreenWidth - 42 - 35 / 2.0, kScreenHeight);
    }];
}

- (void)keyBoardAppear:(NSNotification *)notification
{
    NSValue *keyboardRectAsObject=[[notification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat duration = [[[notification userInfo]objectForKey:UIKeyboardAnimationDurationUserInfoKey]floatValue];
    CGRect keyboardRect;
    [keyboardRectAsObject getValue:&keyboardRect];
    CGFloat curkeyBoardHeight = keyboardRect.size.height;
    
    
    UIFont *newFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    UIFontDescriptor *ctfFont = newFont.fontDescriptor;
    NSNumber *fontString = [ctfFont objectForKey:@"NSFontSizeAttribute"];
    
    [UIView animateWithDuration:duration animations:^{
        _putKeyBoardBtn.origin = CGPointMake(kScreenWidth - 42 - 35 / 2.0,kScreenHeight - curkeyBoardHeight - [fontString integerValue] * 2 * 2 - 42 - 10);
    }];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if(scrollView==self.contentTextView){
        [self.contentTextView resignFirstResponder];
    }
}
#pragma mark - Protocol
#pragma mark UITextFieldDelegate,UITextViewDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    _contentHasChanged = YES;
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.contentTextView becomeFirstResponder];
    return NO;
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    if ([text isEqualToString:@"\n"]) {
//        [textView resignFirstResponder];
//        return NO; 
//    }
//    return YES;
//}
//- (void)textFieldDidChange:(UITextField *)textField
//{
//    if (textField == self.titleField) {
//        //内容长度限制
//        if (textField.text.length > kTitleLengthLimit) {
//            textField.text = [textField.text substringToIndex:kTitleLengthLimit];
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"标题不能多于18个字哦！" message:@"" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
//            [alert show];
//        }
//        _contentHasChanged = YES;
//    }
//}
- (void)textViewDidChange:(UITextView *)textView
{
    //占位便签
    if (textView.text.length == 0) {
        self.placeholderLabel.text = @"新建内容";
    }else{
        self.placeholderLabel.text = @"";
    }
    _contentHasChanged = YES;
    
    [self refreshImageContainerViewFrame];
    
    //内容长度限制
//    if (textView == self.contentTextView) {
//        if (textView.text.length > kContentLengthLimit) {
//            textView.text = [textView.text substringToIndex:kContentLengthLimit];
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"内容不能多于%d个字哦！",kContentLengthLimit] message:@"" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
//            [alert show];
//        }
//    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}
- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager lineSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect
{
    return 5;
}
//- (void)textFieldDidChange:(NSNotification *)obj{
//    UITextField *textField = (UITextField *)obj.object;
//    if (textField == self.titleField) {
//        
//        NSString *toBeString = textField.text;
//        
//        //获取高亮部分
//        UITextRange *selectedRange = [textField markedTextRange];
//        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
//        
//        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
//        if (!position)
//        {
//            if (toBeString.length > kTitleLengthLimit)
//            {
//                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:kTitleLengthLimit];
//                if (rangeIndex.length == 1)
//                {
//                    textField.text = [toBeString substringToIndex:kTitleLengthLimit];
//                }
//                else
//                {
//                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, kTitleLengthLimit)];
//                    textField.text = [toBeString substringWithRange:rangeRange];
//                }
//                
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"标题不能多于18个字哦！" message:@"" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
//                [alert show];
//
//            }
//        }
//        
//    }
//}
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        // 拍照
        __weak typeof(self) ws = self;
        [[CamerManager shareInstance] showCameraWithBlock:^{
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = ws;
            [ws presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }];
        
    }else if(buttonIndex==1){
        __weak typeof(self) ws = self;
        [[CamerManager shareInstance]showPhotoLibraryWithBlock:^{
            
            JYBatchSelectionVC *imageVC = [[JYBatchSelectionVC alloc] init];
            imageVC.limitCount = 8-[ws.note.images count];
            imageVC.imageCount = [ws.note.images count];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:imageVC];
            // 将当前已有图片的数量传入
            [imageVC setActionBatchSelection:^(NSArray *arr) {
                
                for(int i=0;i<[arr count];i++){
                    UIImage *img = arr[i];
                    JYNoteImage *jyImg = [JYNoteImage new];
                    jyImg.image = img;
                    jyImg.imageType = JYImageTypeLocal;
                    NSTimeInterval interval = [NSDate timeIntervalSinceReferenceDate];
                    jyImg.path = [self.imageStoragePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%f%ld.jpg",interval,[ws.note.images count]]];
                    [ws.note.images addObject:jyImg];
                }
//                [ws.note.images addObjectsFromArray:arr];
                _contentHasChanged = YES;
                [ws layoutImageViews];
                CGSize newSize = [self.contentTextView sizeThatFits:CGSizeMake(self.contentTextView.bounds.size.width, MAXFLOAT)];
                CGRect rect = CGRectMake(0, newSize.height-1,1, 1);
                [ws.contentTextView scrollRectToVisible:rect animated:YES];
            }];
            [ws presentViewController:nav animated:YES completion:^{}];
        }];
        
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:NO completion:^() {
        UIImage *portraitImg = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        JYNoteImage *jyImg = [JYNoteImage new];
        jyImg.image = portraitImg;
        jyImg.imageType = JYImageTypeLocal;
        NSTimeInterval interval = [NSDate timeIntervalSinceReferenceDate];
        jyImg.path = [self.imageStoragePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%f%ld.jpg",interval,[self.note.images count]]];
        [self.note.images addObject:jyImg];

//        [self.note.images addObject:portraitImg];
        _contentHasChanged = YES;
        [self layoutImageViews];
        CGSize newSize = [self.contentTextView sizeThatFits:CGSizeMake(self.contentTextView.bounds.size.width, MAXFLOAT)];
        CGRect rect = CGRectMake(0, newSize.height-1,1, 1);
        [self.contentTextView scrollRectToVisible:rect animated:YES];

    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - Custom Accessors
- (JYNote *)note
{
    if(!_note){
        _note = [JYNote new];
    }
    return _note;
}

- (UIButton *)cameraButton
{
    if(!_cameraButton){
        _cameraButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,44.f,44.f)];
        [_cameraButton setImage:[[UIImage imageNamed:@"红相机"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        _cameraButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _cameraButton.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        _cameraButton.tintColor = [JYSkinManager shareSkinManager].colorForDateBg;
        [_cameraButton addTarget:self action:@selector(cameraButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cameraButton;
}
- (UIView *)imageContainerView
{
    if(!_imageContainerView){
        _imageContainerView = [UIView new];
        _imageContainerView.backgroundColor = [UIColor whiteColor];
        _imageContainerView.clipsToBounds = YES;
    }
    return _imageContainerView;
}
- (NSString *)imageStoragePath
{
    if(!_imageStoragePath){
//        NSTimeInterval interval = [NSDate timeIntervalSinceReferenceDate];
        NSString *relativePath = [NSString stringWithFormat:@"note/images"];
        NSLog(@"cacheDirectory=%@",relativePath);
        _imageStoragePath = relativePath;
    }
    return _imageStoragePath;
}
@end

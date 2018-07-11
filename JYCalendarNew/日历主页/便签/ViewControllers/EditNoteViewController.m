//
//  EditNoteViewController.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/4/27.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "EditNoteViewController.h"
#import "JYNote.h"
#import "NoteTableManager.h"
#import "JYNoteImage.h"

@interface EditNoteViewController ()
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,assign) BOOL hasLayoutImageView;
@end

@implementation EditNoteViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"记事";
    
    [self customizeUI];
    [self refreshData];
    
//    [self.titleField resignFirstResponder];

}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self layoutImageViews];
}
#pragma mark - Private

- (void)customizeUI
{
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.font = [UIFont systemFontOfSize:12.f];
    self.timeLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:self.timeLabel];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view).offset(15.f);
        make.top.equalTo(self.view).offset(10.f);
        make.height.equalTo(@(40.f));
    }];
//    [self.titleField mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.view);
//        make.top.equalTo(self.timeLabel.mas_bottom);
//        make.height.equalTo(@(40.f));
//    }];
    [self.contentTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.timeLabel.mas_bottom);
        make.bottom.equalTo(self.toolbar.mas_top);
    }];
}
- (void)refreshData
{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    [calendar setTimeZone:[NSTimeZone localTimeZone]];
    NSDateComponents *component = [calendar components:unitFlags fromDate:self.note.updateTime];
    NSDateComponents *todayComponent = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
    NSString *min = component.minute>=10?[NSString stringWithFormat:@"%ld",component.minute]:[NSString stringWithFormat:@"0%ld",component.minute];
    if(component.year==todayComponent.year){//今年不显示年
        self.timeLabel.text = [NSString stringWithFormat:@"编辑于%ld月%ld日 %ld:%@",component.month,component.day,component.hour,min];
    }else{
        self.timeLabel.text = [NSString stringWithFormat:@"编辑于%ld年%ld月%ld日 %ld:%@",component.year,component.month,component.day,component.hour,min];
    }
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setTimeZone:[NSTimeZone localTimeZone]];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSLog(@"===========%@",[df stringFromDate:self.note.createTime]);
    NSLog(@"%@",self.note.createTime);
//    self.titleField.text = self.note.title;
    self.contentTextView.text = self.note.content;
    if(self.note.content.length>0){
        self.placeholderLabel.text = @"";
    }
//    NSLog(@"====%@",self.note.imagePath);
    
    [self.note.images removeAllObjects];
    [self.note.images addObjectsFromArray:[[NoteTableManager sharedManager]findAllImagesOfNote:self.note]];
    
}
- (void)actionForLeft:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    if(self.contentHasChanged){

//        self.note.title = self.titleField.text;
        if(self.contentTextView.text.trimWhitespace.length==0){
            self.note.title = @"新建内容";
        }else if(self.contentTextView.text.trimWhitespace.length<7){
            self.note.title = self.contentTextView.text.trimWhitespace;
        }else{
            self.note.title = [self.contentTextView.text.trimWhitespace subEmojiStringToIndex:7];
        }
        self.note.content = self.contentTextView.text;
        self.note.updateTime = [NSDate date];
        //生成图片相对路径名
        NSMutableArray *tmpArr = [NSMutableArray arrayWithCapacity:[self.note.images count]];
        for(int i=0;i<[self.note.images count];i++){
            JYNoteImage *jyImg = self.note.images[i];
            if(jyImg.imageType==JYImageTypeLocal){
                [tmpArr addObject:jyImg.path];
            }
        }
        self.note.imagePathLocal = [tmpArr componentsJoinedByString:@","];
        [[NoteTableManager sharedManager]updateNoteViaLocal:self.note];

        //没有图片时，不耗时，可以直接返回。有图片时保存较慢，需接收NoteTableManager完成通知再返回。
        if([self.note.images count]==0){
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
/**
 *  点击删除按钮删除图片
 */
- (void)deleteImage:(UIButton *)sender{
    NSInteger index = sender.superview.tag-kImageViewBaseTag;
    if(index<[self.note.images count]){
        JYNoteImage *jyImg = self.note.images[index];
        if(jyImg.imageType==JYImageTypeLocal){
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString* cacheDirectory  = [paths objectAtIndex:0];
            NSString *imgPath = [cacheDirectory stringByAppendingPathComponent:jyImg.path];
            [[NoteTableManager sharedManager] deleteImagesAtPath:imgPath];
        }else if(jyImg.imageType==JYImageTypeRemote){
            NSString *pathToDelete = jyImg.path;
            NSString *fullPath = self.note.imagePathRemote;
            NSMutableArray *arr = [[fullPath componentsSeparatedByString:@","] mutableCopy];
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *p = (NSString *)obj;
                if([p isEqualToString:pathToDelete]){
                    [arr removeObject:p];
                    *stop = YES;
                }
            }];
            self.note.imagePathRemote = [arr componentsJoinedByString:@","]; 
        }
    }
    [super deleteImage:sender];
}
@end

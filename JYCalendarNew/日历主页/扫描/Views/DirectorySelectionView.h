//
//  DirectorySelectionView.h
//  ScanDemo
//
//  Created by Gaolichao on 16/6/2.
//  Copyright © 2016年 Test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DirectoryCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *putDownView;
@property (nonatomic,assign) BOOL showHighLight;
@property (nonatomic,strong) UIView *lineView;

- (void)setTitle:(NSString *)title showHightLight:(BOOL)hightLight;

@end


@interface DirectorySelectionView : UITableView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *dirNames; //of NSString
@property (nonatomic,assign) NSInteger selectedRow;
@property (nonatomic,strong) NSArray *dirs;

@property (nonatomic,copy) void (^selectRowBlock)(NSInteger selectedDirId);

- (void)resetSelectionState;
@end

//
//  PhotoSizeTableView.h
//  ScanDemo
//
//  Created by Gaolichao on 16/5/31.
//  Copyright © 2016年 Test. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PhotoSizeTableView;

@interface PhotoSizeCell : UITableViewCell

@property (nonatomic,strong) UIView *selectionPointView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *detailLabel;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,assign) BOOL showHighLight;


- (void)setTitle:(NSString *)title detail:(NSString *)detail;
@end

@protocol PhotoSizeTableViewDelegate <NSObject>

- (void)photoSizeTableView:(PhotoSizeTableView *)tableView hidenWithSelectedIndexPath:(NSIndexPath *)indexPath;

@end


@interface PhotoSizeTableView : UITableView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *titleArray; //of NSString
@property (nonatomic,strong) NSArray *sizeArray; //of NSString 211*298
@property (nonatomic,assign) NSInteger selectedRow;
@property (nonatomic,weak) id<PhotoSizeTableViewDelegate> sizeDelegate;

//@property (nonatomic,copy) void (^selectRowBlock)(NSIndexPath *indexPath);

+ (CGFloat)rowHeight;

- (void)resetSelectionState;
@end

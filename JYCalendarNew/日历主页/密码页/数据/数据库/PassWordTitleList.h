//
//  PassWordTitleList.h
//  PassWord
//
//  Created by 吴冬 on 16/5/23.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PassWordTitleModel.h"
@interface PassWordTitleList : NSObject

+ (PassWordTitleList *)sharePassWordTitleList;
//插入
- (BOOL)insertDataWithModel:(PassWordTitleModel *)model;
//查询方法
- (NSArray *)selectData;
//删除方法
- (BOOL)deleteWithModel:(PassWordTitleModel *)model;
- (BOOL)deleteAll;
//更新方法
- (BOOL)upWithModel:(PassWordTitleModel *)model;

@end

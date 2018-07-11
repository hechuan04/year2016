//
//  PassWordList.h
//  PassWord
//
//  Created by 吴冬 on 16/5/17.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PassWordModel.h"

typedef void (^completionBlock)(BOOL);

@interface PassWordList : NSObject


+ (PassWordList *)sharePassList;

//插入
- (void)insertDataWithModel:(PassWordModel *)model
            completionBlock:(completionBlock)block;

//更新
- (void)upDataWithModel:(PassWordModel *)model
        completionBlock:(completionBlock)block;



//删除
- (void)deleteDataWithModel:(PassWordModel *)model
            completionBlock:(completionBlock)block;
//删除全部
- (void)deleteAllModel;
//根据type删除
- (void)deletedataWithType:(int )mid
           completionBlock:(completionBlock)block;

//查询
- (NSArray *)selectModelWithType:(int )mid;

//查询个数
- (NSArray *)selectCountWithType:(NSArray *)typeArr;

@end

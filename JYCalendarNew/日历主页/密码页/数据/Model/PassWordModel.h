//
//  PassWordModel.h
//  PassWord
//
//  Created by 吴冬 on 16/5/16.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PassWordModel : NSObject

@property (nonatomic ,assign)int oid;
@property (nonatomic ,assign)int type_id;
@property (nonatomic ,assign)int mid;
@property (nonatomic ,copy)NSString *title;
@property (nonatomic ,copy)NSString *userName;
@property (nonatomic ,copy)NSString *passWord;
@property (nonatomic ,copy)NSString *detail;
@property (nonatomic ,copy)NSString *createTime;


@end

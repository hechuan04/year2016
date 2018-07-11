//
//  NoteTableManager.h
//  JYCalendarNew
//
//  Created by Gaolichao on 16/4/27.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JYNote;
@interface NoteTableManager : NSObject

+ (instancetype)sharedManager;

- (BOOL)ifNoteHasExistWithTid:(NSString *)tid;
- (NSArray *)findAllNotes;
- (BOOL)insertNoteByLocal:(JYNote *)note;
- (BOOL)insertNoteBySync:(JYNote *)note;
- (BOOL)updateNoteViaLocal:(JYNote *)note;//本地修改更新
- (BOOL)updateNoteViaSync:(JYNote *)note;//同步回调更新
- (BOOL)deleteNote:(JYNote *)note;
- (BOOL)deleteNotes:(NSArray *)notes;

- (NSArray *)findAllImagesOfNote:(JYNote *)note; //return of JYNoteImage
- (BOOL)deleteOldNoteImages:(JYNote *)note;
- (BOOL)deleteImagesAtPath:(NSString *)imgPath;
@end

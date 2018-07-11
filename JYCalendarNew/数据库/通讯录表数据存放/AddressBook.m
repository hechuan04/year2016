//
//  AddressBook.m
//  JYCalendar
//
//  Created by 吴冬 on 15/11/23.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "AddressBook.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

static AddressBook *addressBook = nil;

@implementation AddressBook


+ (AddressBook *)shareAddressBook
{
 
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (addressBook == nil) {
            
            addressBook = [[AddressBook alloc] init];
        }
        
    });

    return addressBook;
}

- (void)actionForAddress
{
    
    NSMutableArray *arrForName = [NSMutableArray array];
    
    //获取通讯录控制器
    //ABPeoplePickerNavigationController *_pickerView = [[ABPeoplePickerNavigationController alloc] init];
    
    ABAddressBookRef tmpAddressBook = nil;
    if([[UIDevice currentDevice].systemVersion floatValue] >= 7.0){
        //_pickerView.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:false];
        tmpAddressBook=ABAddressBookCreateWithOptions(NULL, NULL);
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(tmpAddressBook, ^(bool greanted, CFErrorRef error){
            dispatch_semaphore_signal(sema);
        });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
    }else{
        
        //获取通讯录的所有内容
        tmpAddressBook=ABAddressBookCreateWithOptions(NULL, NULL);
        
    }
    
    
    //获取通讯录的所有内容
    NSArray *arr = (__bridge  NSArray *)ABAddressBookCopyArrayOfAllPeople(tmpAddressBook);
    
    
    NSMutableDictionary *dicforAllName = [NSMutableDictionary dictionary];
    NSMutableDictionary *dicForTelAndName = [NSMutableDictionary dictionary];
    
    for (id person in arr) {
        
        FriendModel *model = [[FriendModel alloc] init];
        
        
        NSString *firstName = (__bridge NSString *)ABRecordCopyValue((__bridge ABRecordRef)(person), kABPersonFirstNameProperty);
        NSString *lastName = (__bridge NSString *)ABRecordCopyValue((__bridge ABRecordRef)(person), kABPersonLastNameProperty);
        
        
        NSString *nameAll = nil;
        
        if (firstName == NULL && lastName != NULL) {
            
            nameAll = lastName;
            
        }else if(firstName != NULL && lastName == NULL){
            
            nameAll = firstName;
            
        }else {
            
            nameAll = [NSString stringWithFormat:@"%@%@",lastName,firstName];
        }
        
        
        
        ABMultiValueRef tmpPhones = ABRecordCopyValue((__bridge ABRecordRef)person, kABPersonPhoneProperty);
        
        
        NSString *numebr = (__bridge NSString *)ABMultiValueCopyValueAtIndex(tmpPhones, 0);
        
        
        model.friend_name = nameAll;
        model.tel_phone = [NSString stringWithFormat:@"%@",numebr];
        
        
        
        NSArray *arrForT = [model.tel_phone componentsSeparatedByString:@"-"];
        
        NSMutableString *strForTel = [NSMutableString string];
        for (int i = 0; i < arrForT.count; i++) {
            
            [strForTel appendString:arrForT[i]];
            
        }
        
        NSArray *arrForKong = [strForTel componentsSeparatedByString:@" "];
        NSMutableString *strForTelEnd = [NSMutableString string];
        
        if (arrForKong.count > 1) {
            
            for (int i = 0; i < arrForKong.count; i++) {
                
                [strForTelEnd appendString:arrForKong[i]];
            }
            
        }else {
            
            strForTelEnd = arrForKong[0];
        }
        
        
        NSString *threeStr = [strForTelEnd substringWithRange:NSMakeRange(0, 3)];
        NSString *endStr = @"";
        if ([threeStr isEqualToString:@"+86"]) {
            
            endStr = [strForTelEnd substringWithRange:NSMakeRange(3, strForTelEnd.length - 3)];
            
        }else{
            
            endStr = strForTelEnd;
        }
        
        model.tel_phone = endStr;
        
        
        //11位电话号码
        if (model.tel_phone.length == 11) {
            
            [dicforAllName setObject:model forKey:endStr];
            [arrForName addObject:model];
            
            [dicForTelAndName setObject:nameAll forKey:endStr];
        }
        
    }
    
    
    
    AddressBook *address = [AddressBook shareAddressBook];
    //先存储一下现有的Model,确保还能取到
    address.arrForBeforeA  = arrForName;
    address.dicForAllName = dicforAllName;
    address.dicForAllTelAndName = dicForTelAndName;
    //[RequestManager actionForAddressBookWithArr:_arrForName];
    
}
@end

//
//  SearchMapViewController.h
//  JYCalendarNew
//
//  Created by mac on 16/8/30.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UISearchBar+FMAdd.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface SearchMapViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UIScrollViewDelegate,BMKPoiSearchDelegate,UISearchDisplayDelegate>

@property (nonatomic ,copy)void (^actionForSelectedLoc)(BMKPoiInfo *info);
@property (nonatomic, strong)NSString *keywordString;

@end

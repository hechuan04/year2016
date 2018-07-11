//
//  GroupAvatarView.m
//  AvatarDemo
//
//  Created by Gaolichao on 16/8/11.
//  Copyright © 2016年 liberty. All rights reserved.
//

#import "GroupAvatarView.h"
#import "SDImageCache.h"
#import "SDWebImageManager.h"

@interface GroupAvatarView()
@property (nonatomic,strong) NSMutableArray *avatarLayers; //of CAShapLayer
@end
@implementation GroupAvatarView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = frame.size.width/2.f;
        self.layer.masksToBounds = YES;
    }
    return self;
}

#pragma mark - Public
- (void)setAvatars:(NSArray *)avatars
{
    if(!avatars||[avatars count]==0){
        NSLog(@"头像数组为空!");
        NSArray *avas = @[[UIImage imageNamed:@"默认用户头像"]];
        _avatars = avas;
        [self createSubLayersWithAvatars:avas];
        return;
    }
    NSArray *arr = avatars;
    if([avatars count]>4){
        arr = [avatars subarrayWithRange:NSMakeRange(0, 4)];
    }
    _avatars = arr;

    [self createSubLayersWithAvatars:arr];
    
}
- (void)setAvatarUrls:(NSArray *)avatarUrls
{
    if(!avatarUrls||[avatarUrls count]==0){
        NSLog(@"头像数组为空!");
        self.avatars = @[];
        return;
    }
    NSArray *arr = avatarUrls;
    if([avatarUrls count]>4){
        arr = [avatarUrls subarrayWithRange:NSMakeRange(0, 4)];
    }
    _avatarUrls = arr;
    [self createSubLayersWithAvatarUrls:arr];
}

#pragma mark - Private
- (CAShapeLayer *)createSubLayer
{
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    layer.frame = self.bounds;
    return layer;
}

//通过图片数组生成子layer
- (void)createSubLayersWithAvatars:(NSArray *)avatars
{
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    NSInteger count = [avatars count];
    double sumAngle = M_PI * 2;
    double arcAngle = sumAngle/count;
    double startAngle = 0;
    switch (count) {
        case 2:
            startAngle = - M_PI_2;
            break;
        case 3:
            startAngle = M_PI_2 / 3;
            break;
        case 4:
            startAngle = 0;
            break;
        default:
            break;
    }
    CGRect frame = self.frame;
    CGPoint center = CGPointMake(frame.size.width/2.f, frame.size.height/2.f);
    
    self.avatarLayers = [NSMutableArray arrayWithCapacity:count];
    
    
    //生成mask layer
    for(int i=0; i<count; i++){
        CAShapeLayer *layer = [self createSubLayer];
        UIImage *img = avatars[i];
        layer.contents =  (__bridge id _Nullable)(img.CGImage);
        layer.contentsGravity = kCAGravityResizeAspectFill;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithArcCenter:center
                                                            radius:frame.size.width/2.f
                                                        startAngle:startAngle+arcAngle*i
                                                          endAngle:startAngle+arcAngle*i+arcAngle                                                         clockwise:YES];
        [maskPath addLineToPoint:center];
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.fillColor = [UIColor purpleColor].CGColor;
        maskLayer.path = maskPath.CGPath;
        layer.mask = maskLayer;
        
        [self.layer addSublayer:layer];
        [self.avatarLayers addObject:layer];
    }
    
    //分割线
    for(int i=0; i<count; i++){
        if(count>1){
            UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                                radius:frame.size.width/2.f
                                                            startAngle:startAngle+arcAngle*i
                                                              endAngle:startAngle+arcAngle*i+arcAngle                                                         clockwise:YES];
            
            [path addLineToPoint:center];
            CAShapeLayer *lineLayer = [CAShapeLayer layer];
            lineLayer.fillColor = [UIColor clearColor].CGColor;
            lineLayer.strokeColor = [UIColor whiteColor].CGColor;
            lineLayer.lineWidth = 2.f;
            lineLayer.path = path.CGPath;
            [self.layer addSublayer:lineLayer];
        }
    }

}
//通过url数组生成子layer
- (void)createSubLayersWithAvatarUrls:(NSArray *)avatarUrls
{
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    NSInteger count = [avatarUrls count];
    NSMutableDictionary *imgDic = [NSMutableDictionary dictionaryWithCapacity:count];
    
    for(int i=0; i<count; i++){
        NSString *urlStr = avatarUrls[i];
        UIImage *img = [[SDImageCache sharedImageCache]imageFromDiskCacheForKey:urlStr];
        if(img){
            [imgDic setObject:img forKey:urlStr];
        }
    }
//    NSLog(@"-----%@",imgDic);
    if(imgDic.count == [self.avatarUrls count]){//全部取到缓存，直接用
        [self createSubLayersWithAvatars:imgDic.allValues];
    }else{
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
        dispatch_group_t group = dispatch_group_create();
        
        for(int i=0; i<[avatarUrls count]; i++){
            NSString *urlStr = avatarUrls[i];
            if(![[imgDic allKeys] containsObject:urlStr]){
                [imgDic setObject:[UIImage imageNamed:@"默认用户头像"] forKey:urlStr];
                dispatch_group_async(group, queue, ^{
                    NSURLResponse* urlResponse;
                    NSError* error;
                    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
                    NSData* data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&urlResponse error:&error];
                    UIImage *img = [UIImage imageWithData:data];
                    //[NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]]
                    if(img){
                        [imgDic setObject:img forKey:urlStr];
                        [[SDImageCache sharedImageCache] storeImage:img forKey:urlStr];
                    }else{
                        NSLog(@"image download error");
                        [imgDic setObject:[UIImage imageNamed:@"默认用户头像"] forKey:urlStr];
                    }
                });
            }
        }
        [self createSubLayersWithAvatars:imgDic.allValues];
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            [self createSubLayersWithAvatars:imgDic.allValues];
        });
        
    }
}
#pragma mark - Custom Accessors
@end

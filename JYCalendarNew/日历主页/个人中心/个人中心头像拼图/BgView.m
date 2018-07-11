//
//  BgView.m
//  Header
//
//  Created by 吴冬 on 16/3/16.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "BgView.h"

@implementation BgView


-(UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size{
    
    
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    
    CGFloat width = imageSize.width;
    
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = size.width;
    
    CGFloat targetHeight = size.height;
    
    CGFloat scaleFactor = 0.0;
    
    CGFloat scaledWidth = targetWidth;
    
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        
        CGFloat widthFactor = targetWidth / width;
        
        CGFloat heightFactor = targetHeight / height;
        
        
        if(widthFactor > heightFactor){
            
            scaleFactor = widthFactor;
            
            
        }
        
        else{
            
            
            scaleFactor = heightFactor;
            
        }
        
        scaledWidth = width * scaleFactor;
        
        scaledHeight = height * scaleFactor;
        
        
        if(widthFactor > heightFactor){
            
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        }else if(widthFactor < heightFactor){
            
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            
        }
        
    }
    
    
    UIGraphicsBeginImageContext(size);
    
    
    CGRect thumbnailRect = CGRectZero;
    
    thumbnailRect.origin = thumbnailPoint;
    
    thumbnailRect.size.width = scaledWidth;
    
    thumbnailRect.size.height = scaledHeight;
    
    
    [sourceImage drawInRect:thumbnailRect];
    
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        
        //NSLog(@"scale image fail");
        
    }
    
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

    
    
    CGFloat width = rect.size.width;
    
    UIImage *image = nil;
    
    if (_arrForImage.count == 0) {
        
        image = [UIImage imageNamed:@"默认用户头像"];
        
    }else{
     
        image = _arrForImage[_number - 1];
    }
    
    image = [self imageCompressForSize:image targetSize:CGSizeMake(width, width)];
    
    if(_type == 2){
     
        if (_number == 1) {
            
           
            CGContextRef ctx = UIGraphicsGetCurrentContext();
            
            CGContextMoveToPoint(ctx, 0, 0);
            CGContextAddLineToPoint(ctx, 0, width);
            CGContextAddLineToPoint(ctx, width / 2.0 - 1, width);
            CGContextAddLineToPoint(ctx, width / 2.0 - 1, 0);
            
            CGContextClip(ctx);
            
            [image drawAtPoint:CGPointMake(0, 0)];
            
        }else{
         
        
            
     
            CGContextRef ctx = UIGraphicsGetCurrentContext();
            
            CGContextMoveToPoint(ctx, width / 2.0 + 1, 0);
            CGContextAddLineToPoint(ctx, width / 2.0 + 1, width);
            CGContextAddLineToPoint(ctx, width , width);
            CGContextAddLineToPoint(ctx, width, 0);
            
            CGContextClip(ctx);
            
            [image drawAtPoint:CGPointMake(0, 0)];
            
            
        }
       
        
        
    }else if(_type == 3){
     
        if (_number == 1) {
            
            CGContextRef ctx = UIGraphicsGetCurrentContext();
            
            
            
            CGContextMoveToPoint(ctx, 0, 0);
            CGContextAddLineToPoint(ctx, width / 2.0 - 1, 0);
            CGContextAddLineToPoint(ctx, width / 2.0 - 1, width / 2.0 - 1);
            CGContextAddLineToPoint(ctx, 0, width * (3 / 4.0) - 1);
            
            //指定上下文中可以显示内容的范围就是圆的范围
            CGContextClip(ctx);
            
            [image drawAtPoint:CGPointMake(0, 0)];
            
        }else if(_number == 2){
            
           
            CGContextRef ctx = UIGraphicsGetCurrentContext();
            
            CGContextMoveToPoint(ctx, width / 2.0 + 1 , 0);
            CGContextAddLineToPoint(ctx, width / 2.0 + 1, width / 2.0 - 1);
            CGContextAddLineToPoint(ctx, width, width * (3 / 4.0)  - 1);
            CGContextAddLineToPoint(ctx, width, 0);
            
            CGContextClip(ctx);
            
            [image drawAtPoint:CGPointMake(0, 0)];
            
            
        }else{
            
       
            CGContextRef ctx = UIGraphicsGetCurrentContext();
            
            CGContextMoveToPoint(ctx, 0, width * (3 / 4.0)  + 1);
            CGContextAddLineToPoint(ctx, width / 2.0 , width  / 2.0 + 1);
            CGContextAddLineToPoint(ctx, width, width * (3 / 4.0) + 1);
            CGContextAddLineToPoint(ctx, width, width);
            CGContextAddLineToPoint(ctx, 0, width);
            
            CGContextClip(ctx);
            
            [image drawAtPoint:CGPointMake(0, 0)];
            
        }
        
    }else{
     
        if (_number == 1) {
            
            
            CGContextRef ctx = UIGraphicsGetCurrentContext();
            
            CGContextMoveToPoint(ctx, 0, 0);
            CGContextAddLineToPoint(ctx, 0,width / 2.0 - 1);
            CGContextAddLineToPoint(ctx, width / 2.0 - 1, width / 2.0 - 1);
            CGContextAddLineToPoint(ctx, width  /2.0 - 1, 0);
            
            CGContextClip(ctx);
            
            [image drawAtPoint:CGPointMake(0, 0)];
            
//
        }else if(_number == 2){
         
         
            CGContextRef ctx = UIGraphicsGetCurrentContext();
            
            CGContextMoveToPoint(ctx, width / 2.0 + 1, 0);
            CGContextAddLineToPoint(ctx, width / 2.0 + 1, width / 2.0 - 1);
            CGContextAddLineToPoint(ctx, width , width / 2.0 - 1);
            CGContextAddLineToPoint(ctx, width , 0);
            
            CGContextClip(ctx);
            
            [image drawAtPoint:CGPointMake(0, 0)];
            
//

            
        }else if(_number == 3){
         
            CGContextRef ctx = UIGraphicsGetCurrentContext();
            
            CGContextMoveToPoint(ctx, width / 2.0 + 1, width / 2.0 + 1);
            CGContextAddLineToPoint(ctx, width / 2.0 + 1,width);
            CGContextAddLineToPoint(ctx, width , width);
            CGContextAddLineToPoint(ctx, width, width / 2.0 + 1);
            
            CGContextClip(ctx);
            
            [image drawAtPoint:CGPointMake(0, 0)];
            
//
        }else{
        
            CGContextRef ctx = UIGraphicsGetCurrentContext();
            
            CGContextMoveToPoint(ctx, 0, width / 2.0 + 1);
            CGContextAddLineToPoint(ctx, 0, width);
            CGContextAddLineToPoint(ctx, width / 2.0 - 1 , width);
            CGContextAddLineToPoint(ctx, width / 2.0 - 1, width / 2.0 + 1);

//            
            CGContextClip(ctx);
            
            [image drawAtPoint:CGPointMake(0, 0)];
            

        }
        
    }
    
   

    
}



@end

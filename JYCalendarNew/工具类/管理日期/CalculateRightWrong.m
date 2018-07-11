//
//  CalculateRightWrong.m
//  LiuNianYunCheng
//
//  Created by 吴冬 on 15/9/1.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "CalculateRightWrong.h"

@implementation CalculateRightWrong
{

    NSArray * jcName0;
    NSArray * jcName1;
    NSArray * jcName2;
    NSArray * jcName3;
    NSArray * jcName4;
    NSArray * jcName5;
    NSArray * jcName6;
    NSArray * jcName7;
    NSArray * jcName8;
    NSArray * jcName9;
    NSArray * jcName10;
    NSArray * jcName11;
    
    NSArray * solarMonth;//i的数是这个数组返回的
    
    NSMutableArray * cld;//存 字和0/非0得数组
    NSString * _y;  //年
    NSString * _m; //月
    int  _imac; // i的个数
    int _day;   //天
    
    int _lm2;//不知道什么鬼
    int _ly2;//不知道什么鬼
    long long int _ld2;//不知道什么鬼

}

- (instancetype)init
{
  
    if (self = [super init]) {
        
    
    }
 
    return self;
}

-(NSString *)claconv2YY:(int)yy mm:(int )mm dd:(int)dd y:(int)g d:(int )d{
    
//    NSString * dy = [NSString stringWithFormat:@"%d%d",d,dd];
//    //6 8 9 0 5
//    if ((yy==0 && dd==6)||(yy==6 && dd==0)||(yy==1 && dd==7)||(yy==7 && dd==1)||(yy==2 && dd==8)||(yy==8 && dd==2)||(yy==3 && dd==9)||(yy==9 && dd==3)||(yy==4 && dd==10)||(yy==10 && dd==4)||(yy==5 && dd==11)||(yy==11 && dd==5)){
//        
//        return @"日值岁破 大事不宜";
//        
//    }else if ((mm==0 && dd==6)||(mm==6 && dd==0)||(mm==1 && dd==7)||(mm==7 && dd==1)||(mm==2 && dd==8)||(mm==8 && dd==2)||(mm==3 && dd==9)||(mm==9 && dd==3)||(mm==4 && dd==10)||(mm==10 && dd==4)||(mm==5 && dd==11)||(mm==11 && dd==5)){
//        return @"日值月破 大事不宜";
//        
//    } else if ((g==0 && [dy isEqualToString:@"911"])||(g==1 && [dy isEqualToString:@"55"])||(g==2 && [dy isEqualToString:@"111"])||(g==3 && [dy isEqualToString:@"75"])||(g==4 && [dy isEqualToString:@"311"])||(g==5 && [dy isEqualToString:@"95"])||(g==6 && [dy isEqualToString:@"511"])||(g==7 && [dy isEqualToString:@"15"])||(g==8 && [dy isEqualToString:@"711"])||(g==9 && [dy isEqualToString:@"35"])) {
//        
//        return @"日值上朔 大事不宜";
//    }else{
//        
//        return @"0";
//        
//    }
    
    return @"0";
}
- (NSDictionary *)suanYiji{
    return [self suanYijiWithDate:[NSDate date]];
}
-(NSDictionary *)suanYijiWithDate:(NSDate *)date{
    
    _lm2 = 0;
    _ly2 = 0;
    _ld2 = 0;
    _imac = 0;
    _day = 0;
    jcName0 = @[@"建",@"除",@"满",@"平",@"定",@"执",@"破",@"危",@"成",@"收",@"开",@"闭"];
    jcName1 = @[@"闭",@"建",@"除",@"满",@"平",@"定",@"执",@"破",@"危",@"成",@"收",@"开"];
    jcName2 = @[@"开",@"闭",@"建",@"除",@"满",@"平",@"定",@"执",@"破",@"危",@"成",@"收"];
    jcName3 = @[@"收",@"开",@"闭",@"建",@"除",@"满",@"平",@"定",@"执",@"破",@"危",@"成"];
    jcName4 = @[@"成",@"收",@"开",@"闭",@"建",@"除",@"满",@"平",@"定",@"执",@"破",@"危"];
    jcName5 = @[@"危",@"成",@"收",@"开",@"闭",@"建",@"除",@"满",@"平",@"定",@"执",@"破"];
    jcName6 = @[@"破",@"危",@"成",@"收",@"开",@"闭",@"建",@"除",@"满",@"平",@"定",@"执"];
    jcName7 = @[@"执",@"破",@"危",@"成",@"收",@"开",@"闭",@"建",@"除",@"满",@"平",@"定"];
    jcName8 = @[@"定",@"执",@"破",@"危",@"成",@"收",@"开",@"闭",@"建",@"除",@"满",@"平"];
    jcName9 = @[@"平",@"定",@"执",@"破",@"危",@"成",@"收",@"开",@"闭",@"建",@"除",@"满"];
    jcName10=@[@"满",@"平",@"定",@"执",@"破",@"危",@"成",@"收",@"开",@"闭",@"建",@"除"];
    jcName11= @[@"除",@"满",@"平",@"定",@"执",@"破",@"危",@"成",@"收",@"开",@"闭",@"建"];
    
    solarMonth = @[@(31),@(28),@(31),@(30),@(31),@(30),@(31),@(31),@(30),@(31),@(30),@(31)];
    
    
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    
    
    //获取年月
    _y = [currentDateStr substringWithRange:NSMakeRange(0, 4)];
    _m = [currentDateStr substringWithRange:NSMakeRange(5, 2)];
    
    NSString * str  = [currentDateStr substringWithRange:NSMakeRange(8, 2)];
    _day = [str intValue];
    
    
    NSDate *dateFromString = [dateFormatter dateFromString:@"1970-01-01"];
    NSDate *dateToString = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@-%@-%@",_y,_m,@"01"]];
    long long int timediff = [dateToString timeIntervalSince1970]-[dateFromString timeIntervalSince1970];
    
    long long  int tian = timediff / 86400 + 25567 + 10;
    
    
    
    if (_day < 8) {
        
    }else if(_day == 10){
        _day = _day -1;
    }else{
        _day = _day -1;
        
    }
    
    //dayCyclical	long long	1440673169408	1440673169408
    _imac = [self solarDaysY:[_y intValue] andM:[_m intValue]];
    //NSLog(@"%d",_imac);
    
    _lm2 = ([_y intValue] - 1970) * 12 + [_m intValue] + 12;
    _ly2 = ([_y intValue] - 1970  + 36 -1);
    
    //NSLog(@"lm2 =%d,ly2 = %d",_lm2,_ly2);
    
    
    cld =  [NSMutableArray arrayWithCapacity:_imac];
    
    for (int p  = 0; p < _imac; p ++) {
        NSMutableArray * marray=[NSMutableArray arrayWithCapacity:_imac];
        
        [cld addObject:marray];
    }
    
    for (int c = 0;c < _imac ; c++) {
        
        _ld2 = tian + c;
        
        
        int yyyyy12 = _ly2 %12;
        int mmmm = _lm2 %12;
        int  dddd12 = _ld2 % 12;
        int yyyy10 = _ly2 % 10;
        int dddd10 = _ld2  %10;
        NSString * sqz3 = [self cyclical6Num:mmmm andNum2:dddd12];
        
        NSString * sqz5 = [self claconv2YY:yyyyy12 mm:mmmm dd:dddd12 y:yyyy10 d:dddd10];
        
        [cld[c] addObject:@[sqz3,sqz5]];
        
        
    }
    
    NSDictionary * dictyj = [NSDictionary dictionary];
    if (_day >= cld.count) {
        _day = cld.count - 1;
    }
    if (![cld[_day][0][1] isEqualToString:@"0"]) {
        
        NSString * str =cld[_day][0][1];
        dictyj = @{@"综合":str};
        
    }else{
        dictyj =[self jar:cld[_day][0][0]];
        //NSLog(@"%@",dictyj);
    }
    
    return dictyj;
}

-(NSString *)cyclical6Num:(int) num andNum2:(int) num2{
    if (num==0) return(jcName0[num2]);
    if (num==1) return(jcName1[num2]);
    if (num==2) return(jcName2[num2]);
    if (num==3) return(jcName3[num2]);
    if (num==4) return(jcName4[num2]);
    if (num==5) return(jcName5[num2]);
    if (num==6) return(jcName6[num2]);
    if (num==7) return(jcName7[num2]);
    if (num==8) return(jcName8[num2]);
    if (num==9) return(jcName9[num2]);
    if (num==10) return(jcName10[num2]);
    if (num==11) return(jcName11[num2]);
    return nil;
}

-(int )solarDaysY:(int)a andM:(int)b{
    
    if (b == 1) {
        return((b %4 == 0 && b%100 != 0) || (b%400 == 0)? 29: 28);
        
    }else{
        return [solarMonth[b - 1] intValue];
    }
    
}

-(NSDictionary *)jar:(id)d{
    //NSLog(@"%@",d);
    NSDictionary * yjdict = [NSDictionary dictionary];
    
    if([d isEqualToString:@"建"]){ yjdict = @{@"宜":@"出行 上任 会友 上书 见工", @"忌":@"动土 开仓 嫁娶 纳采"};
        
    }else if([d isEqualToString:@"除"]){ yjdict = @{@"宜":@"除服 疗病 出行 拆卸 入宅", @"忌":@"求官 上任 开张 搬家 探病"};
        
    }else if([d isEqualToString:@"满"]){ yjdict = @{@"宜":@"祈福 祭祀 结亲 开市 交易", @"忌":@"服药 求医 栽种 动土 迁移"};
        
    }else if([d isEqualToString:@"平"]){ yjdict = @{@"宜":@"祭祀 修坟 涂泥 餘事勿取", @"忌":@"移徙 入宅 嫁娶 开市 安葬"};
        
    }else if([d isEqualToString:@"定"]){ yjdict = @{@"宜":@"交易 立券 会友 签约 纳畜", @"忌":@"种植 置业 卖田 掘井 造船"};
        
    }else if([d isEqualToString:@"执"]){ yjdict = @{@"宜":@"祈福 祭祀 求子 结婚 立约", @"忌":@"开市 交易 搬家 远行"};
        
    }else  if([d isEqualToString:@"破"]){yjdict = @{@"宜":@"求医 赴考 祭祀 馀事勿取", @"忌":@"动土 出行 移徙 开市 修造"};
        
    }else  if([d isEqualToString:@"危"]){ yjdict = @{@"宜":@"经营 交易 求官 纳畜 动土", @"忌":@"登高 行船 安床 入宅 博彩"};
        
    }else  if([d isEqualToString:@"成"]){ yjdict = @{@"宜":@"祈福 入学 开市 求医 成服", @"忌":@"词讼 安门 移徙"};
        
    }else if([d isEqualToString:@"收"]){ yjdict = @{@"宜":@"祭祀 求财 签约 嫁娶 订盟", @"忌":@"开市 安床 安葬 入宅 破土"};
        
    }else if([d isEqualToString:@"开"]){ yjdict = @{@"宜":@"疗病 结婚 交易 入仓 求职", @"忌":@"安葬 动土 针灸"};
        
    }else if([d isEqualToString:@"闭"]){ yjdict = @{@"宜":@"祭祀 交易 收财 安葬", @"忌":@"宴会 安床 出行 嫁娶 移徙"};
    }
    return yjdict;
}



@end

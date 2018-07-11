//
//  AppDelegate+LoadData.m
//  JYCalendar
//
//  Created by 吴冬 on 15/12/4.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//






#import "AppDelegate+LoadData.h"

@implementation AppDelegate (LoadData)

- (void)actionForCalendarData{
    
    JYSelectManager *manager = [JYSelectManager shareSelectManager];
    
    //manager.dicForAllLabel = [NSMutableDictionary dictionary];
    
    manager.arrForAllLunarDay = [NSArray arrayWithObjects:@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十", @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十", @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十", @"三一", nil];
    
    manager.arrForAllLunarMonth = [NSArray arrayWithObjects:@"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月", @"九月",  @"十月", @"冬月", @"腊月", nil];
    
    manager.chineseHoliday = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"春节", @"1|1",
                              @"元宵", @"1|15",
                              @"端午", @"5|5",
                              @"七夕", @"7|7",
                              @"中元", @"7|15",
                              @"中秋", @"8|15",
                              @"重阳", @"9|9",
                              @"腊八", @"12|8",
                              @"小年", @"12|23",
                              @"除夕", @"12|30",
                              nil];
    
    manager.noWorkHoliday = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"元旦", @"1|1",
                             @"劳动节", @"5|1",
                             @"国庆节", @"10|1",
                             @"清明节", @"4|4",
                             @"青年节", @"5|4",
                             @"儿童节", @"6|1",
                             nil];
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
    [dict setObject:@" 元旦" forKey:@"0101"];
//    [dict setObject:@" 中国第13亿人口日" forKey:@"0106"];
//    [dict setObject:@" 世界湿地日" forKey:@"0202"];
//    [dict setObject:@" 国际气象节" forKey:@"0210"];
    [dict setObject:@"情人节" forKey:@"0214"];
//    [dict setObject:@" 邓小平逝世纪念日" forKey:@"0219"];
//    [dict setObject:@" 国际母语日 反对殖民制度斗争日" forKey:@"0221"];
//    [dict setObject:@" 国际海豹日" forKey:@"0301"];
//    [dict setObject:@" 全国爱耳日" forKey:@"0303"];
//    [dict setObject:@" 学雷锋纪念日 中国青年志愿者服务日" forKey:@"0305"];
    [dict setObject:@"妇女节" forKey:@"0308"];
    [dict setObject:@"植树节" forKey:@"0312"];
//    [dict setObject:@" 消费权益" forKey:@"0315"];
//    [dict setObject:@" 中国国医节 国际航海日" forKey:@"0317"];
//    [dict setObject:@" 世界森林日 消除种族歧视国际日 世界睡眠日" forKey:@"0321"];
//    [dict setObject:@" 世界水日 复活节" forKey:@"0322"];
//    [dict setObject:@" 世界气象日 复活节" forKey:@"0323"];
//    [dict setObject:@" 世界防治结核病日" forKey:@"0324"];
    [dict setObject:@"愚人节" forKey:@"0401"];
//    [dict setObject:@" 国际儿童图书日 复活节" forKey:@"0402"];
    [dict setObject:@"卫生日" forKey:@"0407"];
    [dict setObject:@"地球日" forKey:@"0422"];
//    [dict setObject:@" 世界图书和版权日" forKey:@"0423"];
//    [dict setObject:@" 世界青年反对殖民主义日" forKey:@"0424"];
//    [dict setObject:@" 知识产权" forKey:@"0426"];
    [dict setObject:@" 劳动节" forKey:@"0501"];
    [dict setObject:@" 哮喘日" forKey:@"0503"];
//    [dict setObject:@" 哮喘日 世界新闻自由日" forKey:@"0503"];
    [dict setObject:@" 青年节" forKey:@"0504"];
//    [dict setObject:@" 红十字日 世界微笑日" forKey:@"0508"];
//    [dict setObject:@" 国际家庭日" forKey:@"0515"];
//    [dict setObject:@" 国际电信日" forKey:@"0517"];
//    [dict setObject:@" 国际博物馆日" forKey:@"0518"];
//    [dict setObject:@"无烟日" forKey:@"0531"];
    [dict setObject:@"儿童节" forKey:@"0601"];
//    [dict setObject:@"环境日" forKey:@"0605"];
//    [dict setObject:@" 世界无童工日" forKey:@"0612"];
//    [dict setObject:@" 世界献血者日" forKey:@"0614"];
//    [dict setObject:@" 中国儿童慈善活动日" forKey:@"0622"];
//    [dict setObject:@" 奥林匹克" forKey:@"0623"];
//    [dict setObject:@" 全国土地日" forKey:@"0625"];
//    [dict setObject:@" 香港回归 中国共产党诞生日" forKey:@"0701"];
//    [dict setObject:@" 朱德逝世纪念日" forKey:@"0706"];
//    [dict setObject:@" 抗日战争纪念日" forKey:@"0707"];
//    [dict setObject:@" 世界人口日" forKey:@"0711"];
//    [dict setObject:@" 第一次世界大战爆发" forKey:@"0728"];
//    [dict setObject:@" 非洲妇女日" forKey:@"0730"];
    [dict setObject:@"建军节" forKey:@"0801"];
//    [dict setObject:@" 恩格斯逝世纪念日" forKey:@"0805"];
//    [dict setObject:@" 国际电影节" forKey:@"0806"];
//    [dict setObject:@" 中国男子节" forKey:@"0808"];
//    [dict setObject:@" 国际青年节" forKey:@"0812"];
//    [dict setObject:@" 国际左撇子日" forKey:@"0813"];
//    [dict setObject:@" 日本投降" forKey:@"0815"];
//    [dict setObject:@" 全国律师咨询日" forKey:@"0826"];
    [dict setObject:@"开学日" forKey:@"0901"];
//    [dict setObject:@" 抗战胜利" forKey:@"0903"];
//    [dict setObject:@" 国际新闻工作者日" forKey:@"0908"];
//    [dict setObject:@" 毛泽东逝世纪念日" forKey:@"0909"];
    [dict setObject:@"教师节" forKey:@"0910"];
//    [dict setObject:@" 世界清洁地球日" forKey:@"0914"];
//    [dict setObject:@" 国际臭氧层保护日 中国脑健康日" forKey:@"0916"];
    [dict setObject:@"九·一八" forKey:@"0918"];
//    [dict setObject:@" 国际爱牙日" forKey:@"0920"];
//    [dict setObject:@" 世界停火日 预防世界老年性痴呆宣传日" forKey:@"0921"];
//    [dict setObject:@" 世界旅游日" forKey:@"0927"];
//    [dict setObject:@" 孔子诞辰" forKey:@"0928"];
//    [dict setObject:@" 国际翻译日" forKey:@"0930"];
    [dict setObject:@" 国庆节" forKey:@"1001"];
//    [dict setObject:@" 世界动物日" forKey:@"1004"];
//    [dict setObject:@" 国际教师节" forKey:@"1005"];
//    [dict setObject:@" 中国老年节" forKey:@"1006"];
//    [dict setObject:@" 世界邮政日" forKey:@"1009"];
//    [dict setObject:@" 辛亥革命 世界精神卫生日 世界居室卫生日" forKey:@"1010"];
//    [dict setObject:@" 世界保健日 国际教师节 中国少年先锋队诞辰日 世界保健日" forKey:@"1013"];
//    [dict setObject:@" 世界标准日" forKey:@"1014"];
//    [dict setObject:@" 白手杖节" forKey:@"1015"];
//    [dict setObject:@" 世界粮食日" forKey:@"1016"];
    [dict setObject:@"万圣节" forKey:@"1031"];
//    [dict setObject:@" 达摩祖师圣诞" forKey:@"1102"];
//    [dict setObject:@" 柴科夫斯基逝世悼念日" forKey:@"1106"];
//    [dict setObject:@" 十月社会主义革命纪念日" forKey:@"1107"];
//    [dict setObject:@" 中国记者日" forKey:@"1108"];
//    [dict setObject:@" 全国消防安全宣传教育日" forKey:@"1109"];
//    [dict setObject:@" 世界青年节" forKey:@"1110"];
    [dict setObject:@"光棍节" forKey:@"1111"];
//    [dict setObject:@" 孙中山诞辰纪念日" forKey:@"1112"];
//    [dict setObject:@" 世界糖尿病日" forKey:@"1114"];
//    [dict setObject:@" 国际大学生节 世界学生节 世界戒烟日" forKey:@"1117"];
//    [dict setObject:@" 世界儿童日" forKey:@"1120"];
//    [dict setObject:@" 世界问候日 世界电视日" forKey:@"1121"];
//    [dict setObject:@" 国际声援巴勒斯坦人民国际日" forKey:@"1129"];
//    [dict setObject:@" 艾滋病日" forKey:@"1201"];
//    [dict setObject:@" 世界残疾人日" forKey:@"1203"];
//    [dict setObject:@" 全国法制宣传日" forKey:@"1204"];
//    [dict setObject:@" 国际经济和社会发展志愿人员日 世界弱能人士日" forKey:@"1205"];
//    [dict setObject:@" 国际民航日" forKey:@"1207"];
//    [dict setObject:@" 国际儿童电视日" forKey:@"1208"];
//    [dict setObject:@" 一二·九 世界足球日" forKey:@"1209"];
//    [dict setObject:@" 世界人权日" forKey:@"1210"];
//    [dict setObject:@" 世界防止哮喘日" forKey:@"1211"];
//    [dict setObject:@" 西安事变纪念日" forKey:@"1212"];
//    [dict setObject:@" 大屠杀纪念日" forKey:@"1213"];
//    [dict setObject:@" 国际儿童广播电视节" forKey:@"1214"];
//    [dict setObject:@" 世界强化免疫日" forKey:@"1215"];
//    [dict setObject:@" 澳门回归" forKey:@"1220"];
//    [dict setObject:@" 国际篮球日" forKey:@"1221"];
    [dict setObject:@"平安夜" forKey:@"1224"];
    [dict setObject:@"圣诞节" forKey:@"1225"];
//    [dict setObject:@" 毛泽东诞辰纪念日 节礼日" forKey:@"1226"];
//    [dict setObject:@" 国际生物多样性日" forKey:@"1229"];
    [dict setObject:@"哮喘日" forKey:@"0512"];
    [dict setObject:@"助残日" forKey:@"0530"];
//    [dict setObject:@"牛奶日" forKey:@"0532"];
    [dict setObject:@"遗产日" forKey:@"0626"];
//    [dict setObject:@"合作节" forKey:@"0716"];
    [dict setObject:@"清明节" forKey:@"0404"];
    
    [dict setObject:@"住房日" forKey:@"1011"];
//    [dict setObject:@"减灾日" forKey:@"1023"];
    [dict setObject:@"视觉日" forKey:@"1024"];
    [dict setObject:@"感恩节" forKey:@"1144"];
    
    //NSMutableDictionary *dicForWork = [NSMutableDictionary dictionary];
 
    manager.worldHoliday = dict;
    manager.g_changeDay = [[Tool actionForNowSingleDay:nil] intValue];
    manager.g_changeMonth = [[JYToolForCalendar actionForNowMonth:nil] intValue];
    manager.g_changeYear = [[JYToolForCalendar actionForNowYear:nil] intValue];
    
    manager.g_notChangeYear = manager.g_changeYear;
    manager.g_notChangeMonth = manager.g_changeMonth;
    manager.g_notChangeDay = manager.g_changeDay;
    
}


@end

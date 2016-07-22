//
//  UIUtils.m
//  WXWeibo
//
//  Created by Qingwu Zheng on 12-7-22.
//  Copyright (c) 2012年 www.iphonetrain.com 无限互联ios开发培训中心 All rights
//  reserved.
//

#import "UIUtils.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSDate+TimeAgo.h"
#import "RegexKitLite.h"
@implementation UIUtils

+ (NSString *)getDocumentsPath:(NSString *)fileName {

  //两种获取document路径的方式
  // 1.
  // NSString *documents =
  //    [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];

  // 2.
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                       NSUserDomainMask, YES);

  NSString *documents = [paths objectAtIndex:0];
  NSString *path = [documents stringByAppendingPathComponent:fileName];

  return path;
}

// date 格式化为 string
+ (NSString *)stringFromDate:(NSDate *)date formate:(NSString *)formate {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:formate];
  NSString *str = [formatter stringFromDate:date];
  return str;
}

// string 格式化为 date
+ (NSDate *)dateFromString:(NSString *)datestring formate:(NSString *)formate {
  // 1.设置date对象的格式 E MMM d HH:mm:ss Z yyyy
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:formate];

  // 2.设置时区
  NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
  [formatter setLocale:locale];

  // 3.转换生成date
  NSDate *date = [formatter dateFromString:datestring];
  return date;
}

// 原始：Sat Jan 12 11:50:16 +0800 2013 E MMM d HH:mm:ss Z yyyy
// 转换：01-12 11:50
+ (NSString *)fomateString:(NSString *)datestring {
  //原字符串 ---> Data
  NSString *formate = @"E MMM d HH:mm:ss Z yyyy";
  NSDate *createDate = [UIUtils dateFromString:datestring formate:formate];

  // Date ---> 新字符串
  NSString *newFormate = @"MM-dd HH:mm";
  NSString *text = [UIUtils stringFromDate:createDate formate:newFormate];

  return text;
}


+(NSString *)dataTimeAgoWithDataString:(NSString *)dataStr{
  
  //原字符串 ---> Date
  NSString *formate = @"E MMM d HH:mm:ss Z yyyy";
  NSDate *createDate = [UIUtils dateFromString:dataStr formate:formate];
  
  NSString *lastDateStr = [createDate dateTimeAgo];
  
  return lastDateStr;
}

+(NSString *)sourceTextWithString:(NSString *)sourceStr{
  
//  <a href="http://weibo.com" rel="nofollow">新浪微博</a>
  
  if (sourceStr.length==0) {
    return nil;
  }
  
  NSInteger startLoc=[sourceStr rangeOfString:@">"].location;
  
  NSInteger endLoc=[sourceStr rangeOfString:@"<" options:NSBackwardsSearch].location;
  
  NSInteger length=endLoc-(startLoc+1);
  
 NSString *resultStr =  [sourceStr substringWithRange:NSMakeRange(startLoc+1, length)];
  
  return resultStr;
}

+(NSString *)faceStringWithWeiboText:(NSString *)weiboText{
    //查出表情符
    NSString *regStr = @"\\[\\w+\\]";
    //根据正则表达式取出[兔子]  [神马]  [哈哈]
    NSArray *faceStr = [weiboText componentsMatchedByRegex:regStr];
    if (!faceStr.count) {
        return weiboText;
    }
    NSString *stringPath = [[NSBundle mainBundle]pathForResource:@"emoticons" ofType:@"plist"];
    //读取plist
    NSArray *faceArr = [NSArray arrayWithContentsOfFile:stringPath];
    
    NSString *fullStr = nil;
    
    for (NSString *facingStr in faceStr) {
        //谓词
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"chs = %@",facingStr];
        //根据谓词过滤
        NSArray *dicArr = [faceArr filteredArrayUsingPredicate:predicate];
        
        if (!dicArr.count) {
            return weiboText;
        }
        
        NSDictionary *faceDic = [dicArr lastObject];
        NSString *facePNG = [faceDic objectForKey:@"png"];
        
        NSString *lastStr=[NSString stringWithFormat:@"<image url = '%@'>",facePNG];//facePng  --> 001.png
        //    [兔子]  ---> 001.jpg
        
        //    替换字符串
        if (!fullStr) {
            fullStr=[weiboText stringByReplacingOccurrencesOfString:facingStr withString:lastStr];
        }else{
            fullStr=[fullStr stringByReplacingOccurrencesOfString:facingStr withString:lastStr];
        }
        

    }

    return fullStr;


}
@end

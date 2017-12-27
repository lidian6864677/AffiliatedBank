//
//  NSString+Handler.m
//  AffiliatedBank
//
//  Created by Dian on 2017/12/27.
//  Copyright © 2017年 Dian. All rights reserved.
//

#import "NSString+Handler.h"

@implementation NSString (Handler)

+ (NSString *)returnBankName:(NSString*)idCard{
    
    if(idCard==nil || idCard.length<16 || idCard.length>19){
        return @"卡号位数错误";
    }
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"AffiliateBank" ofType:@"plist"];
    NSDictionary* bankDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *bankBin = bankDict.allKeys;
    
    //6位Bin号
    NSString* cardbin_6 = [idCard substringWithRange:NSMakeRange(0, 6)];
    //8位Bin号
    NSString* cardbin_8 = [idCard substringWithRange:NSMakeRange(0, 8)];
    
    if ([bankBin containsObject:cardbin_6]) {
        return [bankDict objectForKey:cardbin_6];
    }else if ([bankBin containsObject:cardbin_8]){
        return [bankDict objectForKey:cardbin_8];
    }else{
        return @"未查找到对应卡种";
    }
}
@end

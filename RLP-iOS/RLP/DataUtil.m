//
//  DataUtil.m
//  RLP-iOS
//
//  Created by S weet on 2018/7/20.
//  Copyright © 2018年 S weet. All rights reserved.
//

#import "DataUtil.h"

@implementation DataUtil

+ (NSData *)longToNSData:(long long)val {
    if (val == 0) {
        Byte byte[0];
        return [NSData dataWithBytes:byte length:0];
    }
    else {
        long long datatemplength = CFSwapInt64BigToHost(val);  //大小端不一样，需要转化
        NSData *temdata = [NSData dataWithBytes: &datatemplength length: sizeof(datatemplength)];
        return [self stripLeadingZeros:temdata];
    }
}
//stripLeadingZeros(用于长整型->NSData的转换)
+ (NSData *)stripLeadingZeros:(NSData *)data {
    if (data == nil || [data isEqual:[NSNull null]]) {
        return nil;
    }
    int firstNonZero = [self firstNonZeroByte:data];
    Byte b[1];
    Byte result[data.length-firstNonZero];
    Byte *byte = (Byte *)[data bytes];
    switch (firstNonZero) {
        case -1:
            b[0] = 0;
            return [NSData dataWithBytes:b length:1];
            break;
        case 0:
            return data;
        default:
            for (int i = 0; i < data.length-firstNonZero; i++) {
                result[i] = byte[i+firstNonZero];
            }
            return [NSData dataWithBytes:result length:data.length-firstNonZero];
            break;
    }
    
}
//firstNonZeroByte(用于长整型->NSData的转换)
+ (int)firstNonZeroByte:(NSData *)data {
    Byte *byte = (Byte *)[data bytes];
    for (int i = 0; i < data.length; ++i) {
        if (byte[i] != 0) {
            return i;
        }
    }
    return -1;
}

+ (NSData *)intToNSData:(int)val {
    if (val == 0) {
        Byte byte[0];
        return [NSData dataWithBytes:byte length:0];
    }
    
    int length = 0;
    
    int tmpVal = val;
    while (tmpVal != 0) {
        tmpVal = ((unsigned)tmpVal) >> 8;
        ++length;
    }
    
    Byte result[length];
    
    int index = length - 1;
    
    while (val != 0) {
        result[index] = val & 0xFF;
        val = ((unsigned)val) >> 8;
        index -= 1;
    }
    return [NSData dataWithBytes:result length:length];
}

+ (NSString *)dataToHexString:(NSData *)data {
    NSString *str = @"";
    Byte *byte = (Byte *)[data bytes];
    for (int i = 0; i < data.length; i++) {
        NSString *s = [NSString stringWithFormat:@"%02lx",(long)byte[i]];
        str = [NSString stringWithFormat:@"%@%@",str,s];
    }
    return str;
}

+ (NSData *)stringToData:(NSString *)hexString {
    return [hexString dataUsingEncoding:NSUTF8StringEncoding];
}


+ (NSData *)hexKeysToData:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] %2 == 0) {
        range = NSMakeRange(0,2);
    } else {
        range = NSMakeRange(0,1);
    }
    
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}

@end

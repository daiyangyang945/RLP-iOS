//
//  DataUtil.h
//  RLP-iOS
//
//  Created by S weet on 2018/7/20.
//  Copyright © 2018年 S weet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataUtil : NSObject

//long to NSData
+ (NSData *)longToNSData:(long long)val;
//int To NSData
+ (NSData *)intToNSData:(int)val;
//NSData To HexString
+ (NSString *)dataToHexString:(NSData *)data;
//String To NSData (Except PublicKey And PrivateKey)
+ (NSData *)stringToData:(NSString *)hexString;
//Only publicKey or PrivateKey To Data
+ (NSData *)hexKeysToData:(NSString *)str;

@end

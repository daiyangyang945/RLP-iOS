//
//  RLPUtil.h
//  RLP-iOS
//
//  Created by S weet on 2018/7/20.
//  Copyright © 2018年 S weet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RLPUtil : NSObject

+ (NSData *)encodeElement:(NSData *)srcData;

+ (NSData *)encodeList:(NSArray<NSData *> *)array;

@end

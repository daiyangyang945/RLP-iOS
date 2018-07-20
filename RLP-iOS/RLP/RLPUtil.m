//
//  RLPUtil.m
//  RLP-iOS
//
//  Created by S weet on 2018/7/20.
//  Copyright © 2018年 S weet. All rights reserved.
//

#import "RLPUtil.h"

static int SIZE_THRESHOLD = 56;
static int OFFSET_SHORT_ITEM = 0x80;
static int OFFSET_LONG_ITEM = 0xb7;
static int OFFSET_SHORT_LIST = 0xc0;
static int OFFSET_LONG_LIST = 0xf7;

@implementation RLPUtil

+ (NSData *)encodeElement:(NSData *)srcData {
    Byte *byte = (Byte *)[srcData bytes];
    if (srcData.length == 0 || [srcData isEqual:[NSNull null]] || srcData == nil || [srcData isEqualToData:[NSData data]]) {
        Byte b[1];
        b[0] = OFFSET_SHORT_ITEM;
        return [NSData dataWithBytes:b length:1];
    }
    else if (srcData.length == 1 && byte[0] == 0) {
        return srcData;
    }
    else if (srcData.length == 1 && (byte[0] & 0xFF) < 0x80) {
        return srcData;
    }
    else if (srcData.length < SIZE_THRESHOLD) {
        Byte length[1];
        length[0] = OFFSET_SHORT_ITEM + srcData.length;
        Byte data[srcData.length + 1];
        for (int i = 1; i < srcData.length + 1; i++) {
            data[i] = byte[i-1];
        }
        data[0] = length[0];
        
        return [NSData dataWithBytes:data length:srcData.length+1];
    }
    else {
        int tmpLength = (int)srcData.length;
        int lengthOfLength = 0;
        while (tmpLength != 0) {
            ++lengthOfLength;
            tmpLength = tmpLength >> 8;
        }
        
        Byte data[1+lengthOfLength+srcData.length];
        data[0] = OFFSET_LONG_ITEM + lengthOfLength;
        
        tmpLength = (int)srcData.length;
        for (int i = lengthOfLength; i > 0; --i) {
            data[i] = (tmpLength & 0xFF);
            tmpLength = tmpLength >> 8;
        }
        for (int i = 1 + lengthOfLength; i < 1 + lengthOfLength + srcData.length; i++) {
            data[i] = byte[i-1-lengthOfLength];
        }
        return [NSData dataWithBytes:data length:1 + lengthOfLength + srcData.length];
    }
}

+ (NSData *)encodeList:(NSArray<NSData *> *)array {
    if (array.count == 0) {
        Byte byte[1];
        byte[0] = 0xc0;
        return [NSData dataWithBytes:byte length:1];
    }
    int totalLength = 0;
    int dataLength = 0;
    for (NSData *data in array) {
        totalLength += data.length;
    }
    int copyPos = 0;
    if (totalLength < SIZE_THRESHOLD) {
        dataLength = 1 + totalLength;
        Byte data[1 + totalLength];
        data[0] = OFFSET_SHORT_LIST+totalLength;
        copyPos = 1;
        
        for (NSData *d in array) {
            Byte *b = (Byte *)[d bytes];
            for (int i = copyPos; i < d.length+copyPos; i++) {
                data[i] = b[i - copyPos];
            }
            copyPos += d.length;
        }
        return [NSData dataWithBytes:data length:dataLength];
    }
    else {
        int tmpLength = totalLength;
        int byteNum = 0;
        while (tmpLength != 0) {
            ++byteNum;
            tmpLength = tmpLength >> 8;
        }
        tmpLength = totalLength;
        Byte lenBytes[byteNum];
        for (int i = 0; i < byteNum; ++i) {
            lenBytes[byteNum-1-i] = (tmpLength >> (8 * i)) & 0xFF;
        }
        dataLength = 1 + byteNum + totalLength;
        Byte data[1 + byteNum + totalLength];
        data[0] = OFFSET_LONG_LIST + byteNum;
        
        for (int i = 1; i < byteNum+1; i++) {
            data[i] = lenBytes[i-1];
        }
        copyPos = byteNum + 1;
        
        for (NSData *d in array) {
            Byte *b = (Byte *)[d bytes];
            for (int i = copyPos; i < d.length+copyPos; i++) {
                data[i] = b[i - copyPos];
            }
            copyPos += d.length;
        }
        return [NSData dataWithBytes:data length:dataLength];
    }
}

@end

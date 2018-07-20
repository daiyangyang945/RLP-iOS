//
//  ViewController.m
//  RLP-iOS
//
//  Created by S weet on 2018/7/20.
//  Copyright © 2018年 S weet. All rights reserved.
//

#import "ViewController.h"
#import "RLP-iOS.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSData *data = [DataUtil longToNSData:123123123];
//    NSData *data = [DataUtil intToNSData:12];
//    NSData *data = [DataUtil stringToData:@"Hello World"];
    
    NSData * element = [RLPUtil encodeElement:data];
    NSData * list = [RLPUtil encodeList:@[element]];
    
    NSLog(@"RLP->element=%@\nRLP->list=%@",[DataUtil dataToHexString:element],[DataUtil dataToHexString:list]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  BinaryPathRequest.h
//  BinaryPath
//
//  Created by ways on 2021/8/19.
//  Copyright © 2021年 Frank. All rights reserved.
//

#import <Foundation/Foundation.h>
//获取版本号
#define AppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey: @"CFBundleShortVersionString"]

@interface BinaryPathRequest : NSObject


+ (void)loadServiceScriptString;
#pragma mark 加载本地的文件
+(void)loadLocalFile;
/***  撤销 */
+ (void)reverseHotFix;

@end

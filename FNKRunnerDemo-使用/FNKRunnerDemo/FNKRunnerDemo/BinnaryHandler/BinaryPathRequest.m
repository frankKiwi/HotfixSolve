//
//  BinaryPathRequest.m
//  BinaryPath
//
//  Created by ways on 2021/8/19.
//  Copyright © 2021年 Frank. All rights reserved.
//

#import "BinaryPathRequest.h"
#import <ORInterpreter.h>


#define hot_version @"excuteJsonPatchFile"


@implementation BinaryPathRequest



+(void)loadLocalFile{
    
    NSString *oldScript = [[NSUserDefaults standardUserDefaults] objectForKey:hot_version];
    //上次储存的js内容不为空，直接加载
    if (oldScript) {
        NSLog(@"执行本地沙盒的热更新脚本");
        NSString *binarypatch = [[NSBundle mainBundle] pathForResource:@"binarypatch" ofType:nil];
        [ORInterpreter excuteBinaryPatchFile:binarypatch];
        return;
    }else{
        /***  原作者放弃对json的维护导致json不可用了,现在推荐使用excuteBinaryPatchFile */
        
        NSString *binarypatch = [[NSBundle mainBundle] pathForResource:@"binarypatch" ofType:nil];
        [ORInterpreter excuteBinaryPatchFile:binarypatch];
        return;
        NSString *jsonpatch = [[NSBundle mainBundle] pathForResource:@"jsonpatch" ofType:nil];
        [ORInterpreter excuteJsonPatchFile:jsonpatch];
    }
}
/**文件存放路径*/
+(NSString*)getFilePath:(NSString*)saveName
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:saveName];
}
+ (void)loadServiceScriptString {
    
    //获取上次储存的version(请求头中获取)和js内容
    NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:hot_version];
    
    //上次储存的js内容不为空，直接加载
    if (version) {
        NSLog(@"执行本地沙盒的热更新脚本");
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *binaryPatchFilePath = [self getFilePath:@"binarypatch"];
            [ORInterpreter excuteBinaryPatchFile:binaryPatchFilePath];
        });
        //return;
    }
    
    //version为空设为0
    if (!version || [version isEqualToString:@""]) {
        version = @"v0";
    }
    //本地服务器调试
    //    NSString *patchURLString = @"http://0.0.0.0:9527/phpDownloadZipFile/10444/binarypatch";
    //线上服务器地址
    NSString *patchURLString = @"https://raw.githubusercontent.com/frankKiwi/openSource/main/binarypatch";
    
    
    
    //构造请求地址，并传参数version
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:patchURLString]];
    [urlRequest setHTTPMethod:@"GET"];
    [urlRequest setTimeoutInterval:20];
    [urlRequest setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *filePath = [self getFilePath:@"binarypatch"] ;
        
        NSString*dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [ORInterpreter excuteBinaryPatchFile:dataStr];
        
        BOOL isSuccess= NO;
        isSuccess=[data writeToFile:filePath atomically:YES];
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        NSDictionary *allHeaderFields = httpResponse.allHeaderFields;
        NSString *newversion = [allHeaderFields objectForKey:@"js_version"];
        [[NSUserDefaults standardUserDefaults] setObject:newversion forKey:version];
        //加密的js脚本
        {//不加密解密
            if (isSuccess) {
                //加载js内容
                NSLog(@"执行热更新脚本");
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *binaryPatchFilePath = [self getFilePath:@"binarypatch"];
                    [ORInterpreter excuteBinaryPatchFile:binaryPatchFilePath];
                });
            }
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }];
    
    [task resume];
}
/***  撤销 */

+ (void)reverseHotFix{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [ORInterpreter recover];
    });
}

@end

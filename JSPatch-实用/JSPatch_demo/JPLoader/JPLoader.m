//
//  JSPatch.m
//  JSPatch
//
//  Created by bang on 15/11/14.
//  Copyright (c) 2015 bang. All rights reserved.
//

#import "JPLoader.h"
#import "JPEngine.h"
#import "JSPathRequest.h"
#import "ZipArchive.h"
#import "RSAEncryptor.h"
#import <CommonCrypto/CommonDigest.h>
#import <Foundation/Foundation.h>

#define kJSPatchVersion(appVersion)   [NSString stringWithFormat:@"JSPatchVersion_%@", appVersion]

void (^JPLogger)(NSString *log);

#pragma mark - Extension

@interface JPLoaderInclude : JPExtension

@end

@implementation JPLoaderInclude


+ (void)main:(JSContext *)context
{
    context[@"include"] = ^(NSString *filePath) {
        if (!filePath.length || [filePath rangeOfString:@".js"].location == NSNotFound) {
            return;
        }
        NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSString *libraryDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
        NSString *scriptPath = [libraryDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"JSPatch/%@/%@", appVersion, filePath]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:scriptPath]) {
            [JPEngine startEngine];
            [JPEngine evaluateScript:scriptPath];
        }
    };
}

@end

@interface JPLoaderTestInclude : JPExtension

@end

@implementation JPLoaderTestInclude

+ (void)main:(JSContext *)context
{
    context[@"include"] = ^(NSString *filePath) {
        NSArray *component = [filePath componentsSeparatedByString:@"."];
        if (component.count > 1) {
            NSString *testPath = [[NSBundle bundleForClass:[self class]] pathForResource:component[0] ofType:component[1]];
            [JPEngine evaluateScript:testPath];
        }
    };
}

@end

#pragma mark - Loader

@implementation JPLoader
+(JPLoader*)shareJs{
    static JPLoader *loader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loader = [[JPLoader alloc] init];
    });
    return loader;
}
- (JPLoader *(^)(BOOL isLoadZip))hotfixIsZipFile{
    return ^(BOOL isLoadZip){
        self.isLoadZip = isLoadZip;
         return  self;
    };
}
- (JPLoader *(^)(BOOL isRsa))hotfixIsRsa{
    return ^(BOOL isRsa){
        self.isRsa = isRsa;
         return  self;
    };
}
- (JPLoader *(^)(BOOL isTest))hotfixIsTest{
    return ^(BOOL isTest){
        self.isTest = isTest;
         return  self;
    };
}
- (JPLoader *(^)(BOOL isJSPtach))hotfixIsJSPtach{
    return ^(BOOL isJSPtach){
        self.isJSPtach = isJSPtach;
         return  self;
    };
}
- (JPLoader *(^)(NSString *testUrl))hotfixTestUrl{
    return ^(NSString *testUrl){
        self.testUrl = testUrl;
         return  self;
    };
}
- (JPLoader *(^)(NSString *serveUrl))hotfixServeUrl{
    return ^(NSString *serveUrl){
        self.serveUrl = serveUrl;
         return  self;
    };
}
- (void)initJSPatchIsJustLocal:(BOOL)isLoadLocal {
    //是否是测试
    if ([JPLoader shareJs].isTest) {
        if ([JPLoader shareJs].isJSPtach) {//是否是走JSPatch平台
             [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Script_string_cache"];
             [[NSUserDefaults standardUserDefaults] synchronize];
            
//               [JSPatch setupCallback:^(JPCallbackType type, NSDictionary *data, NSError *error) {
//                   if (type == JPCallbackTypeJSException) {
//                       NSAssert(NO, data[@"msg"]);
//                   }
//               }];
//               [JSPatch startWithAppKey:Hotfix_Appkey];
//               [JSPatch setupRSAPublicKey:RSA_Public_key];
//               [JSPatch sync];//jspatch 平台的js 文件
               return;
        }
        if ([JPLoader shareJs].testUrl) {//测试服务器操作
             //下载模块化js zip文件
             if (isLoadLocal) {
                  [JSPathRequest loadLocalFile];
             }else{
                 if ([JPLoader shareJs].isLoadZip) {
                     [JSPathRequest loadServiceJSZip];
                 }else{ //下载单个js文件
                     [JSPathRequest loadServiceScriptString];
                 }
             }
        }else{//只是本地测试
            [self runTestScriptInBundle];
        }
    }else{//正式服务器操作
        //下载模块化js zip文件
        if (isLoadLocal) {
             [JSPathRequest loadLocalFile];
        }else{
            if ([JPLoader shareJs].isLoadZip) {
                [JSPathRequest loadServiceJSZip];
            }else{ //下载单个js文件
                [JSPathRequest loadServiceScriptString];
            }
        }
        
    }
}
+ (BOOL)run
{
    if (JPLogger) JPLogger(@"JSPatch: runScript");
    NSString *scriptDirectory = [self fetchScriptDirectory];
    NSString *scriptPath = [scriptDirectory stringByAppendingPathComponent:@"main.js"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:scriptPath]) {
        [JPEngine startEngine];
        [JPEngine addExtensions:@[@"JPLoaderInclude"]];
        if ([JPLoader shareJs].isRsa) {
            NSString *private_key_path = [[NSBundle mainBundle] pathForResource:@"private_key.p12" ofType:nil];
            scriptPath = [RSAEncryptor decryptString:scriptPath privateKeyWithContentsOfFile:private_key_path password:@"zaoyx123456"];
        }
        [JPEngine evaluateScript:scriptPath];
        if (JPLogger) JPLogger([NSString stringWithFormat:@"JSPatch: evaluated script %@", scriptPath]);
        return YES;
    } else {
        return NO;
    }
}

+ (void)updateToVersion:(NSInteger)version callback:(JPUpdateCallback)callback
{
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if (JPLogger) JPLogger([NSString stringWithFormat:@"JSPatch: updateToVersion: %@", @(version)]);
    // create url request
    NSString *downloadKey = [NSString stringWithFormat:@"/%@/v%@.zip", appVersion, @(version)];
    NSURL *downloadURL = [NSURL URLWithString:[rootUrl stringByAppendingString:downloadKey]];
    NSURLRequest *request = [NSURLRequest requestWithURL:downloadURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.0];
    if (JPLogger) JPLogger([NSString stringWithFormat:@"JSPatch: request file %@", downloadURL]);
    // create task
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            if (JPLogger) JPLogger([NSString stringWithFormat:@"JSPatch: request file success, data length:%@", @(data.length)]);
            // script directory
            NSString *scriptDirectory = [self fetchScriptDirectory];
            // temporary files and directories
            NSString *downloadTmpPath = [NSString stringWithFormat:@"%@patch_%@_%@", NSTemporaryDirectory(), appVersion, @(version)];
            NSString *unzipVerifyDirectory = [NSString stringWithFormat:@"%@patch_%@_%@_unzipTest/", NSTemporaryDirectory(), appVersion, @(version)];
            NSString *unzipTmpDirectory = [NSString stringWithFormat:@"%@patch_%@_%@_unzip/", NSTemporaryDirectory(), appVersion, @(version)];
            // save data
            [data writeToFile:downloadTmpPath atomically:YES];
            // is the processing flow failed
            BOOL isFailed = NO;
            
            // 1. unzip encrypted md5 file and script file
            NSString *keyFilePath;
            NSString *scriptZipFilePath;
            ZipArchive *verifyZipArchive = [[ZipArchive alloc] init];
            [verifyZipArchive UnzipOpenFile:downloadTmpPath];
            BOOL verifyUnzipSucc = [verifyZipArchive UnzipFileTo:unzipVerifyDirectory overWrite:YES];
            if (verifyUnzipSucc) {
                for (NSString *filePath in verifyZipArchive.unzippedFiles) {
                    NSString *filename = [filePath lastPathComponent];
                    if ([filename isEqualToString:@"key"]) {
                        // encrypted md5 file
                        keyFilePath = filePath;
                    } else if ([[filename pathExtension] isEqualToString:@"zip"]) {
                        // script file
                        scriptZipFilePath = filePath;
                    }
                }
            } else {
                if (JPLogger) JPLogger(@"JSPatch: fail to unzip file");
                isFailed = YES;
                
                if (callback) {
                    callback([NSError errorWithDomain:@"org.jspatch" code:JPUpdateErrorUnzipFailed userInfo:nil]);
                }
            }
            
            // 2. decrypt and verify md5 file
            if (!isFailed) {
                NSString *private_key_path = [[NSBundle mainBundle] pathForResource:@"private_key.p12" ofType:nil];
              NSString *decryptMD5 = [RSAEncryptor decryptString:keyFilePath privateKeyWithContentsOfFile:private_key_path password:@"zaoyx123456"];
                NSString *md5 = [self fileMD5:scriptZipFilePath];
                if (![decryptMD5 isEqualToString:md5]) {
                    if (JPLogger) JPLogger([NSString stringWithFormat:@"JSPatch: decompress error, md5 didn't match, decrypt:%@ md5:%@", decryptMD5, md5]);
                    isFailed = YES;
                    
                    if (callback) {
                        callback([NSError errorWithDomain:@"org.jspatch" code:JPUpdateErrorVerifyFailed userInfo:nil]);
                    }
                }
            }
            
            // 3. unzip script file and save
            if (!isFailed) {
                ZipArchive *zipArchive = [[ZipArchive alloc] init];
                [zipArchive UnzipOpenFile:scriptZipFilePath];
                BOOL unzipSucc = [zipArchive UnzipFileTo:unzipTmpDirectory overWrite:YES];
                if (unzipSucc) {
                    for (NSString *filePath in zipArchive.unzippedFiles) {
                        NSString *filename = [filePath lastPathComponent];
                        if ([[filename pathExtension] isEqualToString:@"js"]) {
                            [[NSFileManager defaultManager] createDirectoryAtPath:scriptDirectory withIntermediateDirectories:YES attributes:nil error:nil];
                            NSString *newFilePath = [scriptDirectory stringByAppendingPathComponent:filename];
                            [[NSData dataWithContentsOfFile:filePath] writeToFile:newFilePath atomically:YES];
                        }
                    }
                }
                else
                {
                    if (JPLogger) JPLogger(@"JSPatch: fail to unzip script file");
                    isFailed = YES;
                    if (callback) {
                        callback([NSError errorWithDomain:@"org.jspatch" code:JPUpdateErrorUnzipFailed userInfo:nil]);
                    }
                }
            }
            
            // success
            if (!isFailed) {
                if (JPLogger) JPLogger([NSString stringWithFormat:@"JSPatch: updateToVersion: %@ success", @(version)]);
                [[NSUserDefaults standardUserDefaults] setInteger:version forKey:kJSPatchVersion(appVersion)];
                [[NSUserDefaults standardUserDefaults] synchronize];
                if (callback) callback(nil);
            }
            
            // clear temporary files
            [[NSFileManager defaultManager] removeItemAtPath:downloadTmpPath error:nil];
            [[NSFileManager defaultManager] removeItemAtPath:unzipVerifyDirectory error:nil];
            [[NSFileManager defaultManager] removeItemAtPath:unzipTmpDirectory error:nil];
        } else {
            if (JPLogger) JPLogger([NSString stringWithFormat:@"JSPatch: request error %@", error]);
            
            if (callback) callback(error);
        }
    }];
    [task resume];
}

- (void)runTestScriptInBundle
{
    [JPEngine startEngine];
//    [JPEngine addExtensions:@[@"JPLoaderTestInclude"]];
    NSString *jsName = @"";
    if (self.isRsa) {
        jsName = @"mainRSA";
    }else{
        jsName = @"index";
    }
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:jsName ofType:@"js"];
    NSAssert(path, @"can't find index.js");
    NSString *script = [[NSString alloc] initWithData:[[NSFileManager defaultManager] contentsAtPath:path] encoding:NSUTF8StringEncoding];
    if (self.isRsa) {
        NSString *private_key_path = [[NSBundle mainBundle] pathForResource:@"private_key.p12" ofType:nil];
        script = [RSAEncryptor decryptString:script privateKeyWithContentsOfFile:private_key_path password:@"password"];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [JPEngine startEngine];
        [JPEngine evaluateScript:script];
        NSLog(@"执行 == >>> %@",script);
    });
    
}

+ (void)setLogger:(void (^)(NSString *))logger {
    JPLogger = [logger copy];
}

+ (NSInteger)currentVersion
{
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return [[NSUserDefaults standardUserDefaults] integerForKey:kJSPatchVersion(appVersion)];
}

+ (NSString *)fetchScriptDirectory
{
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *libraryDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
    NSString *scriptDirectory = [libraryDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"JSPatch/%@/", appVersion]];
    return scriptDirectory;
}

#pragma mark utils

+ (NSString *)fileMD5:(NSString *)filePath
{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    if(!handle)
    {
        return nil;
    }
    
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    BOOL done = NO;
    while (!done)
    {
        NSData *fileData = [handle readDataOfLength:256];
        CC_MD5_Update(&md5, [fileData bytes], (CC_LONG)[fileData length]);
        if([fileData length] == 0)
            done = YES;
    }
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    
    NSString *result = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                        digest[0], digest[1],
                        digest[2], digest[3],
                        digest[4], digest[5],
                        digest[6], digest[7],
                        digest[8], digest[9],
                        digest[10], digest[11],
                        digest[12], digest[13],
                        digest[14], digest[15]];
    return result;
}

@end

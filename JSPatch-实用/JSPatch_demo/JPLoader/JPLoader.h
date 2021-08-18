//
//  JSPatch.h
//  JSPatch
//
//  Created by bang on 15/11/14.
//  Copyright (c) 2015 bang. All rights reserved.
//

#import <Foundation/Foundation.h>

//设 JPLoader.h 的 rootUrl 为你的服务器地址。
//脚本打包后的文件在服务器的存放路径是 ${rootUrl}/${appVersion}/${patchFile}
const static NSString *rootUrl = @"http://localhost/JSPatch/";
//static NSString *publicKey = @"-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC52Wmj5/V0RiPidvdfyqDXXGnvIXTKsG5OMHUPtcvgGWMUncUlwsm1OI3XgyriwdF3j5Lg5MBSNTitkMS/EtPV9lOu0vne8shpn+slQodHoiu3eACBSUPm+HfK0tl5OnyrAYTZn+mmImREFfE52XUNHnLgYQ3mNW6T5HKzXwtxkQIDAQAB\n-----END PUBLIC KEY-----";
#define RSA_Public_key         @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCxuWhp6EgQfrrSBtxlBwbU35lhjC67X0Y1KrhqolIfYo3/yWV1eryYVUhk5xeHsbKg9RHD9TpIZRUWIW5a8MrMBcgr1A/dgIHi2EM28drH4JRTmkTLVHReggFbb046k0ISpLW3XVW0jHB3/z3S1c/NT9V63SQK6WJ65/YP5xISNQIDAQAB"
//私钥
#define RSA_Privite_key        @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBALG5aGnoSBB+utIG3GUHBtTfmWGMLrtfRjUquGqiUh9ijf/JZXV6vJhVSGTnF4exsqD1EcP1OkhlFRYhblrwyswFyCvUD92AgeLYQzbx2sfglFOaRMtUdF6CAVtvTjqTQhKktbddVbSMcHf/PdLVz81P1XrdJArpYnrn9g/nEhI1AgMBAAECgYBEbsMAvLs69sFS6+djU1BTGYIC6Kp55ZawFDIMhVIf2aAZ1N+nW8pQ0c3dZIpP6qGAjrz3em6lv55d9iN7Cura/g57Rk4S3SRo5u4hWUd16NeIVP+HfreKIgZ6jwKQTfXt2KzDuIAHudvwT2UJBePgIIDQoKMEq4khtFiRGS1UgQJBAN/KpSOiRiGup8h/Iqespwfxyrqn5/4iyw1tpJCWzHddP7nJGpYmOL+ELWs/pReYclAOqH9ZIzOT2K8ZLt6yBOECQQDLTXZowK8wFgMudAE5TStC/zl3TAKMu/Gu5wlXSMoa+nwSy/FSIQZyypGeHR2X8QhbZ1Qz+uBCJm7gEGOWMWPVAkEAp5ajsFm3V0XqE/VRSGu88fAaN0nCK8h2cunm0Ph8ye6k6EY3iLW6zYD4WlZhFZhuEpHHkQZ5nAhdvlKHjPGXQQJAYOtF1rx9B/SGgb/F0ZZrWF4p/ChdUtBKcHIt7tGBoAjn22IkYl3iIBlYAEOrFwNOU5zX9IvWG1MNKn5Fq5VSHQJBAJG5xSY0IKzXWDsGnPIa9XlSTv1zl7RCGNDo7O1zh+5J/kjDpU9M2fIXEtzvGYHiOffz9FBh5ka69JJNFWoWAiw="

static NSString *Hotfix_Appkey = @"73fac3f344c78d41";

typedef void (^JPUpdateCallback)(NSError *error);

typedef enum {
    JPUpdateErrorUnzipFailed = -1001,
    JPUpdateErrorVerifyFailed = -1002,
} JPUpdateError;



@interface JPLoader : NSObject

+(JPLoader*)shareJs;

/*** 是否加载zip文件如果是则需要下载和解压操作*/
/***  20191226 */
/***  是否加载zip文件如果是则需要下载和解压操作 */
@property (nonatomic,assign) BOOL isLoadZip;
- (JPLoader *(^)(BOOL isLoadZip))hotfixIsZipFile;

/*** 是否需要rsa加密解密*/
/***  20191226 */
/***  是否需要rsa加密解密 */
@property (nonatomic,assign) BOOL isRsa;
- (JPLoader *(^)(BOOL isRsa))hotfixIsRsa;

/***  添加测试链接 */
/***  20191226 */
/***  墨子修改 */
@property (nonatomic,copy) NSString* testUrl;
- (JPLoader *(^)(NSString *testUrl))hotfixTestUrl;

/***  是否是测试 */
/***  20200222 */
/***  是否是测试 */
@property (nonatomic,assign) BOOL isTest;
- (JPLoader *(^)(BOOL isTest))hotfixIsTest;

/***  是否走JSpatch官方的平台 */
/***  20200222 */
/***  墨子修改 */
@property (nonatomic,assign) BOOL isJSPtach;
- (JPLoader *(^)(BOOL isJSPtach))hotfixIsJSPtach;
/***  正式链接 */
/***  正式链接 */
/***  墨子修改 */
@property (nonatomic,copy) NSString* serveUrl;
- (JPLoader *(^)(NSString *serveUrl))hotfixServeUrl;
- (void)initJSPatchIsJustLocal:(BOOL)isLoadLocal;
- (void)runTestScriptInBundle;
+ (BOOL)run;
+ (void)updateToVersion:(NSInteger)version callback:(JPUpdateCallback)callback;
+ (void)setLogger:(void(^)(NSString *log))logger;
+ (NSInteger)currentVersion;

+ (NSString *)fetchScriptDirectory;
@end

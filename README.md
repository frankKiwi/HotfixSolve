# FIX
热更新方案

第一个是JSPatch

JSPatch-SourceCode
最原始的JSPatch版本,代码还不是静态库

里面有一些JS的解释.
如果要自己使用JSPatch在企业账号开发的APP或者TF级应用是可以使用的

1.使用的时候要注意可以使用JSPatch官方的注册Key,利用平台分发
2.可以自己服务器下发分发(用1.7版本,只用他的引擎,不在平台初始化)
3.下发的文件可以是单个js文件或者压缩文件.加密自己进行处理.

JSPatch-实用

就是使用的1.7.4版本的,从服务器拉单个JS(一般单个JS就够了,如果长时间不更新那可以考虑一下ZIP)

不同的版本下发不同的JS即可.


第二个是把人家OCRunner改版了一下,他弃用了JSON下发,


```
创建脚本,把PatchGenerator生成二进制的文件放到项目目录或者其他目录都行就是生成一个二进制文件的工具
Scripts.bundle需要拷贝到项目里面.

$SRCROOT/FNKRunnerDemo/PatchGenerator -files $SRCROOT/FNKRunnerDemo/HotPath -refs  $SRCROOT/FNKRunnerDemo/Scripts.bundle -output $SRCROOT/FNKRunnerDemo/binarypatch

先写好需要替换的方法或者添加的方法,在.m中拖到相应的HotPath目录下,command+B执行生成二进制文件.
二进制文件可以本地调试,我是传到git上面下载直接服务端调试.

```

###初始化
```

[BinaryPathRequest loadLocalFile]
本地调试热更

[BinaryPathRequest loadServiceScriptString]
拉取服务端的接口,拉到后直接执行热更.

[BinaryPathRequest reverseHotFix]
撤销执行热更


```

###具体使用

```
原类
#import "SignHandler.h"

@implementation SignHandler

/***  原方法闪退 */

+ (void)testData{
    [[NSMutableArray array] removeObjectAtIndex:100];
}

@end

替换类里面添加新方法和覆盖原方法

#import "SignHandler.h"

@implementation SignHandler

/***  测试添加一个方法 */

+ (void)testFunction{
    NSLog(@"测试添加一个方法");
    [[NSMutableArray array] removeObjectAtIndex:100];
}

/***  测试一个替换类里面的一个方法 */

+ (void)testData{
    
}
@end

测试GCD

#import <Masonry/Masonry.h>
#import <UIKit/UIKit.h>
#import <MJRefresh/MJRefresh.h>



@interface HotFixController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) void (^block)(void);
@end

@implementation HotFixController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self click];
}

/***  测试GCD */

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.block();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SignHandler testFunction];
    });
}
- (void)click{
    [SignHandler testData];
    NSLog(@"测试一个替换类里面的一个方法");
}

- (void)dealloc{
    NSLog(@"HotFixController dealloc");
}
@end

其他的就没试了.

```
```
OCRunner源码可以研究一波
git clone --recursive https://github.com/SilverFruity/OCRunner.git
```
这个是可以热更,App Store也可以过审核,到时候再魔改一份自己用.



第三种还是推荐mangofix
也是可以通过App Store的.

自己公司需要自己开发新的话还是推荐抄一下这三个库.怎么改就看各的发挥了.


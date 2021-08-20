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

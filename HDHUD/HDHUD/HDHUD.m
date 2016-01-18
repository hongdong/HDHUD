//
//  HDHUD.m
//  CuteMommy
//
//  Created by 洪小东 on 15/12/2.
//  Copyright © 2015年 CuteMommy. All rights reserved.
//

#define MyJGHUD ([HDHUD sharedHDHUD].jgHUD)

#import "HDHUD.h"
#import "JGProgressHUD.h"
#import "MacroHeader.h"

@interface HDHUD ()<JGProgressHUDDelegate>
@property (nonatomic, strong) JGProgressHUD *jgHUD;
HDSingletonH(HDHUD)
@end

@implementation HDHUD
HDSingletonM(HDHUD)

+(UIWindow *)HDGetWindow{
    UIWindow *hdWindow;
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows){
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
        
        if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
            hdWindow = window;
            break;
        }
    }
    return hdWindow;
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        if (![UIApplication sharedApplication].keyWindow) {
            DebugLog(@"keyWindow为空");
        }
    }
    return self;
}

-(JGProgressHUD *)jgHUD{
    if (!_jgHUD) {
        _jgHUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
        _jgHUD.animation = [JGProgressHUDFadeZoomAnimation animation];
        _jgHUD.delegate = self;
    }
    return _jgHUD;
}

+ (void)HDShowLoading:(NSString *)text{
    [HDHUD HDShowLoading:text inView:[self HDGetWindow]];
}

+ (void)HDShowLoading:(NSString *)text inView:(UIView *)view {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        MyJGHUD.interactionType = JGProgressHUDInteractionTypeBlockAllTouches;
        MyJGHUD.textLabel.text = text;
        MyJGHUD.square = YES;
        [MyJGHUD showInView:view];
    });

}

+ (void)HDShowSuccess:(NSString *)text{
    [HDHUD HDShowSuccess:text inView:[self HDGetWindow]];
}

+ (void)HDShowSuccess:(NSString *)text inView:(UIView *)view{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        MyJGHUD.textLabel.text = text;
        MyJGHUD.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc] init];
        MyJGHUD.square = YES;
        [MyJGHUD showInView:view];
        [MyJGHUD dismissAfterDelay:1.0];
    });
    
}

+ (void)HDShowError:(NSString *)text{
    [HDHUD HDShowError:text inView:[self HDGetWindow]];
}

+ (void)HDShowError:(NSString *)text inView:(UIView *)view{
    dispatch_async(dispatch_get_main_queue(), ^{
        MyJGHUD.textLabel.text = text;
        MyJGHUD.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
        MyJGHUD.square = YES;
        [MyJGHUD showInView:view];
        [MyJGHUD dismissAfterDelay:1.0];
    });
}

+ (void)HDShowBottomInfo:(NSString *)text{
    [HDHUD HDShowBottomInfo:text inView:[self HDGetWindow]];
}

+ (void)HDShowBottomInfo:(NSString *)text inView:(UIView *)view{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        MyJGHUD.indicatorView = nil;
        MyJGHUD.interactionType = JGProgressHUDInteractionTypeBlockNoTouches;
        MyJGHUD.square = NO;
        MyJGHUD.textLabel.font = HDFontSystemR(15);
        MyJGHUD.marginInsets = UIEdgeInsetsMake(9.0f, 12.0f, 115.0f, 12.0f);
        MyJGHUD.contentInsets = UIEdgeInsetsMake(9.0f, 12.0f, 9.0f, 12.0f);
        MyJGHUD.textLabel.text = text;
        MyJGHUD.position = JGProgressHUDPositionBottomCenter;
        [MyJGHUD showInView:view];
        [MyJGHUD dismissAfterDelay:(MIN((float)text.length*0.06 + 0.5, 5.0))];
    });
}

+ (void)HDHideWithHDHUD{
    if ([HDHUD sharedHDHUD]->_jgHUD) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MyJGHUD dismissAnimated:YES];
        });
    }
}


//delegate
- (void)progressHUD:(JGProgressHUD *)progressHUD didDismissFromView:(UIView *)view{
    if ([HDHUD sharedHDHUD]->_jgHUD) {
        [HDHUD sharedHDHUD]->_jgHUD = nil;
    }
}

@end

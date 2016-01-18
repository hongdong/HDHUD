//
//  HDHUD.h
//  CuteMommy
//
//  Created by 洪小东 on 15/12/2.
//  Copyright © 2015年 CuteMommy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JGProgressHUD;
@interface HDHUD : NSObject

#pragma mark - HUD 添加到 KeyWindow
+ (void)HDShowLoading:(NSString *)text;
+ (void)HDShowSuccess:(NSString *)text;
+ (void)HDShowError:(NSString *)text;
+ (void)HDShowBottomInfo:(NSString *)string;
+ (void)HDHideWithHDHUD;
@end

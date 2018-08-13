//
//  AppDelegate.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 15/10/28.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import "AppDelegate.h"
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import <KeyboardManager.h>
#import <AlipaySDK/AlipaySDK.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WXApi.h"
#import "PRWeiXinPayManager.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "PRTabBarController.h"
#import "UPPaymentControl.h"

#import <MeiQiaSDK/MQManager.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    [IQKeyboardManager sharedManager].enable = YES;
    [self setupNavigationBarStyle];
    
//    NSLog(@"%@",NSHomeDirectory());
    
//    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
//    NSLog(@"%@", identifierForVendor);

    
    //    //临时设置 启动清楚缓存
//    [[SDImageCache sharedImageCache] cleanDisk];
//    [[SDImageCache sharedImageCache] clearDisk];
    
    
    // 美洽
    
    [MQManager initWithAppkey:@"4ea504fe6f4079086c98bf89eb0b9377" completion:^(NSString *clientId, NSError *error) {
    }];
    
    
    //获取各个storyBoard中的一级视图
    UIStoryboard *sb1 = [UIStoryboard storyboardWithName:@"HomePage" bundle:[NSBundle mainBundle]];
    UIViewController * vc1 = [sb1 instantiateViewControllerWithIdentifier: @"HomePageNC"];
    
    UIStoryboard *sb2 = [UIStoryboard storyboardWithName:@"Category" bundle:[NSBundle mainBundle]];
    UIViewController *vc2 = [sb2 instantiateViewControllerWithIdentifier: @"CategoryNC"];

    UIViewController * vc3 =[[UIViewController alloc] init];
    vc3.title = @"客服";
    
    UIStoryboard *sb4 = [UIStoryboard storyboardWithName:@"ShoppingCart" bundle:[NSBundle mainBundle]];
    UIViewController *vc4 = [sb4 instantiateViewControllerWithIdentifier: @"ShoppingCartNC"];
    
    UIStoryboard *sb5 = [UIStoryboard storyboardWithName:@"MemberCenter" bundle:[NSBundle mainBundle]];
    UIViewController * vc5 = [sb5 instantiateViewControllerWithIdentifier: @"MemberCenterNC"];
    
    PRTabBarController *tvc = [[PRTabBarController alloc] init];
    tvc.viewControllers = @[vc1, vc2, vc3, vc4, vc5];
    tvc.tabBar.tintColor = QLTY_MAIN_COLOR;
    self.window.rootViewController = tvc;

    
    UITabBarItem *item1 = [tvc.tabBar.items objectAtIndex:0];
    UITabBarItem *item2 = [tvc.tabBar.items objectAtIndex:1];
    UITabBarItem *item3 = [tvc.tabBar.items objectAtIndex:2];
    UITabBarItem *item4 = [tvc.tabBar.items objectAtIndex:3];
    UITabBarItem *item5 = [tvc.tabBar.items objectAtIndex:4];
    item1.title = @"首页";
    item2.title = @"分类";
    item3.title = @"客服";
    item4.title = @"购物车";
    item5.title = @"我";
    item1.image = [UIImage imageNamed:@"homePageIcon"];
    item2.image = [UIImage imageNamed:@"fenlei-1"];
    item3.image = [UIImage imageNamed:@"call1"];
    item4.image = [UIImage imageNamed:@"cart-1"];
    item5.image = [UIImage imageNamed:@"my-1"];
    item1.selectedImage = [UIImage imageNamed:@"fill_home"];
    item2.selectedImage = [UIImage imageNamed:@"fill_fenlei"];
    item3.selectedImage = [UIImage imageNamed:@"call1"];
    item4.selectedImage = [UIImage imageNamed:@"fill_cart"];
    item5.selectedImage = [UIImage imageNamed:@"fill_my"];
    
    //设置HUD样式
    [self SVProgressHUDInitUI];
    
    [WXApi registerApp:@"wx781ee2aaabbae85e" withDescription:@"酒水批发平台"];
    
    [self registShareSDK];
    
    return YES;
}


/**
 *  设置shareSDK分享功能
 *
 */
- (void)registShareSDK
{
    
    [ShareSDK registerApp:@"12a7009a8cacb"
          activePlatforms:@[@(SSDKPlatformSubTypeWechatSession),
                            @(SSDKPlatformSubTypeWechatTimeline),
                            @(SSDKPlatformSubTypeQQFriend)]
                 onImport:^(SSDKPlatformType platformType) {
        switch (platformType) {
            case SSDKPlatformTypeWechat:[ShareSDKConnector connectWeChat:[WXApi class]];
                break;
                
            case SSDKPlatformTypeQQ:[ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                break;
                
            default:
                break;
        }
    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        switch (platformType) {
            case SSDKPlatformTypeWechat:
                [appInfo SSDKSetupWeChatByAppId:@"wx781ee2aaabbae85e" appSecret:@"9ecae0958712d87905c2a219eac76dd8"];
                break;

            case SSDKPlatformTypeQQ:
                [appInfo SSDKSetupQQByAppId:@"1104781666" appKey:@"pl32je46zyEnyWTz" authType:SSDKAuthTypeBoth];
                break;
                
            default:
                break;
        }
    }];
}

- (void)SVProgressHUDInitUI {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setMinimumDismissTimeInterval:1.0];
}

- (void)setupNavigationBarStyle {
    UIImage *shadowImage = [UIImage imageNamed:@"colorLine1"];
    shadowImage = [self scaleToSize:shadowImage size:CGSizeMake(WIDTH, shadowImage.size.height)];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"whitePoint"] forBarMetrics:UIBarMetricsDefault];
    [UINavigationBar appearance].shadowImage = shadowImage;
    
    // 4s测试 会崩在这里 加上了版本判断
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [UINavigationBar appearance].translucent = NO;
    }
    
    [UINavigationBar appearance].tintColor = [UIColor darkGrayColor];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // 进入后台后关闭美洽
    [MQManager closeMeiqiaService];
    
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // 进入前台后开启美洽
    [MQManager openMeiqiaService];
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    return [WXApi handleOpenURL:url delegate:[PRWeiXinPayManager sharedManager]];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    return [WXApi handleOpenURL:url delegate:[PRWeiXinPayManager sharedManager]];
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    
    //银联支付回调
    if ([PRWeiXinPayManager sharedManager].UnionBlock)
        [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:[PRWeiXinPayManager sharedManager].UnionBlock];
    
    return [WXApi handleOpenURL:url delegate:[PRWeiXinPayManager sharedManager]];
}


@end

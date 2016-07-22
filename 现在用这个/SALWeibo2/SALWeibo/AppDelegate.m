//
//  AppDelegate.m
//  SALWeibo
//
//  Created by mac on 16/5/22.
//  Copyright © 2016年 Seeea. All rights reserved.
//

#import "AppDelegate.h"
#import "MenuViewController.h"
#import "MainTabbarController.h"
#import "LeftViewController.h"
#import "Common.h"
@interface AppDelegate ()
@end

@implementation AppDelegate

-(void)setBlock:(SuccessBlock)block{
    
    _block=block;
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

//    [WeiboSDK enableDebugMode:YES];//打开调试模式
    [WeiboSDK registerApp:kAppKey];//向微博开放平台注册应用
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    
    MainTabbarController *mainVC = [[MainTabbarController alloc]init];
    

    
    LeftViewController *leftVC = [[LeftViewController alloc]init];

    MenuViewController *menuVC = [[MenuViewController alloc]initWithMainVC:mainVC withLeftVC:leftVC];
    
    self.window.rootViewController = menuVC;
    
    
    return YES;

}
//用户授权之后回调本应用， 直接调用方法向微博请求access_token
- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(nonnull id)annotation{
    
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(nonnull NSURL *)url{
    
    
    return [WeiboSDK handleOpenURL:url delegate:self];
    
}

#pragma mark - WeiboSDK Delegate

//接到微博发送的请求
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{
    
    
}
//向微博发送请求之后接收到的响应
-(void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    
//    NSLog(@"response = %@",response);
    
    if ([response isKindOfClass:WBAuthorizeResponse.class]) {
        /*
         //    NSString *title = NSLocalizedString(@"认证结果", nil);
         NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.userId: %@\nresponse.accessToken: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken],  NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
         message:message
         delegate:nil
         cancelButtonTitle:NSLocalizedString(@"确定", nil)
         otherButtonTitles:nil];
         
         self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
         self.wbCurrentUserID = [(WBAuthorizeResponse *)response userID];
         self.wbRefreshToken = [(WBAuthorizeResponse *)response refreshToken];
         [alert show];
         */
        
        NSString *access_token=[(WBAuthorizeResponse *)response accessToken];
        
        _block (access_token);
        
        //    获取access_token然后本地持久化保存
        [[NSUserDefaults standardUserDefaults]setObject:access_token forKey:kAccess_token_ID];
        [[NSUserDefaults standardUserDefaults]synchronize];
        

    }
}






/*
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
*/
@end

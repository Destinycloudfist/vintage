//
//  AppDelegate.m
//  Vintage
//
//  Created by Dustin Dettmer on 3/2/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "ModelViewController.h"
#import "Model.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([[url scheme] isEqualToString:@"nfc"])
    {
        return [self readNFCTag:url];
    }
    return NO;
}

- (BOOL)readNFCTag:(NSURL *)url
{
    NSString *className = [url host];
    if (className == nil)
    {
        return NO;
    }
    NSString *uuid = [url path];
    if ([uuid length] == 0)
    {
        return NO;
    }
    
    Class modelClass = NSClassFromString(className);
    if (modelClass == Nil)
    {
        return NO;
    }
    
    Class viewControllerClass = NSClassFromString([NSString stringWithFormat:@"%@ViewController", className]);
    Model *model = [Model loadModel:modelClass withUniqueId:uuid];
    if (viewControllerClass != Nil)
    {
        ModelViewController *mvc = [[viewControllerClass alloc] initWithModel:model];
        [self.viewController.navigationController pushViewController:mvc animated:YES];
    }
    
    return YES;
}

- (void)writeNFCTag:(NSString *)uuid class:(Class)c
{
    NSURL *tagUrl = [[NSURL alloc] initWithScheme:@"nfc-write" host:NSStringFromClass(c) path:uuid];
    UIApplication *app = [UIApplication sharedApplication];
    if ([app canOpenURL:tagUrl])
    {
        [app openURL:tagUrl];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

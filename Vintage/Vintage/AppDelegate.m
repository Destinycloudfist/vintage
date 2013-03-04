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
#import "ModelBackend.h"

@implementation AppDelegate

+ (instancetype)sharedInstance
{
    return [[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
#ifdef APPORTABLE
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
#else
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewControllerAndroid" bundle:nil];
#endif
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    nav.navigationBar.barStyle = UIBarStyleBlack;
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([[url scheme] isEqualToString:@"vintage"])
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
    NSString *uuid = [[url path] lastPathComponent];
    if ([uuid length] == 0)
    {
        return NO;
    }
    
    Class modelClass = NSClassFromString(className);
    if (modelClass == Nil)
    {
        return NO;
    }

    Model *model = [Model loadModel:modelClass withUniqueId:uuid];
    
    if (self.NCFAction == NULL)
    {    
        Class viewControllerClass = NSClassFromString([NSString stringWithFormat:@"%@StatusViewController", className]);

        if (viewControllerClass != Nil)
        {
            ModelViewController *mvc = [[viewControllerClass alloc] initWithModel:model];
            [self.viewController.navigationController pushViewController:mvc animated:YES];
        }
        return YES;
    }
    else
    {
        return self.NCFAction(model);
    }

}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[ModelBackend shared] synchronize];
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

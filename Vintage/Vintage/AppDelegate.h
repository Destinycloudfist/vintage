//
//  AppDelegate.h
//  Vintage
//
//  Created by Dustin Dettmer on 3/2/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;
@class Model;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@property (strong, nonatomic) BOOL (^NCFAction)(Model *model);

+ (instancetype)sharedInstance;

@end

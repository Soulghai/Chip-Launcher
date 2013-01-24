//
//  AppDelegate.h
//  chip launcher
//
//  Created by Zakhar Gadzhiev on 24.01.13.
//  Copyright Zakhar Gadzhiev 2013. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import <MessageUI/MessageUI.h>

// Added only for iOS 6 support
@interface MyNavigationController : UINavigationController <CCDirectorDelegate>
@end

@interface AppController : NSObject <UIApplicationDelegate, MFMailComposeViewControllerDelegate>
{
	UIWindow *window_;
	MyNavigationController *navController_;
    UIViewController *emailController;
    
	CCDirectorIOS	*director_;							// weak ref
}

@property (nonatomic, retain) UIWindow *window;
@property (readonly) MyNavigationController *navController;
@property (readonly) CCDirectorIOS *director;

-(void)sendEmail;
@end

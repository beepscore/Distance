//
//  DistanceAppDelegate.h
//  Distance
//
//  Created by Steve Baker on 1/30/10.
//  Copyright Beepscore LLC 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DistanceViewController;

@interface DistanceAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    DistanceViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet DistanceViewController *viewController;

@end


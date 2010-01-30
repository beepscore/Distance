//
//  DistanceViewController.h
//  Distance
//
//  Created by Steve Baker on 1/30/10.
//  Copyright Beepscore LLC 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

// Note we only write to the textFields, not edit, respond to keyboard input or read from them.
// So we don't need to conform to or implememnt <UITextFieldDelegate> protocol
// Ref Dudney sec 4.6 pg 65-66
@interface DistanceViewController : UIViewController <CLLocationManagerDelegate> {
    
    CLLocationManager *locationManager;
    NSMutableArray *locations;
    UILabel *lastUpdate;
    UILabel *totalDistance;
    UILabel *averageSpeed;
    
}
#pragma mark -
#pragma mark properties

@property(nonatomic,retain)CLLocationManager *locationManager;
@property(nonatomic,retain)NSMutableArray *locations;
@property(nonatomic,retain)IBOutlet UILabel *lastUpdate;
@property(nonatomic,retain)IBOutlet UILabel *totalDistance;
@property(nonatomic,retain)IBOutlet UILabel *averageSpeed;

- (void)updateDisplay;

@end


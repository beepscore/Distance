//
//  DistanceViewController.m
//  Distance
//
//  Created by Steve Baker on 1/30/10.
//  Copyright Beepscore LLC 2010. All rights reserved.
//

#import "DistanceViewController.h"

@implementation DistanceViewController


#pragma mark -
#pragma mark properties

@synthesize locationManager;
@synthesize locations;
@synthesize lastUpdate;
@synthesize totalDistance;
@synthesize averageSpeed;

#pragma mark -
#pragma mark initializers
/*
 // The designated initializer. Override to perform setup that is required before the view is loaded.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
 // Custom initialization
 }
 return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    self.locationManager.delegate = self;
    // notify us only if distance changes by 10 meters or more
    self.locationManager.distanceFilter = 10.0f;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [self.locationManager startUpdatingLocation];
    // 32 is a guess of a 'good' number
    self.locations = [NSMutableArray arrayWithCapacity:32];
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


#pragma mark destructors and memory cleanUp
// use cleanUp method to avoid repeating code in setView, viewDidUnload, and dealloc
- (void)cleanUp {
    [locationManager release], locationManager = nil;
    [locations release], locations = nil;
    [lastUpdate release], lastUpdate = nil;
    [totalDistance release], totalDistance = nil;    
    [averageSpeed release], averageSpeed = nil;    
}


// Release IBOutlets in setView.  
// Ref http://developer.apple.com/iPhone/library/documentation/Cocoa/Conceptual/MemoryMgmt/Articles/mmNibObjects.html
- (void)setView:(UIView *)aView {
    
    if (!aView) { // view is being set to nil        
        // set outlets to nil, e.g. 
        // self.anOutlet = nil;
        [self cleanUp];
    }    
    // Invoke super's implementation last    
    [super setView:aView];    
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	[self cleanUp];
}



- (void)dealloc {
    [self cleanUp];
    [super dealloc];
}

#pragma mark Location methods
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    // if we have a valid location, and it's within 20 meters then stop
    // updating location, but turn it back on in 60 seconds.
    //    if (newLocation.horizontalAccuracy > 0.0f 
    //        && newLocation.horizontalAccuracy < 20.0f) {
    //        if (self.locations.count > 3) {
    //            [self.locationManager stopUpdatingLocation];
    //            [self.locationManager performSelector:@selector(startUpdatingLocation)
    //                                       withObject:nil
    //                                       afterDelay:60.0f];
    //        }
    //    if (newLocation.horizontalAccuracy > 0.0f 
    //        && newLocation.horizontalAccuracy < 500.0f) {
    //        if (self.locations.count > 0) {
    //            [self.locationManager stopUpdatingLocation];
    //            [self.locationManager performSelector:@selector(startUpdatingLocation)
    //                                       withObject:nil
    //                                       afterDelay:10.0f];
    //        }
    [self.locations addObject:newLocation];
    [self updateDisplay];
    //}
}

- (CLLocationDistance)totalDistanceTraveled {
    CGFloat totalDistanceTraveled = 0.0f;
    CLLocation *oldLocation = nil;
    for (CLLocation *location in self.locations) {
        if (nil == oldLocation) {
            oldLocation = location;
            // continue skips the rest of the for loop
            continue;
        }
        totalDistanceTraveled += fabs([location distanceFromLocation:oldLocation]);
        oldLocation = location;
    }
    return totalDistanceTraveled;
}

- (NSTimeInterval)timeDelta {
    NSDate *first = [(CLLocation *)[self.locations objectAtIndex:0] timestamp];
    NSDate *last = [(CLLocation *)[self.locations lastObject] timestamp];
    return [last timeIntervalSince1970] - [first timeIntervalSince1970];
}


#pragma mark -
- (void)updateDisplay {
    CLLocationDistance distance = [self totalDistanceTraveled];
    totalDistance.text = [NSString stringWithFormat:@"%5.3f", distance];
    
    NSTimeInterval time = [self timeDelta];
    // don't want to divide by zero
    if (0.0f == time) {
        averageSpeed.text = @"0.000";
    } else {
        averageSpeed.text = [NSString stringWithFormat:@"%5.3f", distance/time]; 
    }
    NSDateFormatter *inputFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [inputFormatter setDateFormat:@"HH:mm:ss.SSSS"];
    NSDate *date = [(CLLocation *)[self.locations lastObject] timestamp];
    lastUpdate.text = [inputFormatter stringFromDate:date];   
}

@end

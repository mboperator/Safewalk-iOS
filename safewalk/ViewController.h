//
//  ViewController.h
//  safewalk
//
//  Created by Marcus Bernales on 4/28/14.
//  Copyright (c) 2014 Marcus Bernales. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CMMotionManager *motionManager;
@property (strong, nonatomic) CMAccelerometerData *accel;
@property (strong, nonatomic) NSOperationQueue *opQ;
@property (strong, nonatomic) NSMutableArray *myAnnotations;
@property (strong, nonatomic) NSMutableArray *accelerometerReadout;


@property (weak, nonatomic) IBOutlet UILabel *label_accel;
@property (weak, nonatomic) IBOutlet UILabel *label_lat;
@property (weak, nonatomic) IBOutlet UILabel *label_lat2;
@property (weak, nonatomic) IBOutlet UILabel *label_lng2;

@property (weak, nonatomic) IBOutlet UILabel *label_lng;
@property (weak, nonatomic) IBOutlet UILabel *label_status;
@property (weak, nonatomic) IBOutlet MKMapView *map_view;


@end

//
//  ViewController.m
//  safewalk
//
//  Created by Marcus Bernales on 4/28/14.
//  Copyright (c) 2014 Marcus Bernales. All rights reserved.
//

#import "ViewController.h"
#import "JSON_methods.h"
#import <MapKit/MapKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self becomeFirstResponder];
    if(self.locationManager == NULL) {
        self.locationManager = [[CLLocationManager alloc]init];
        [self.locationManager setDelegate:self];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
        [self.locationManager setDistanceFilter: 15];
        [self.locationManager startUpdatingLocation];
        self.label_status.text = @"On";
        self.label_status.textColor = [UIColor greenColor];
    }
    [self.map_view setDelegate:self];
    self.map_view.showsUserLocation = YES;
	self.motionManager = [[CMMotionManager alloc] init];
    self.opQ = [[NSOperationQueue alloc] init];
    
    if (!self.accelerometerReadout) {
        self.accelerometerReadout = [[NSMutableArray alloc] init];
    }
    
    [self.motionManager setAccelerometerUpdateInterval:1.0];
    
    [self.motionManager startAccelerometerUpdatesToQueue:self.opQ withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            @try {
                self.label_accel.text = [[[NSNumber alloc] initWithDouble:[accelerometerData acceleration].x] stringValue];
                if (abs([accelerometerData acceleration].x) > 1.5 ) {
                    NSNumber *lat = [[NSNumber alloc]initWithDouble:[self.locationManager location].coordinate.latitude];
                    NSNumber *lng = [[NSNumber alloc]initWithDouble:[self.locationManager location].coordinate.latitude];
                    [JSON_methods postCoordsWithLat:[lat stringValue] WithLng:[lng stringValue] WithPhone: @"9515915766"];
                }
            }
            @catch (NSException *exception) {
                self.label_accel.text = @"n/a";
            }
            @finally {
                return;
            }
        });
    }];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Array sorting
//- (NSNumber *)rollingAverage: (NSNumber *)new
//                 withCounter: (int)count {
//    int i;
//    int size = [self.accelerometerReadout count];
//    for (i = 0; i < size; i++) {
//        NSNumber *head = [self.accelerometerReadout objectAtIndex:i];
//        
//    }
//}

#pragma mark- Core Location
- (BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma mark- Location Manager Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    dispatch_async(dispatch_get_main_queue(), ^{
        CLLocation *current_coord = [locations firstObject];
        NSNumber *lat = [[NSNumber alloc]initWithDouble:current_coord.coordinate.latitude];
        NSNumber *lng = [[NSNumber alloc]initWithDouble:current_coord.coordinate.longitude];
        self.label_lat.text = [lat stringValue];
        self.label_lng.text = [lng stringValue];
        
        @try{
            CLLocation *previous = [locations objectAtIndex:1];
            self.label_lat2.text = [NSString stringWithFormat:@"%f", previous.coordinate.latitude];
            self.label_lng2.text = [NSString stringWithFormat:@"%f", previous.coordinate.longitude];
        }
        @catch(NSException *e){
            if (![self.label_lat2 isEqual:@"n/a"]) {
                self.label_lat2.text = @"n/a";
                self.label_lng2.text = @"n/a";
            }
        }
        @finally{
            if ([self.label_status.text  isEqual: @"On"]) {
                if([JSON_methods postCoordsWithLat:[lat stringValue] WithLng:[lng stringValue] WithPhone: @""]){
                    [self plotPoint:CLLocationCoordinate2DMake([lat doubleValue], [lng doubleValue])];
                    [self recenterMap];
                }
                
            }
        }
    });
}

#pragma mark- Map Delegate

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
    if([view.annotation isKindOfClass:[MKUserLocation class]]){
        return;
    }
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    if([annotation isKindOfClass:[MKUserLocation class]]) return nil;
    
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[self.map_view dequeueReusableAnnotationViewWithIdentifier:@"pinView"];
    
    if (pinView == nil){ pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pinView"]; }
    
    pinView.canShowCallout = NO;
    if (annotation == [self.map_view.annotations firstObject]) {
        pinView.image = [UIImage imageNamed:@"pin_orange_smaller.png"];
    } else{
        pinView.image = [UIImage imageNamed:@"pin_orange_smaller.png"];
    }
    return pinView;
}

#pragma mark- Ancillary Methods
- (void)plotPoint: (CLLocationCoordinate2D)coord{
    if (self.myAnnotations == nil) {
        self.myAnnotations = [[NSMutableArray alloc]init];
    }
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    [point setCoordinate: coord];
    
    [self.myAnnotations addObject:point];
    [self.map_view addAnnotations:self.myAnnotations];
}

- (void)recenterMap{
    
    CLLocationCoordinate2D coordinate = self.locationManager.location.coordinate;
    MKPointAnnotation *user = [[MKPointAnnotation alloc] init];
    [user setCoordinate:coordinate];
    [self.map_view addAnnotation: user];
    [self.map_view showAnnotations:self.map_view.annotations animated:YES];
    [self.map_view removeAnnotation:user];
}




@end

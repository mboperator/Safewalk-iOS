//
//  JSON_methods.m
//  safewalk
//
//  Created by Marcus Bernales on 5/15/14.
//  Copyright (c) 2014 Marcus Bernales. All rights reserved.
//

#import "JSON_methods.h"
#import "SBJson.h"

#define API_URL @"http://stko-work.geog.ucsb.edu/gauchosafe/handlers/track.php?"

@implementation JSON_methods

+(BOOL)postCoordsWithLat: (NSString *)lat
                 WithLng: (NSString *)lng
               WithPhone: (NSString *)phone
{
    NSMutableURLRequest *request = [self createRequest];
    NSString *url_string = [API_URL stringByAppendingString:[NSString stringWithFormat:@"lat=%@&lng=%@&id=%@", lat, lng, phone]];
    NSURL *url = [NSURL URLWithString:url_string];
    [request setURL:url];
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if ([response statusCode] >=200 && [response statusCode] <300)
    {
        NSLog(@"Success: %@", url_string);
        return true;
    } else{
        NSLog(@"Failed: %@ Response: %li", url_string, (long)[response statusCode]);
        return false;
    }
}


+ (NSMutableURLRequest *)createRequest{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    return request;
}

@end

//
//  JSON_methods.h
//  safewalk
//
//  Created by Marcus Bernales on 5/15/14.
//  Copyright (c) 2014 Marcus Bernales. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSON_methods : NSObject

+ (BOOL)postCoordsWithLat: (NSString *)lat
                  WithLng: (NSString *)lng;

+ (BOOL)postCoordsWithLat: (NSString *)lat
                  WithLng: (NSString *)lng
                WithPhone: (NSString *)phone;

@end

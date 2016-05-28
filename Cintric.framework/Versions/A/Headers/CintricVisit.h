//
//  CintricVisit.h
//  Cintric
//
//  Created by Shiv Kalola on 10/16/16.
//  Copyright © 2015 Cintric. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface CintricVisit : NSObject

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) NSDate *arrivalDate;
@property (strong, nonatomic) NSDate *departureDate;
@property (nonatomic) double horizontalAccuracy;

@end

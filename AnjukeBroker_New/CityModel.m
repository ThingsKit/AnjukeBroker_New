//
//  CityModal.m
//  AnjukeBroker_New
//
//  Created by jason on 6/26/14.
//  Copyright (c) 2014 Wu sicong. All rights reserved.
//

#import "CityModel.h"

@implementation CityModel


- (id)initWithTitle:(NSString *)title cityArray:(NSArray *)cityArray
{
    
    self = [super init];
    if (self) {
        _title     = title;
        _cityArray = cityArray;
    }
    
    return self;
}

- (void)addCityDataToCityArray:(NSDictionary *)cityData
{
    self.cityArray = [self.cityArray arrayByAddingObject:cityData];
}

@end

//
//  CityModal.h
//  AnjukeBroker_New
//
//  Created by jason on 6/26/14.
//  Copyright (c) 2014 Wu sicong. All rights reserved.
//


@interface CityModel : NSObject

@property(nonatomic) NSString *title;
@property(nonatomic) NSArray  *cityArray;

- (id)initWithTitle:(NSString *)title cityArray:(NSArray *)cityArray;

- (void)addCityDataToCityArray:(NSDictionary *)cityData;

@end

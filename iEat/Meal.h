//
//  Meal.h
//  iEat
//
//  Created by RAJAN on 5/14/16.
//  Copyright © 2016 RAJAN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Meal : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dict;

- (NSString *)mealTitle;

- (NSString *)mealDescription;

- (NSString *)mealPictureUrl;

- (NSDate *)mealDate;

- (NSString *)mealId;

@end

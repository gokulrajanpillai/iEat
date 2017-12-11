//
//  MealOnDay.h
//  iEat
//
//  Created by RAJAN on 5/16/16.
//  Copyright © 2016 RAJAN. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Meal;


@interface MealOnDay : NSObject

- (NSDate *)date;

- (id)initWithDate:(NSDate *)date;

- (void)addMeal:(Meal *)meal;

- (NSUInteger)mealsCount;

- (Meal *)mealForIndex:(NSUInteger)index;

- (NSMutableArray *)meals;

@end

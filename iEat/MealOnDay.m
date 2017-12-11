//
//  MealOnDay.m
//  iEat
//
//  Created by RAJAN on 5/16/16.
//  Copyright © 2016 RAJAN. All rights reserved.
//

#import "MealOnDay.h"
#import "Meal.h"

@interface MealOnDay()

@property (nonatomic, strong) NSDate *date;

@property (nonatomic, strong) NSMutableArray *meals;

@end

@implementation MealOnDay

- (id)initWithDate:(NSDate *)date {
    
    self = [super init];
    
    if (self) {
        
        self.date   = date;
        self.meals  = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)addMeal:(Meal *)meal {
    
    [self.meals addObject:meal];
}


- (NSUInteger)mealsCount {
    
    return [self.meals count];
}

- (Meal *)mealForIndex:(NSUInteger)index {
    
    return [self.meals objectAtIndex:index];
}

- (NSMutableArray *)meals {
    
    return _meals;
}

@end

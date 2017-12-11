//
//  Meal.m
//  iEat
//
//  Created by RAJAN on 5/14/16.
//  Copyright © 2016 RAJAN. All rights reserved.
//

#import "Meal.h"
#import "NSDate+DateCategory.h"

@interface Meal()

@property (nonatomic, strong) NSString *mealId;

@property (nonatomic, strong) NSString *mealPictureUrl;

@property (nonatomic, strong) NSDate *mealDate;

@property (nonatomic, strong) NSString *mealTitle;

@property (nonatomic, strong) NSString *mealDescription;

@end

@implementation Meal

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    
    self = [super init];
    
    if (self) {
        
        self.mealId = dict[@"meal_id"];
        
        self.mealPictureUrl = [dict valueForKey:@"meal_picture"];
        
        self.mealDate = [NSDate dateFromUNIXTimeStamp:[[dict valueForKey:@"meal_day"] stringValue] WithFormat:@"dd/MM/YYYY"];
        
        self.mealTitle = [dict valueForKey:@"meal_title"];
        
        self.mealDescription = [dict valueForKey:@"meal_description"];
    }
    
    return self;
}

- (BOOL)isEqual:(id)anObject
{
    return [self.mealId isEqual:[(Meal *)anObject mealId]];
    // If it's an object. Otherwise use a simple comparison like self.personId == anObject.personId
}

@end

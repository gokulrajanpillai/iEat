//
//  MasterModel.m
//  iEat
//
//  Created by RAJAN on 5/14/16.
//  Copyright © 2016 RAJAN. All rights reserved.
//

#import "MasterModel.h"
#import "iEatServerAPI.h"
#import "Meal.h"
#import "MealOnDay.h"

@interface MasterModel()<iEatServerAPIDelegate>

@property (nonatomic, strong) NSMutableArray *mealsData;

@property (nonatomic, strong) NSMutableArray *favoriteMealsId;

@property (nonatomic, weak) id<MasterModelDelegate> delegate;

@end

@implementation MasterModel


+ (MasterModel *)sharedInstance {
    
    static MasterModel *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MasterModel alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark Data modification methods
- (void)addMealToListUsingDictionary:(NSDictionary *)mealDict {
    
    [[iEatServerAPI sharedInstance] addMealWithDictionary:mealDict];
}

- (void)editMealInListUsingDictionary:(NSDictionary *)mealDict {

    [[iEatServerAPI sharedInstance] editMealWithDictionary:mealDict];
}

- (void)deleteMealFromList:(Meal *)meal {
    
    [[iEatServerAPI sharedInstance] deleteMealWithMealId:[meal mealId]];
}

#pragma mark Datasource Methods

- (void)resetData {
    
    [self.mealsData removeAllObjects];
    
    [self.delegate masterModelUpdated];
}

///Called once the app is launched for initialising the table with the data
- (void)initializeDataWithDelegate:(id<MasterModelDelegate>)delegate {
    
    self.delegate = delegate;
    
    if (![self.mealsData count]) {
        
        [[iEatServerAPI sharedInstance] getMealsWithDelegate:self];
    }
}

- (void)parseResponseWithData:(NSData *)data {
    
    NSMutableArray *meals = [[NSMutableArray alloc] init];
    NSError *error = nil;
    id mealsArray = [NSJSONSerialization
                     JSONObjectWithData:data
                     options:0
                     error:&error];
    if(!error) {
        
        for (NSDictionary *dict in mealsArray) {
            Meal *newMeal = [[Meal alloc] initWithDictionary:dict];
            [meals addObject:newMeal];
        }
        
        
        meals = [[meals sortedArrayUsingComparator: ^(Meal *m1, Meal *m2) {
            return [m1.mealDate compare:m2.mealDate];
        }] mutableCopy];
        
        MealOnDay *mod;
        
        for (Meal *meal in meals) {
            
            if (mod == nil || [mod.date compare:meal.mealDate] != NSOrderedSame) {
                
                mod = [[MealOnDay alloc] initWithDate:meal.mealDate];
                
                [self.mealsData addObject:mod];
            }
            
            [mod addMeal:meal];
        }
        
        [self.delegate masterModelUpdated];
    }
    else {
        
        NSLog(@"The following error has occured while parsing: %@",[error description]);
    }

}

- (NSInteger)mealsDataCount {
    
    return [self.mealsData count];
}

- (MealOnDay *)mealsDataForIndex:(NSInteger)index {
    
    return [self.mealsData objectAtIndex:index];
}

- (NSUInteger)mealCountForMealsDataWithIndex:(NSUInteger)index {
    
    return [[self.mealsData objectAtIndex:index] mealsCount];
}

- (NSMutableArray *)mealsForMealsDataWithIndex:(NSUInteger)index {
    
    return [[self.mealsData objectAtIndex:index] meals];
}

- (NSUInteger)favoriteMealsCountForMealsDataWithIndex:(NSUInteger)index {
    
    NSUInteger count = 0;
    
    for (Meal *meal in [[self mealsDataForIndex:index] meals]) {

        if ([self mealIsFavorite:meal]) {
            count++;
        }
    }
    
    return count;
}

//Returns the list of favorite meal for a particular day
- (NSMutableArray *)favoriteMealsForMealsDataWithIndex:(NSUInteger)index {
    
    NSArray *meals = [[self.mealsData objectAtIndex:index] meals];
    NSMutableArray *favoriteMeals = [[NSMutableArray alloc] init];
    for (Meal *meal in meals) {
        
        if ([self mealIsFavorite:meal]) {
            [favoriteMeals addObject:meal];
        }
    }
    
    return favoriteMeals;
}

///Add or remove meal from favorites
- (void)addOrRemoveMealFromFavoritesWithMealId:(NSString *)mealId {
    
    if (![self.favoriteMealsId containsObject:mealId]) {
        
        [self.favoriteMealsId addObject:mealId];
    }
    else {
        
        [self.favoriteMealsId removeObject:mealId];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:self.favoriteMealsId forKey:@"favoriteMealsId"];
    
    [self.delegate masterModelUpdated];
}

///Check if meal is favorite
- (BOOL)mealIsFavorite:(Meal *)meal {
    
    return [self.favoriteMealsId containsObject:meal.mealId];
}


#pragma mark Getters & Setters

- (NSMutableArray *)mealsData {
    
    if(_mealsData == nil) {
        
        _mealsData = [[NSMutableArray alloc] init];
    }
    
    return _mealsData;
}

- (NSMutableArray *)favoriteMealsId {
    
    if(_favoriteMealsId == nil) {
    
        _favoriteMealsId = [[[NSUserDefaults standardUserDefaults] valueForKey:@"favoriteMealsId"] mutableCopy];
    
        if(_favoriteMealsId == nil || ![_favoriteMealsId isKindOfClass:[NSMutableArray class]]) {
        
            _favoriteMealsId = [[NSMutableArray alloc] init];
        }
    }
    
    return _favoriteMealsId;
}


#pragma mark iEatServerAPIDelegate Method

- (void)responseReceivedForRequestType:(RequestType)requestType WithData:(NSData *)response {

    if (requestType == RequestTypeGetAllMeals) {
    
        [self parseResponseWithData:response];
    }
    else {
        
        [self resetData];
    }
    
}

@end

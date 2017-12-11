//
//  MasterModel.h
//  iEat
//
//  Created by RAJAN on 5/14/16.
//  Copyright © 2016 RAJAN. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Meal;
@class MealOnDay;

@protocol MasterModelDelegate <NSObject>

- (void)masterModelUpdated;

@end

@interface MasterModel : NSObject

+ (MasterModel *)sharedInstance;

///Data modification methods
- (void)addMealToListUsingDictionary:(NSDictionary *)meal;

- (void)editMealInListUsingDictionary:(NSDictionary *)meal;

- (void)deleteMealFromList:(Meal *)meal;

///Datasource methods
- (void)initializeDataWithDelegate:(id<MasterModelDelegate>)delegate;

- (NSInteger)mealsDataCount;

//Returns the MealOnDay object for a given index
- (MealOnDay *)mealsDataForIndex:(NSInteger)index;

//Returns the number of meals for a particular day
- (NSUInteger)mealCountForMealsDataWithIndex:(NSUInteger)index;

//Returns the list of meals for a particular day
- (NSMutableArray *)mealsForMealsDataWithIndex:(NSUInteger)index;

//Returns the number of favorite meals for a particular day
- (NSUInteger)favoriteMealsCountForMealsDataWithIndex:(NSUInteger)index;

//Returns the list of favorite meal for a particular day
- (NSMutableArray *)favoriteMealsForMealsDataWithIndex:(NSUInteger)index;

///Favorites section methods
- (void)addOrRemoveMealFromFavoritesWithMealId:(NSString *)meal;

- (BOOL)mealIsFavorite:(Meal *)meal;

@end

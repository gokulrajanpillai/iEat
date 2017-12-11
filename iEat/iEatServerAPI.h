//
//  iEatServerAPI.h
//  iEat
//
//  Created by RAJAN on 5/14/16.
//  Copyright © 2016 RAJAN. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    RequestTypeGetAllMeals,
    RequestTypeAddMeal,
    RequestTypeEditMeal,
    RequestTypeDeleteMeal,
    RequestTypeGetMealWithId
}RequestType;

@protocol iEatServerAPIDelegate

- (void)responseReceivedForRequestType:(RequestType)requestType WithData:(NSData *)response;

@end

@interface iEatServerAPI : NSObject

- (void)getMealsWithDelegate:(id<iEatServerAPIDelegate>)delegate;

- (void)addMealWithDictionary:(NSDictionary *)dict;

- (void)deleteMealWithMealId:(NSString *)mealId;

- (void)editMealWithDictionary:(NSDictionary *)dict;

+ (iEatServerAPI *)sharedInstance;

@end

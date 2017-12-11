//
//  OptionTableViewCell.h
//  iEat
//
//  Created by RAJAN on 5/15/16.
//  Copyright © 2016 RAJAN. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Meal;

@interface AllMealsTableViewCell : UITableViewCell

- (void)initializeWithValue:(Meal *)meal;

@end

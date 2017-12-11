//
//  OptionTableViewCell.m
//  iEat
//
//  Created by RAJAN on 5/15/16.
//  Copyright © 2016 RAJAN. All rights reserved.
//

#import "AllMealsTableViewCell.h"
#import "Meal.h"
#import "UIImage+LoadURLCategory.h"
#import "MasterModel.h"

@interface AllMealsTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *mealTitle;

@property (weak, nonatomic) IBOutlet UIImageView *mealLogo;

@property (weak, nonatomic) Meal *meal;

@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@end

@implementation AllMealsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)initializeWithValue:(Meal *)meal {
    
    self.meal = meal;
    
    [self.mealTitle setText:meal.mealTitle];
    
    [self.mealLogo setImage:nil];
    
    [self.mealLogo setImage:[UIImage imageNamed:@"placeholder"]];
    
    [UIImage loadImageFromURLString:meal.mealPictureUrl WithCompletion:^(UIImage *img) {
        
        if ([self.meal isEqual:meal] && img != nil) {
            [self.mealLogo setImage:img];
        }
    }];
    
    [self updateFavoriteButtonStatus];
}

- (IBAction)favoriteButtonClicked:(id)sender {
    
    [[MasterModel sharedInstance] addOrRemoveMealFromFavoritesWithMealId:self.meal.mealId];
    
    [self updateFavoriteButtonStatus];
}

- (void)updateFavoriteButtonStatus {
    
    if ([[MasterModel sharedInstance] mealIsFavorite:self.meal]) {
        
        [self.favoriteButton setSelected:YES];
    }
    else {
        
        [self.favoriteButton setSelected:NO];
    }
}

@end

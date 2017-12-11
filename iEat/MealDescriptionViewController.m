//
//  MealDescriptionViewController.m
//  iEat
//
//  Created by RAJAN on 5/17/16.
//  Copyright © 2016 RAJAN. All rights reserved.
//

#import "MealDescriptionViewController.h"
#import "UIImage+LoadURLCategory.h"
#import "Meal.h"
#import "MasterModel.h"
#import "AddMealViewController.h"

@interface MealDescriptionViewController()<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *mealPicture;

@property (weak, nonatomic) IBOutlet UILabel *mealTitle;

@property (weak, nonatomic) IBOutlet UITextView *mealDescription;

@property (weak, nonatomic) Meal *meal;

@end

@implementation MealDescriptionViewController


- (void)initializeData:(Meal *)meal {
    
    self.meal = meal;
}

- (void)viewDidLoad {
    
    [self.mealTitle setText:self.meal.mealTitle];
    
    [self.mealDescription setText:self.meal.mealDescription];
    
    [self.mealPicture setImage:[UIImage imageNamed:@"placeholder"]];
    
    [UIImage loadImageFromURLString:self.meal.mealPictureUrl WithCompletion:^(UIImage *img) {
        
        if (img) {
            [self.mealPicture setImage:img];
        }
    }];
}

- (IBAction)deleteMeal:(id)sender {
    
    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"DELETE" message:@"Are you sure you want to delete this meal from the list?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    
    [alertV show];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"EditMeal"]) {
        
        AddMealViewController *addMealVC = (AddMealViewController *)segue.destinationViewController;
        
        [addMealVC initializeData:self.meal];
    }
}

#pragma mark - UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        [[MasterModel sharedInstance] deleteMealFromList:self.meal];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [alertView dismissWithClickedButtonIndex:-1 animated:YES];
}



@end

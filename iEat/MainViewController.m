//
//  ViewController.m
//  iEat
//
//  Created by RAJAN on 5/14/16.
//  Copyright © 2016 RAJAN. All rights reserved.
//

#import "MainViewController.h"
#import "MasterModel.h"
#import "AllMealsTableViewCell.h"

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self initializeData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)optionDescriptionForIndex:(NSInteger)index {
    
    switch (index) {
            
        case 0: return @"View All Meals";
        case 1: return @"Add a new meal";
        case 2: return @"Favorites";
        default: return @"Invalid";
    }
}


@end

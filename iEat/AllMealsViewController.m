//
//  AllMealsViewController.m
//  iEat
//
//  Created by RAJAN on 5/15/16.
//  Copyright © 2016 RAJAN. All rights reserved.
//

#import "AllMealsViewController.h"
#import "MasterModel.h"
#import "AllMealsTableViewCell.h"
#import "MealOnDay.h"
#import "NSDate+DateCategory.h"
#import "MealDescriptionViewController.h"
#import "Meal.h"

@interface AllMealsViewController ()<UITableViewDelegate, UITableViewDataSource, MasterModelDelegate, UISearchBarDelegate>
{
    MealOnDay *mealDay;
    
    Meal *selectedMeal;
    
    BOOL favSelected;
    
}
@property (weak, nonatomic) IBOutlet UITableView *allMealsTableView;

@property (weak, nonatomic) MasterModel *masterModelInstance;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *favoritesToggleButton;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation AllMealsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self initializeData];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [self.allMealsTableView reloadData];
}

- (void)initialize {
    
    //Set fav as OFF by default
    favSelected = FALSE;
    
    [self.allMealsTableView registerNib:[UINib nibWithNibName:@"AllMealsTableViewCell" bundle:nil] forCellReuseIdentifier:@"AllMealsTableViewCell"];
    [self.allMealsTableView setSeparatorInset:UIEdgeInsetsZero];
    
}

- (void)initializeData {
    
    [self.masterModelInstance initializeDataWithDelegate:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"MealDescription"]) {
        
        MealDescriptionViewController *mealDescription = (MealDescriptionViewController *)segue.destinationViewController;
        
        [mealDescription initializeData:selectedMeal];
    }
}

- (NSArray *)tableDataSourceForSection:(NSUInteger)index {
    
    NSMutableArray *dataSourceArray = [[NSMutableArray alloc] init];
    
    if (favSelected) {
        ///Favorite is selected
        [dataSourceArray addObjectsFromArray: [self.masterModelInstance favoriteMealsForMealsDataWithIndex:index]];
    }
    else {
        ///Favorite is not selected
        [dataSourceArray addObjectsFromArray: [self.masterModelInstance mealsForMealsDataWithIndex:index]];
    }
    
    if ([self.searchBar.text length]) {
        
        for (Meal *meal in [dataSourceArray copy]) {
            
            if(![meal.mealTitle localizedCaseInsensitiveContainsString:self.searchBar.text] && ![meal.mealDescription localizedCaseInsensitiveContainsString:self.searchBar.text]) {
                
                [dataSourceArray removeObject:meal];
            }
        }
    }
    
    return dataSourceArray;
}

- (IBAction)favoritesToggleButtonClicked:(id)sender {
    
    favSelected = !favSelected;
    
    if (favSelected) {
        
        [self.favoritesToggleButton setImage:[UIImage imageNamed:@"star_bar_selected"]];
    }
    else {
        
        [self.favoritesToggleButton setImage:[UIImage imageNamed:@"star_bar_deselected"]];
    }
    
    [self.allMealsTableView reloadData];
}


#pragma mark Getters and Setters

///Reference to the master model instance
- (MasterModel *)masterModelInstance {
    
    if(_masterModelInstance == nil) {
        _masterModelInstance = [MasterModel sharedInstance];
    }
    
    return _masterModelInstance;
}

#pragma mark UITableView Delegate and DataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.masterModelInstance mealsDataCount];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self.masterModelInstance mealsDataForIndex:section].date stringFromDateWithFormat:@"dd/MM/YYYY"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self tableDataSourceForSection:section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AllMealsTableViewCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[AllMealsTableViewCell alloc] init];
    }
    
    [(AllMealsTableViewCell *)cell initializeWithValue:[[self tableDataSourceForSection:indexPath.section] objectAtIndex:indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 20;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 0)];
    
    [headerView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"maroon"]]];
    
    headerView.textAlignment = NSTextAlignmentCenter;
    
    headerView.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    
    headerView.textColor = [UIColor whiteColor];
    
    headerView.text = [[self.masterModelInstance mealsDataForIndex:section].date stringFromDateWithFormat:@"dd/MM/YYYY"];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    selectedMeal = [[self tableDataSourceForSection:indexPath.section] objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier: @"MealDescription" sender: self];
}

#pragma mark - UISearchBarDelegate Method

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    [self.allMealsTableView reloadData];
}


#pragma mark - MasterModelDelegate Method

- (void)masterModelUpdated {
    
    [self initializeData];
    
    [self.allMealsTableView reloadData];
}

@end

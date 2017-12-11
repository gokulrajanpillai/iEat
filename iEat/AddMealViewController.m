#//
//  AddMealViewController.m
//  iEat
//
//  Created by RAJAN on 5/16/16.
//  Copyright © 2016 RAJAN. All rights reserved.
//

#import "AddMealViewController.h"
#import "MasterModel.h"
#import "NSDate+DateCategory.h"
#import "UIImage+LoadURLCategory.h"
#import "Meal.h"

@interface AddMealViewController()<UIImagePickerControllerDelegate>
{
    UIView *datePickerView;
    
    UIDatePicker *datePicker;
    
    UIImagePickerController *imagePicker;
    
    BOOL editMealMode;
}
@property (nonatomic, weak) IBOutlet UIButton *dateButton;

@property (nonatomic, weak) IBOutlet UIButton *imageButton;

@property (nonatomic, weak) IBOutlet UITextField *mealTitle;

@property (nonatomic, weak) IBOutlet UITextView *mealDescription;

@property (nonatomic, strong) UIImage *mealPic;

@property (nonatomic, strong) Meal *meal;

@end

@implementation AddMealViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    
    if (editMealMode) {
        [self.navigationItem setTitle:@"Edit Meal"];
        [self.mealTitle setText:[self.meal mealTitle]];
        [self.mealDescription setText:[self.meal mealDescription]];
        [self.dateButton setTitle:[self.meal.mealDate stringFromDateWithFormat:@"dd/MM/yyyy"] forState:UIControlStateNormal];
        [UIImage loadImageFromURLString:self.meal.mealPictureUrl WithCompletion:^(UIImage *img){
            self.mealPic = img;
        }];
    }
}


- (void)initializeData:(Meal *)meal {
    
    self.meal = meal;
    
    editMealMode = TRUE;
}

- (void)addRightBarButtonWithSelector:(SEL)fn {
    
    UIBarButtonItem *rightBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:fn];
    self.navigationItem.rightBarButtonItem=rightBtn;
}

- (IBAction)submitNewMeal:(id)sender {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:[self.mealTitle text] forKey:@"meal_title"];
    
    [dict setObject:[self.mealDescription text] forKey:@"meal_description"];
    
    NSDate *date = [[NSDate date] dateFromString:[self.dateButton.titleLabel text] WithFormat:@"dd/MM/YYYY"];
    
    [dict setObject:[date UNIXTimeStampString] forKey:@"meal_day"];
    
    [dict setObject:self.mealPic forKey:@"meal_picture"];
    
    if (editMealMode) {
    
        [dict setObject:self.meal.mealId forKey:@"meal_id"];
        [[MasterModel sharedInstance] editMealInListUsingDictionary:dict];
    }
    else {
        
        [[MasterModel sharedInstance] addMealToListUsingDictionary:dict];
    }
    
    [self popBack];
}

///Exit this view once the meal has been added
- (void)popBack {
    
    [self.navigationController popViewControllerAnimated:YES];
    
    if (editMealMode) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - ImagePicker Methods

- (IBAction)takePhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark UIImagePickerControllerDelegate Method

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    self.mealPic = info[UIImagePickerControllerEditedImage];
    
    NSString *imageName = [(NSString *)[info valueForKey:UIImagePickerControllerReferenceURL] lastPathComponent];
    
    [self.imageButton.titleLabel setText:imageName];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - DatePicker Methods

-(IBAction)datePickerBtnAction:(id)sender
{
    datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    datePickerView.backgroundColor = [UIColor colorWithRed:120 green:120 blue:120 alpha:0.7];
    datePicker =[[UIDatePicker alloc]initWithFrame:CGRectMake(64, 64, self.view.frame.size.width - 128, self.view.frame.size.height-128)];
    datePicker.datePickerMode=UIDatePickerModeDate;
    datePicker.hidden=NO;
    datePicker.date=[NSDate date];
    datePicker.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:datePickerView];
    [datePickerView addSubview:datePicker];
    [self addRightBarButtonWithSelector:@selector(save:)];
}

-(void)setDateButtonTitle
{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    dateFormat.dateStyle=NSDateFormatterMediumStyle;
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSString *str=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:datePicker.date]];
    //assign text to label
    [self.dateButton.titleLabel setText:str];
}

-(void)save:(id)sender
{
    self.navigationItem.rightBarButtonItem=nil;
    [self setDateButtonTitle];
    [datePickerView removeFromSuperview];
}

#pragma mark Keyboard Notification

- (void)keyboardDidShow:(id)sender {
    
    [self addRightBarButtonWithSelector:@selector(dismiss:)];
}

- (void)dismiss:(id)sender {
    
    self.navigationItem.rightBarButtonItem = nil;
    [self.view endEditing:YES];
    
}

@end

//
//  MMRSettingsViewController.m
//  Morpheus
//
//  Created by Comyar Zaheri on 11/16/13.
//  Copyright (c) 2013 Comyar Zaheri. All rights reserved.
//

#import "MMRSettingsViewController.h"

@interface MMRSettingsViewController ()
@property (strong, nonatomic) UILabel       *phoneNumberLabel;
@property (strong, nonatomic) UITextField   *phoneTextField;
@end

@implementation MMRSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self initializePhoneTextField];
        if(![[NSUserDefaults standardUserDefaults]valueForKey:USERDEFAULTKEY_PHONENUMBER]) {
            [[NSUserDefaults standardUserDefaults]setValue:@"2819757962" forKey:USERDEFAULTKEY_PHONENUMBER];
        }
    }
    return self;
}

- (void)initializePhoneTextField
{
    const CGFloat labelFontSize = 16.0;
    const CGFloat textFieldFontSize = 18.0;
    self.phoneNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, self.view.bounds.size.width - 20, 44)];
    self.phoneNumberLabel.center = CGPointMake(self.view.center.x, 0.35 * self.view.center.y);
    self.phoneNumberLabel.text = @"Phone Number:";
    self.phoneNumberLabel.textColor = [UIColor darkGrayColor];
    self.phoneNumberLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:labelFontSize];
    [self.view addSubview:self.phoneNumberLabel];
    
    self.phoneTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, 0, self.view.bounds.size.width - 20, 44)];
    self.phoneTextField.center = CGPointMake(self.view.center.x, 0.5 * self.view.center.y);
    self.phoneTextField.placeholder = @"Enter Dwolla Registered Phone #";
    self.phoneTextField.textColor = [UIColor blackColor];
    self.phoneTextField.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:textFieldFontSize];
    self.phoneTextField.delegate = self;
    [self.view addSubview:self.phoneTextField];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.phoneTextField resignFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text length] == 10) {
        [[NSUserDefaults standardUserDefaults]setValue:textField.text forKey:USERDEFAULTKEY_PHONENUMBER];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}

@end

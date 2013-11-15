//
//  MMRMainViewController.m
//  Morpheus
//
//  Created by Comyar Zaheri on 11/15/13.
//  Copyright (c) 2013 Comyar Zaheri. All rights reserved.
//

#import "MMRMainViewController.h"

@implementation MMRMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self initializeDatePicker];
        [self initializeAlarmButton];
    }
    return self;
}

- (void)initializeDatePicker
{
    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0.5 * self.view.bounds.size.height)];
    self.datePicker.center = self.view.center;
    self.datePicker.datePickerMode = UIDatePickerModeTime;
    [self.view addSubview:self.datePicker];
}

- (void)initializeAlarmButton
{
    const CGFloat fontSize = 64.0;
    self.alarmButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.alarmButton setFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1.25 * fontSize)];
    [self.alarmButton setCenter:CGPointMake(self.view.center.x, 0.90 * self.view.bounds.size.height)];
    [self.alarmButton setTitle:@"Set Alarm" forState:UIControlStateNormal];
    [self.alarmButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.alarmButton addTarget:self action:@selector(tappedButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.alarmButton];
    
}

- (void)tappedButton:(UIButton *)button
{
    NSLog(@"Hello!");
}

@end

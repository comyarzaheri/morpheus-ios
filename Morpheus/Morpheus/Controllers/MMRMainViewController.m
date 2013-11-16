//
//  MMRMainViewController.m
//  Morpheus
//
//  Created by Comyar Zaheri on 11/15/13.
//  Copyright (c) 2013 Comyar Zaheri. All rights reserved.
//

#import "MMRMainViewController.h"
#import "MMRConstants.h"

@interface MMRMainViewController ()
@property (strong, nonatomic) UIWebView     *webView;
@property (strong, nonatomic) UIDatePicker  *datePicker;
@property (strong, nonatomic) UIButton      *alarmButton;
@property (strong, nonatomic) NSTimer       *heartbeat;
@end

@implementation MMRMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(alarmFired) name:NOTIFICATION_ALARM object:nil];
        [self initializeDatePicker];
        [self initializeAlarmButton];
        [self initializeWebView];
        self.heartbeat = [[NSTimer alloc]initWithFireDate:[NSDate date]
                                                 interval:HEARTBEAT_INTERVAL
                                                   target:self
                                                 selector:@selector(heartbeat:)
                                                 userInfo:nil
                                                  repeats:YES];
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

- (void)initializeWebView
{
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 0.1, 0.1)];
    [self.view addSubview:self.webView];
}

- (void)tappedButton:(UIButton *)button
{
    if([button isEqual:self.alarmButton]) {
        
        /// Create alarm notification
        UILocalNotification *alarmNotification = [[UILocalNotification alloc]init];
        
        /// Get the chosen date from the date picker
        NSDate *alarmDate = self.datePicker.date;
        
        /// If the time of day chosen has already passed, set an alarm for the next day
        if([alarmDate timeIntervalSinceNow] < 0) {
            alarmDate = [alarmDate dateByAddingTimeInterval:SECONDS_PER_DAY];
        }
        
        /// Configure alarm and schedule notification
        [alarmNotification setFireDate:alarmDate];
        [alarmNotification setTimeZone:[NSTimeZone systemTimeZone]];
        [alarmNotification setAlertBody:NSLocalizedString(@"Alarm Body", nil)];
        [alarmNotification setAlertAction: NSLocalizedString(NOTIFICATION_ALARM, nil)];
        [alarmNotification setSoundName:UILocalNotificationDefaultSoundName];
        [[UIApplication sharedApplication]scheduleLocalNotification:alarmNotification];
        
        /// Notify master of free slave with heartbeat
        [[NSRunLoop currentRunLoop]addTimer:self.heartbeat forMode:NSRunLoopCommonModes];
    }
}

- (void)heartbeat:(NSTimer *)timer
{
    NSLog(@"Heartbeat");
}

- (void)alarmFired
{
    NSLog(@"Alarm Fired");
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end

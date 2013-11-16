//
//  MMRMainViewController.m
//  Morpheus
//
//  Created by Comyar Zaheri on 11/15/13.
//  Copyright (c) 2013 Comyar Zaheri. All rights reserved.
//

#import "MMRAlarmViewController.h"
#import "MMRConstants.h"

#pragma mark - MMRAlarmViewController Class Extension

@interface MMRAlarmViewController ()
{
    NSString    *_jobID;
}

@property (strong, nonatomic) UIWebView     *webView;
@property (strong, nonatomic) NSTimer       *heartbeat;
@property (strong, nonatomic) UIDatePicker  *datePicker;
@property (strong, nonatomic) UIButton      *alarmButton;
@property (strong, nonatomic) UIView        *topHalfView;
@property (strong, nonatomic) UIView        *bottomHalfView;
@property (strong, nonatomic) UILabel       *moneyEarnedLabel;
@property (assign, nonatomic, getter = isWorking) BOOL isWorking;

@end

#pragma mark - MMRAlarmViewController Implementation

@implementation MMRAlarmViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(alarmFired) name:NOTIFICATION_ALARM object:nil];
        [self initializeBackgroundViews];
        [self initializeDatePicker];
        [self initializeAlarmButton];
        [self initializeWebView];
        [self initializeMoneyEarnedLabel];
    }
    return self;
}

#pragma mark UIViewController Methods

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark Initialize Subviews

- (void)initializeMoneyEarnedLabel
{
    const CGFloat fontSize = 64.0;
    self.moneyEarnedLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0.4 * self.view.bounds.size.height)];
    [self.moneyEarnedLabel setTextAlignment:NSTextAlignmentCenter];
    [self.moneyEarnedLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:fontSize]];
    [self.moneyEarnedLabel setText:[NSString stringWithFormat:@"$%2.2f", 0.0]];
    [self.moneyEarnedLabel setTextColor:[UIColor whiteColor]];
    [self.view addSubview:self.moneyEarnedLabel];
}

- (void)initializeBackgroundViews
{
    self.topHalfView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,
                                                               self.view.bounds.size.width, 0.5 * self.view.bounds.size.height)];
    [self.topHalfView setBackgroundColor:[UIColor colorWithRed:RGB_255(50) green:RGB_255(70) blue:RGB_255(91) alpha:1.0]];
    [self.view addSubview:self.topHalfView];
    
    self.bottomHalfView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.center.y,
                                                                  self.view.bounds.size.width, 0.5 * self.view.bounds.size.height)];
    [self.bottomHalfView setBackgroundColor:[UIColor colorWithRed:RGB_255(240) green:RGB_255(240) blue:RGB_255(240) alpha:1.0]];
    [self.view addSubview:self.bottomHalfView];
}

- (void)initializeDatePicker
{
    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0.0,
                                                                    0.95 * self.view.center.y,
                                                                    self.view.bounds.size.width,
                                                                    0.4 * self.view.bounds.size.height)];
    self.datePicker.datePickerMode = UIDatePickerModeTime;
    [self.datePicker setTintColor:[UIColor whiteColor]];
    [self.view addSubview:self.datePicker];
}

- (void)initializeAlarmButton
{
    const CGFloat fontSize = 64.0;
    self.alarmButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.alarmButton setFrame:CGRectMake(0, 0, 0.5 * self.view.bounds.size.width, fontSize)];
    [self.alarmButton setCenter:CGPointMake(self.view.center.x, 0.80 * self.view.center.y)];
    
    [self.alarmButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.alarmButton.layer setCornerRadius:15.0];
    [self.alarmButton.layer setMasksToBounds:YES];
    [self.alarmButton.layer setBorderWidth:1.0];
    
    [self.alarmButton setShowsTouchWhenHighlighted:YES];
    
    [self.alarmButton setTitle:@"Set Alarm" forState:UIControlStateNormal];
    [self.alarmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.alarmButton addTarget:self action:@selector(tappedButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.alarmButton];
}

- (void)initializeWebView
{
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 0.1, 0.1)];
    [self.webView setOpaque:NO];
    [self.webView setAlpha:0.0];
    [self.webView setDelegate:self];
    [self.view addSubview:self.webView];
}

#pragma mark Button Methods

- (void)tappedButton:(UIButton *)button
{
    if([button isEqual:self.alarmButton]) {
        
        if(self.isWorking) {
            /// Stop working
            NSLog(@"Stop Working");
            [self.webView stopLoading];
            [self.alarmButton.titleLabel setText:@"Set Alarm"];
            self.isWorking = NO;
        } else {
            /// Get the chosen date from the date picker
            NSDate *alarmDate = self.datePicker.date;
            
            /// If the time of day chosen has already passed, set an alarm for the next day
            if([alarmDate timeIntervalSinceNow] < 0) {
                alarmDate = [alarmDate dateByAddingTimeInterval:SECONDS_PER_DAY];
            }
            
            [self scheduleAlarmNotificationWithAlarmDate:alarmDate];
            [self requestWorkFromMaster];
            
            [self.alarmButton.titleLabel setText:@"Stop Alarm"];
            self.isWorking = YES;
        }
    }
}

#pragma mark Alarm Scheduling Methods
- (void)scheduleAlarmNotificationWithAlarmDate:(NSDate *)date
{
    /// Create alarm notification
    UILocalNotification *alarmNotification = [[UILocalNotification alloc]init];
    
    /// Configure alarm and schedule notification
    [alarmNotification setFireDate:date];
    [alarmNotification setTimeZone:[NSTimeZone systemTimeZone]];
    [alarmNotification setAlertBody:NSLocalizedString(@"Alarm Body", nil)];
    [alarmNotification setAlertAction: NSLocalizedString(NOTIFICATION_ALARM, nil)];
    [alarmNotification setSoundName:UILocalNotificationDefaultSoundName];
    [[UIApplication sharedApplication]scheduleLocalNotification:alarmNotification];
}

#pragma mark Work Request Methods

- (void)requestWorkFromMaster
{
    /// DEBUG_ONLY
    /// Use Debug work in webview
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:DEBUG_WORK]]];
}

#pragma mark Alarm Handler Methods

- (void)alarmFired
{
    NSLog(@"Alarm Fired");
    [self.heartbeat invalidate];
    self.heartbeat = nil;
    NSLog(@"%@", self.heartbeat);
}

#pragma mark Dealloc

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark UIWebViewDelegate Methods

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    DEBUGLOG(@"Finished loading view");
    DEBUGLOG(@"Downloading Work...");
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:DEBUG_DATA]];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:
     ^ (NSURLResponse * reponse, NSData *data, NSError *connectionError) {
         NSError *error;
         NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
         if (!error) {
             self->_jobID = [jsonData objectForKey:@"jobID"];
             NSString *data = [jsonData objectForKey:@"data"];
             NSString *argv = [[data componentsSeparatedByString:@" "] componentsJoinedByString:@","];
             NSString *func = [NSString stringWithFormat:@"main([%@])", argv];
             DEBUGLOG(@"Executing Work...");
             DEBUGLOG(@"%@", func);
             @try {
                 NSString *result = [webView stringByEvaluatingJavaScriptFromString:func];
                 DEBUGLOG(@"DONE");
                 DEBUGLOG(@"Work Result: %@", result);
             }
             @catch (NSException *exception) {
                 DEBUGLOG(@"ERROR executing job");
             }
         } else {
             DEBUGLOG(@"ERROR executing job");
         }
    }];
   
}



@end

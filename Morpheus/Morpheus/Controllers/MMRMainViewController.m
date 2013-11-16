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
{
    NSString *_jobID;
}
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
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    self.webView.delegate = self;
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
        self.heartbeat = [[NSTimer alloc]initWithFireDate:[NSDate date]
                                                 interval:HEARTBEAT_INTERVAL
                                                   target:self
                                                 selector:@selector(heartbeat:)
                                                 userInfo:nil
                                                  repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:self.heartbeat forMode:NSRunLoopCommonModes];
        
        /// DEBUG_ONLY
        /// Use Debug work in webview
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:DEBUG_WORK]]];
    }
}

- (void)heartbeat:(NSTimer *)timer
{
    NSLog(@"Heartbeat");
}

- (void)alarmFired
{
    NSLog(@"Alarm Fired");
    [self.heartbeat invalidate];
    self.heartbeat = nil;
    NSLog(@"%@", self.heartbeat);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark UIWebView

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"Finished loading view");
    NSLog(@"Downloading Work...");
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
             NSLog(@"Executing Work...");
             NSLog(@"%@", func);
             NSString *result = [webView stringByEvaluatingJavaScriptFromString:func];
             NSLog(@"DONE");
             NSLog(@"Work Result: %@", result);
         } else {
             NSLog(@"ERROR executing job");
         }
    }];
   
}

@end

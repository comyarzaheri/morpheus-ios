//
//  MMRMainViewController.m
//  Morpheus
//
//  Created by Comyar Zaheri on 11/15/13.
//  Copyright (c) 2013 Comyar Zaheri. All rights reserved.
//

#import "MMRAlarmViewController.h"
#import "MMRWorkModule.h"

#pragma mark - MMRAlarmViewController Class Extension

@interface MMRAlarmViewController ()
{
    CGFloat _moneyEarnedThisSession;
}

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) UIWebView     *webView;
@property (strong, nonatomic) UIDatePicker  *datePicker;
@property (strong, nonatomic) UIButton      *alarmButton;
@property (strong, nonatomic) UIView        *topHalfView;
@property (strong, nonatomic) UIView        *topHalfSlider;
@property (strong, nonatomic) UIView        *bottomHalfView;
@property (strong, nonatomic) UILabel       *moneyEarnedLabel;
@property (strong, nonatomic) MMRWorkModule *currentWorkModule;
@property (assign, nonatomic, getter = isAlarmSet) BOOL isAlarmSet;
@property (assign, nonatomic) BOOL          alarmFired;

@end

#pragma mark - MMRAlarmViewController Implementation

@implementation MMRAlarmViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(alarmFire) name:NOTIFICATION_ALARM object:nil];
        [self initializeBackgroundViews];
        [self initializeDatePicker];
        [self initializeSliderView];
        [self initializeAlarmButton];
        [self initializeWebView];
        [self initializeMoneyEarnedLabel];
        [self initializeAudioPlayer];

    }
    return self;
}

- (void)initializeAudioPlayer
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"alarm" ofType:@"mp3"];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:path];
    self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:fileURL error:nil];
    self.audioPlayer.numberOfLoops = -1;
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
    [self.topHalfView setBackgroundColor:[UIColor colorWithRed:RGB_255(71) green:RGB_255(163) blue:RGB_255(218) alpha:1.0]];
    [self.view addSubview:self.topHalfView];
    
    self.bottomHalfView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.center.y,
                                                                  self.view.bounds.size.width, 0.5 * self.view.bounds.size.height)];
    [self.bottomHalfView setBackgroundColor:[UIColor colorWithRed:RGB_255(245) green:RGB_255(245) blue:RGB_255(245) alpha:1.0]];
    [self.view addSubview:self.bottomHalfView];
}

- (void)initializeSliderView
{
    self.topHalfSlider = [[UIView alloc]initWithFrame:CGRectMake(0, 0,
                                                                 self.view.bounds.size.width, 0.5 * self.view.bounds.size.height)];
    [self.topHalfSlider setBackgroundColor:[UIColor colorWithRed:RGB_255(71) green:RGB_255(163) blue:RGB_255(218) alpha:1.0]];
    [self.view addSubview:self.topHalfSlider];

}

- (void)initializeDatePicker
{
    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0.4 * self.view.bounds.size.height)];
    self.datePicker.center = CGPointMake(self.view.center.x, 0.5 * (self.bottomHalfView.bounds.size.height - 49) + self.view.center.y);
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
        
        if(self.isAlarmSet || self.alarmFired) {
            [self.audioPlayer stop];
            [self setAlarmFired:NO];
            [self showDatePicker:YES];
            [self centerElements:NO];
            [self resetAlarm];
        } else {
            /// Get the chosen date from the date picker
            NSDate *alarmDate = self.datePicker.date;
            
            /// If the time of day chosen has already passed, set an alarm for the next day
            if([alarmDate timeIntervalSinceNow] < 0) {
                alarmDate = [alarmDate dateByAddingTimeInterval:SECONDS_PER_DAY];
            }
            
            [self setIsAlarmSet:YES];
            
            [self scheduleAlarmNotificationWithAlarmDate:alarmDate];
            [self requestWorkFromMaster];
            [self.alarmButton setTitle:@"Stop Alarm" forState:UIControlStateNormal];
            [self showDatePicker:NO];
            [self centerElements:YES];
        }
    }
}

- (void)centerElements:(BOOL)center
{
    if(center) {
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations: ^ {
            self.moneyEarnedLabel.frame = CGRectMake(0, 0.4 * self.view.center.y, self.view.bounds.size.width, 0.4 * self.view.bounds.size.height);
            self.alarmButton.center = CGPointMake(self.view.center.x, 1.2 * self.view.center.y);
        } completion:nil];

    } else {
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations: ^ {
            self.moneyEarnedLabel.frame = CGRectMake(0, 0, self.view.bounds.size.width, 0.4 * self.view.bounds.size.height);
            self.alarmButton.center = CGPointMake(self.view.center.x, 0.80 * self.view.center.y);
        } completion:nil];

    }
}

- (void)showDatePicker:(BOOL)show
{
    if(show) {
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations: ^ {
            self.topHalfSlider.center = self.topHalfView.center;
        } completion:nil];
    } else {
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations: ^ {
            self.topHalfSlider.center = self.bottomHalfView.center;
        } completion:nil];
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
    if(!self.isAlarmSet) {
        return;
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:AVAILABLE_NOTIFY]];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler: ^
     (NSURLResponse *response, NSData *data, NSError *connectionError) {
         if (data) {
             NSError *error;
             NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
             if (json) {
                 NSString *func = [json objectForKey:@"func"];
                 NSString *data = [json objectForKey:@"data"];
                 NSString *jobID = [json objectForKey:@"jobID"];
                 NSString *subJobID = [json objectForKey:@"subJobID"];
                 self.currentWorkModule = [[MMRWorkModule alloc]initWithFunc:func data:data jobID:jobID subjobID:subJobID];
                 [self executeWorkModule:self.currentWorkModule];
             } else {
                 [self performSelector:@selector(requestWorkFromMaster) withObject:nil afterDelay:5.0];
             }
         }
    }];
}

- (void)executeWorkModule:(MMRWorkModule *)workModule
{
    if (!workModule.func || !workModule.data || !workModule.jobID || !workModule.subJobID) {
        [self performSelector:@selector(requestWorkFromMaster) withObject:nil afterDelay:5.0];
    }
    DEBUGLOG(@"Executing Work");
    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    [self.webView loadHTMLString:workModule.func baseURL:baseURL];
}

#pragma mark Alarm Handler Methods

- (void)alarmFire
{
    NSLog(@"Alarm Fired");
    [self.audioPlayer play];
    [self setAlarmFired:YES];
}

- (void)resetAlarm
{
    [self setIsAlarmSet:NO];
    [self.webView stopLoading];
    [self.alarmButton setTitle:@"Set Alarm" forState:UIControlStateNormal];
    [[UIApplication sharedApplication]cancelAllLocalNotifications];

}

#pragma mark Dealloc

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark UIWebViewDelegate Methods

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *data = self.currentWorkModule.data;
    NSString *argv = [[data componentsSeparatedByString:@" "] componentsJoinedByString:@","];
    NSString *func = [NSString stringWithFormat:@"main([%@])", argv];
    DEBUGLOG(@"%@", func);
    dispatch_async(dispatch_get_main_queue(), ^ {
        [webView performSelector:@selector(stringByEvaluatingJavaScriptFromString:) withObject:func];
    });
   
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSString* urlString = [[request URL] absoluteString];
    if ([urlString hasPrefix:@"result:"]) {
        NSString *path = [[request URL] path];
        NSArray *pathComponents = [path pathComponents];
        NSString *result = [pathComponents objectAtIndex:1];
        DEBUGLOG(@"Work Result:%@", result);
        [self sendResultToMaster:result];
        [self performSelector:@selector(requestWorkFromMaster) withObject:nil afterDelay:5.0];
        return NO;
    } else {
        return YES;
    }
}

- (void)sendResultToMaster:(NSString *)result
{
    NSString *url = [NSString stringWithFormat:@"%@?jobID=%@&subJobID=%@&phone_number=%@&result=%@", SEND, self.currentWorkModule.jobID, self.currentWorkModule.subJobID, [[NSUserDefaults standardUserDefaults]valueForKey:USERDEFAULTKEY_PHONENUMBER], result];
    DEBUGLOG(@"%@", url);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler: ^ (NSURLResponse *response, NSData *data, NSError *connectionError)
    {
        self->_moneyEarnedThisSession += 0.01;
        self.moneyEarnedLabel.text = [NSString stringWithFormat:@"$%2.2f", self->_moneyEarnedThisSession];
    }];
    self.currentWorkModule = nil;
}

@end

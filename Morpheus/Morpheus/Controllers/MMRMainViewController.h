//
//  MMRMainViewController.h
//  Morpheus
//
//  Created by Comyar Zaheri on 11/15/13.
//  Copyright (c) 2013 Comyar Zaheri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMRMainViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic, readonly) UIWebView       *webView;
@property (strong, nonatomic, readonly) UIButton        *alarmButton;
@property (strong, nonatomic, readonly) UIDatePicker    *datePicker;
@property (strong, nonatomic, readonly) NSTimer         *heartbeat;

@end

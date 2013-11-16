//
//  MMRSettingsViewController.h
//  Morpheus
//
//  Created by Comyar Zaheri on 11/16/13.
//  Copyright (c) 2013 Comyar Zaheri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMRSettingsViewController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic, readonly) UILabel *phoneNumberLabel;
@property (strong, nonatomic, readonly) UITextField *phoneTextField;
@end

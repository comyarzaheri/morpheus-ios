//
//  MMRStatsViewController.m
//  Morpheus
//
//  Created by Comyar Zaheri on 11/16/13.
//  Copyright (c) 2013 Comyar Zaheri. All rights reserved.
//

#import "MMRStatsViewController.h"

@interface MMRStatsViewController ()
@property (assign, nonatomic) CGFloat   balance;
@property (strong, nonatomic) UILabel   *balanceLabel;
@end

@implementation MMRStatsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self initializeBalanceLabel];
    }
    return self;
}

- (void)initializeBalanceLabel
{
    const CGFloat fontSize = 64.0;
    self.balanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, fontSize)];
    [self.balanceLabel setTextAlignment:NSTextAlignmentCenter];
    [self.balanceLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:fontSize]];
    [self.balanceLabel setText:[NSString stringWithFormat:@"$%2.2f", self.balance]];
    [self.balanceLabel setTextColor:[UIColor blackColor]];
    [self.view addSubview:self.balanceLabel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.balance = [[DwollaAPI sharedInstance]balance];
    self.balanceLabel.text = [NSString stringWithFormat:@"$%2.2f", self.balance];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

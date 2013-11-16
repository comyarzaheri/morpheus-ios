//
//  MMRWorkModule.m
//  Morpheus
//
//  Created by Comyar Zaheri on 11/16/13.
//  Copyright (c) 2013 Comyar Zaheri. All rights reserved.
//

#import "MMRWorkModule.h"

@interface MMRWorkModule ()

@property (strong, nonatomic) NSString *func;
@property (strong, nonatomic) NSString *data;
@property (strong, nonatomic) NSString *jobID;
@property (strong, nonatomic) NSString *subJobID;

@end

@implementation MMRWorkModule

- (id)initWithFunc:(NSString *)func data:(NSString *)data jobID:(NSString *)jobID subjobID:(NSString *)subjobID
{
    MMRWorkModule *workModule = [super init];
    if (workModule) {
        workModule.func = func;
        workModule.data = data;
        workModule.jobID = jobID;
        workModule.subJobID = subjobID;
    }
    return workModule;
}

@end

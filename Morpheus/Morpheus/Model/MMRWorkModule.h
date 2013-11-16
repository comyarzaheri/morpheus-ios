//
//  MMRWorkModule.h
//  Morpheus
//
//  Created by Comyar Zaheri on 11/16/13.
//  Copyright (c) 2013 Comyar Zaheri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMRWorkModule : NSObject

- (id)initWithFunc:(NSString *)func data:(NSString *)data jobID:(NSString *)jobID subjobID:(NSString *)subjobID;

@property (strong, nonatomic, readonly) NSString *func;
@property (strong, nonatomic, readonly) NSString *data;
@property (strong, nonatomic, readonly) NSString *jobID;
@property (strong, nonatomic, readonly) NSString *subJobID;

@end

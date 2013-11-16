//
//  Constants.h
//  Morpheus
//
//  Created by Comyar Zaheri on 11/15/13.
//  Copyright (c) 2013 Comyar Zaheri. All rights reserved.
//

#ifndef Morpheus_Constants
#define Morpheus_Constants

#define DEBUG_ON YES
#define DEBUGLOG(...) if(DEBUG_ON) NSLog(__VA_ARGS__)

#define RGB_255(val) (val * 1.0) / 255.0

#define DEBUG_WORK @"https://dl.dropboxusercontent.com/u/35339552/work.html"
#define DEBUG_DATA @"https://dl.dropboxusercontent.com/u/35339552/data.json"

#define HEARTBEAT_INTERVAL 30
#define SECONDS_PER_DAY 86400
#define NOTIFICATION_ALARM @"Alarm"



#endif

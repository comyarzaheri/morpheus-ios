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

#define AVAILABLE_NOTIFY @"54.204.25.111:8000/available"
#define SEND @"54.204.25.111:8000/completion"

#define SECONDS_PER_DAY 86400
#define NOTIFICATION_ALARM @"Alarm"

#define USERDEFAULTKEY_PHONENUMBER @"phone_number"

#endif

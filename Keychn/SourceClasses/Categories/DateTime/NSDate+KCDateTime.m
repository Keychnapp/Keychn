//
//  NSDate+KCDateTime.m
//  Keychn
//
//  Created by Keychn Experience SL on 17/01/16.
//  Copyright © 2016 Keychn Experience SL. All rights reserved.
//

#import "NSDate+KCDateTime.h"

@implementation NSDate (KCDateTime)

+ (NSDate*)getDateFromString:(NSString*)dateString {
    // Converted date from date string
   NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *convertedDate         = [dateFormatter dateFromString:dateString];
    return convertedDate;
}

+(NSInteger)getWeekDayIndexFromSunday {
    //get the index of the day in the current week
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"EEEE"];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    NSInteger weekday = [comps weekday];
    //week index start from Monday in this calendar. But in the app we are using Sunday as the first day
    return (weekday-1);
}

+ (NSString*)getCurrentMonthAndYear {
    // Returns the current month and year
    NSDate *now                     = [NSDate date];
    NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"MMMM"];
    NSString *month                 = [dateFormatter stringFromDate:now];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *year                  = [dateFormatter stringFromDate:now];
    NSString *monthAndYear          = [NSString stringWithFormat:@"%@ %@",[month uppercaseString],year];
    if(DEBUGGING) NSLog(@"Current month and year %@",monthAndYear);
    return monthAndYear;
}

+(NSArray*)getWeekDates {
    //get the dates of this current week, starting from Sunday
    NSMutableArray *weekDatesArray = [[NSMutableArray alloc] init];
    
    //Get calendear for weekdays
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *comp = [cal components:NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitYear|NSCalendarUnitHour
                                    fromDate:now];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"dd"];
    for (int i =0; i<7; i++) {
        NSDate *currentDate = [cal dateFromComponents:comp];
        NSString *stringFromTime =  [dateFormatter stringFromDate:currentDate];
        [weekDatesArray addObject:stringFromTime];
        comp.day    += 1;
    }
    
    //Get sorted week day names
    [NSDate getShortWeekDayNamesByCurrentDate];
    
    if(DEBUGGING) NSLog(@"Dates of the week %@",weekDatesArray);
    return weekDatesArray;
}

+ (NSArray*) getShortWeekDayNamesByCurrentDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSArray *weekDayName           =  [dateFormatter shortWeekdaySymbols];
    NSInteger     weekDayIndex     = [NSDate getWeekDayIndexFromSunday];
    NSMutableArray *sortedWeekDayArray = [[NSMutableArray alloc] init];
    
    //After curren day
    for (NSInteger i=weekDayIndex; i<7; i++) {
        [sortedWeekDayArray addObject:[[weekDayName objectAtIndex:i] uppercaseString]];
    }
    //Before current day
    for (NSInteger i=0; i<weekDayIndex; i++) {
        [sortedWeekDayArray addObject:[[weekDayName objectAtIndex:i] uppercaseString]];
    }
    if(DEBUGGING) NSLog(@"Sorted week array %@",sortedWeekDayArray);
    return sortedWeekDayArray;
}

+ (NSString *)getDateTimeFromDayIndex:(NSInteger)dayIndex andTimeSlot:(NSInteger)timeSlot {
    //This method will return Date by the day index and the time slot
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *comp = [cal components:NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitYear|NSCalendarUnitHour|NSCalendarUnitSecond
                                    fromDate:now];
    
    comp.day     += dayIndex;
    comp.hour    = timeSlot;
    comp.second  -= [NSDate getGMTOffSet];
    NSDate *currentDate = [cal dateFromComponents:comp];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    
    NSString *stringFromTime =  [dateFormatter stringFromDate:currentDate];
    return stringFromTime;
}

+ (NSInteger)getCurrentHour {
    //Get current hour
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"HH"];
    NSDate *currentDate = [NSDate date];
    NSInteger hour      = [[dateFormatter stringFromDate:currentDate] integerValue];
    if(DEBUGGING) NSLog(@"Current Hour %@",[NSNumber numberWithInteger:hour]);
    return hour;
}

+ (NSString*)getCurrentDate {
    //Get current date in string format
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    NSString *stringFromTime =  [dateFormatter stringFromDate:[NSDate date]];
    return stringFromTime;
}

+ (NSString*)getCurrentDateInUTC {
    //Get current date in string format in UTC Time Zone
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    NSString *stringFromTime =  [dateFormatter stringFromDate:[NSDate date]];
    return stringFromTime;
}

+ (NSString*)getCurrentDateInUTCWithFormat:(NSString *)format {
    //Get current date in string format in UTC Time Zone
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:format];
    NSString *stringFromTime =  [dateFormatter stringFromDate:[NSDate date]];
    return stringFromTime;
}

+ (NSTimeInterval)getSecondsFromDate:(NSString*)date {
    // Convert the given data in seconds
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate   *dateFromString = [dateFormatter dateFromString:date];
    NSTimeInterval timeInterval = [dateFromString timeIntervalSince1970];
    return timeInterval;
}

+ (NSTimeInterval)getSecondsFromDate:(NSString*)date withDateFormatter:(NSString*)dateFormat {
    // Convert the given data in seconds
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:dateFormat];
    NSDate   *dateFromString = [dateFormatter dateFromString:date];
    NSTimeInterval timeInterval = [dateFromString timeIntervalSince1970];
    return timeInterval;
}

+ (NSString*)getDayNameFromTimeInterval:(NSTimeInterval)timeInterval fullName:(BOOL)flag {
    //Get formatted day and time
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSDate *date                   = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    if(flag) {
        // Full Name of the day
        [dateFormatter setDateFormat:@"EEEE"];
    }
    else {
        [dateFormatter setDateFormat:@"EEE"];
    }
    //Get day
    
    NSString *dayName   = [dateFormatter stringFromDate:date];
    return dayName;
}

+ (NSString*)getTimeFromTimeInterval:(NSTimeInterval)timeInterval {
    //Get time in 24 hour format
    NSDate *date                   = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSString *hour = [dateFormatter stringFromDate:date];
    return hour;
}

+ (NSString*)get12HourFormatTimeFromTimeInterval:(NSTimeInterval)timeInterval {
    //Get time in 12 hour format
    NSDate *date                   = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSString *hour = [dateFormatter stringFromDate:date];
    return hour;
}

+ (NSString*)getHourAndMinuteFromTimeInterval:(NSTimeInterval)timeInterval {
    //Get time in 24 hour format
    NSDate *date                   = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *hour = [dateFormatter stringFromDate:date];
    return hour;
}

+ (NSInteger)getDateFromTimeInterval:(NSTimeInterval)timeInterval {
    // Get date from time interval
    NSDate *date                   = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"dd"];
    NSInteger dateValue            = [[dateFormatter stringFromDate:date] integerValue];
    return dateValue;
}

+ (NSString*)getFullDateFromTimeInterval:(NSTimeInterval)timeInterval {
    // Get full date from time interval in yyyy/MM/dd format
    NSDate *date                   = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString *convertedDate         = [dateFormatter stringFromDate:date];
    return convertedDate;
}

+ (NSString*)getDateAndMonthFromTimeInterval:(NSTimeInterval)timeInterval {
    // Get full date from time interval in yyyy/MM/dd format
    NSDate *date                   = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"MMM dd, EEE"];
    NSString *convertedDate         = [dateFormatter stringFromDate:date];
    return convertedDate;
}

+ (NSString*)getDateTimeFromTimeInterval:(NSTimeInterval)timeInterval {
    // Get full date from time interval in yyyy/MM/dd  hh:mm:ss format
    NSDate *date                   = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy/MM/dd hh:mm:ss"];
    NSString *convertedDate         = [dateFormatter stringFromDate:date];
    return convertedDate;
}

+ (NSString*)getMonthFromTimeInterval:(NSTimeInterval)timeInterval {
    // Get month name from time interval
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"MMM"];
    NSDate *date       = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *month    = [dateFormatter stringFromDate:date];
    return month;
}

+ (NSInteger)getGMTOffSet {
    NSTimeZone *destinationTimeZone = [NSTimeZone systemTimeZone];
    return [destinationTimeZone secondsFromGMT];
}

@end

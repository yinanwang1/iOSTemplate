//
//  NSDate+Extension.m
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import "NSDate+Extension.h"

static NSDateFormatter *_dateFormatter;

static NSMutableDictionary *_cachedDateFormatter = nil;

@implementation NSDate(Extension)

+(NSCalendar*)calendar
{
    static NSCalendar* cal;
    if (nil == cal) {
        //@ change to the first day in a month
        //@Note: we need to set the time zone to 'GMT', otherwise, the date will not right(one day offset)
        cal = [NSCalendar currentCalendar];
        [cal setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    }
    return cal;
}

// The allocating/initializing of NSDateFormatter was considered expensive. So we use this, not allocat/initialize it every time
- (NSDateFormatter *)dateFormatter {
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    return _dateFormatter;
}

- (NSString *)YMDString
{
    self.dateFormatter.dateFormat = @"YYYY-MM-dd";
    return [self.dateFormatter stringFromDate:self];
}

- (NSString *)YMDPointString
{
    self.dateFormatter.dateFormat = @"YYYY.MM.dd";
    return [self.dateFormatter stringFromDate:self];
}

+ (NSString *)YMDFromSecondsSince1970:(long long)seconds
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    return [date YMDString];
}

+ (NSString *)stringFromSecondsSince1970:(long long)seconds format:(NSString *)format
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    
    date.dateFormatter.dateFormat = format;
    return  [date.dateFormatter stringFromDate:date];
}

- (NSDateComponents*)components {
    return [[NSDate calendar] components:( NSCalendarUnitMonth |  NSCalendarUnitYear | NSCalendarUnitDay | NSCalendarUnitWeekday) fromDate:self];
}

- (NSInteger)weekDay {
    NSDateComponents *comps = [[NSDate calendar]  components:NSCalendarUnitWeekday fromDate:self];
    return [comps weekday] - 1;
}

- (NSDate *)dateByAddingMonth:(NSInteger)monthCount
{
    NSDateComponents* components = [[NSDateComponents alloc] init];
    components.month = monthCount;
    
    return [[NSDate calendar] dateByAddingComponents:components toDate:self options:0];
}


+ (NSString *)updateTimeForRow:(NSInteger)timeInterval {
    // 获取当前时时间戳
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    // 创建时间戳
    NSTimeInterval createTime = timeInterval;
    // 时间差
    NSTimeInterval time = currentTime - createTime;
    
    // 秒转分钟
    NSInteger minutes = time/60;
    if (minutes < 60) {
        if(minutes == 0){
            
            return @"刚刚";
        } else {
            
            return [NSString stringWithFormat:@"%ld分钟前",(long)minutes];
        }
    }
    
    // 秒转小时
    NSInteger hours = time/3600;
    if (hours < 24) {
        return [NSString stringWithFormat:@"%ld小时前",(long)hours];
    }
    //秒转天数
    NSInteger days = time/3600/24;
    if (days < 30) {
        return [NSString stringWithFormat:@"%ld天前",(long)days];
    }
    //秒转月
    NSInteger months = time/3600/24/30;
    if (months < 12) {
        return [NSString stringWithFormat:@"%ld月前",(long)months];
    }
    //秒转年
    NSInteger years = time/3600/24/30/12;
    return [NSString stringWithFormat:@"%ld年前",(long)years];
}

+ (NSDate *)dateFromString:(NSString *)dateString formatString:(NSString *)formatStr
{
    if ( nil == dateString )
    {
        return nil;
    }
    
    NSString *format = nil;
    if ( nil == formatStr )
    {
        format = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    }
    else
    {
        format = [NSString stringWithFormat:@"%@", formatStr];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSDate *destDate = [dateFormatter dateFromString:dateString];
    
    return [self localDateFromUTCDate:destDate];
}

+ (NSString *)stringFromDate:(NSDate *)date formatString:(NSString *)formatStr
{
    if ( nil == date )
    {
        return nil;
    }
    
    NSString *format = nil;
    if ( nil == formatStr )
    {
        format = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    }
    else
    {
        format = [NSString stringWithFormat:@"%@", formatStr];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}

+ (NSDate *)UTCDateFromLocalDate:(NSDate *)date
{
    // time zone
    NSTimeZone *sourceTimeZone = [NSTimeZone localTimeZone];
    
    // interval
    NSTimeInterval interval = [sourceTimeZone secondsFromGMT];
    
    NSDate *destinationDateNow = [date dateByAddingTimeInterval:-interval];
    
    
    return destinationDateNow;
}

+ (NSDate *)localDateFromUTCDate:(NSDate *)date
{
    // time zone
    NSTimeZone *sourceTimeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSTimeZone *destinationTimeZone = [NSTimeZone localTimeZone];
    
    // offset
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:date];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:date];
    
    // interval
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    NSDate *destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:date];
    
    return destinationDateNow;
}

+ (NSString *)formatFileSizeByByte:(float)bytesSize{
    float fileSize = bytesSize/(1024.0*1024.0*1024.0);
    if (fileSize < 1.0){
        fileSize = fileSize * 1024.0;
        if (fileSize < 1.0){
            fileSize = fileSize * 1024.0;
            if (fileSize < 1.0)
                fileSize = 1.0;
            return [NSString stringWithFormat:@"%4.2f KB",fileSize];
        }else
            return [NSString stringWithFormat:@"%4.2f MB",fileSize];
    }else
        return [NSString stringWithFormat:@"%4.2f GB",fileSize];
}

+ (NSString *)formatTime:(NSTimeInterval)inter{
    NSTimeInterval val = inter/(60.0*60.0);
    int h,m,s;
    if (val < 1.0) {
        h = 0;
    }else {
        h = (int)val;
    }
    val = val * 60.0;
    if (val < 1.0) {
        m = 0;
    }else {
        m = ((int)val)%60;
    }
    val = val * 60;
    if (val < 1.0) {
        s = 0;
    }else {
        s = ((int)val)%60;
    }
    NSString *mstr = m < 10?[NSString stringWithFormat:@"0%d",m]:[NSString stringWithFormat:@"%d",m];
    NSString *sstr = s < 10?[NSString stringWithFormat:@"0%d",s]:[NSString stringWithFormat:@"%d",s];
    return [NSString stringWithFormat:@"%d:%@:%@",h,mstr,sstr];
}

+ (NSString *)formatDateWithAgo:(NSDate *)date{
    NSTimeInterval inter = -[date timeIntervalSinceNow];
    if (inter < 10.0f) {
        return @"Seconds ago";
    } else if (inter < 60.0f) {
        return @"Less than 1 min";
    }else {
        int mInter = (int)round(inter/60.0);
        if (mInter < 60.0) {
            if (mInter == 1) {
                return @"1 min ago";
            }else {
                return [NSString stringWithFormat:@"%d mins ago",mInter];
            }
        }else {
            int hInter = (int)round(inter/(60.0*60.0));
            if (hInter < 24) {
                if (hInter == 1) {
                    return @"1 hour ago";
                }else {
                    return [NSString stringWithFormat:@"%d hours ago",hInter];
                }
            }else {
                int dInter = (int)round(inter/(60.0*60.0*24.0));
                if (dInter < 7) {
                    if (dInter == 1) {
                        return @"1 day ago";
                    }else {
                        return [NSString stringWithFormat:@"%d days ago",dInter];
                    }
                }else {
                    int wInter = (int)round(inter/(60.0*60.0*24.0*7.0));
                    if (wInter < 4) {
                        if (wInter == 1) {
                            return @"1 week ago";
                        }else {
                            return [NSString stringWithFormat:@"%d weeks ago",wInter];
                        }
                    }else {
                        return [self formatDate:date style:YNFormatDateStyleWeek];
                    }
                }
            }
        }
    }
}

+ (NSString *)formatFBTime:(NSDate *)date {
    NSDateFormatter *format = [self getDateFormatter:@"h:mma"];
    return [format stringFromDate:date];
}

+ (NSString *)formatDateWithFBAgo:(NSDate *)date{
    NSTimeInterval inter = -[date timeIntervalSinceNow];
    if (inter < 10.0f) {
        return NSLocalizedString(@"Seconds ago",@"");
    } else if (inter < 60.0f) {
        return NSLocalizedString(@"Less than 1 min",@"");
    }else {
        int mInter = (int)round(inter/60.0);
        if (mInter < 60.0) {
            if (mInter == 1) {
                return NSLocalizedString(@"1 min ago",@"");
            }else {
                return [NSString stringWithFormat:NSLocalizedString(@"%d mins ago",@""),mInter];
            }
        }else {
            int hInter = (int)round(inter/(60.0*60.0));
            if (hInter < 24) {
                if (hInter == 1) {
                    return NSLocalizedString(@"1 hour ago",@"");
                }else {
                    return [NSString stringWithFormat:NSLocalizedString(@"%d hours ago",@""),hInter];
                }
            }else {
                int dInter = (int)round(inter/(60.0*60.0*24.0));
                if (dInter < 7) {
                    if (dInter == 1) {
                        return [[NSLocalizedString(@"Yesterday at", @"") stringByAppendingString:@" "] stringByAppendingString:[self formatFBTime:date]];
                    }else {
                        NSMutableString *str = [NSMutableString stringWithCapacity:20];
                        NSDateFormatter *format = [self getDateFormatter:@"EEEE"];
                        [str appendString:[format stringFromDate:date]];
                        [str appendString:@" "];
                        [str appendString:NSLocalizedString(@"at",@"")];
                        [str appendString:@" "];
                        [str appendString:[self formatFBTime:date]];
                        return str;
                    }
                }else {
                    int wInter = (int)round(inter/(60.0*60.0*24.0*7.0));
                    if (wInter < 4) {
                        if (wInter == 1) {
                            return  NSLocalizedString(@"1 week ago",@"");
                        }else {
                            return [NSString stringWithFormat:NSLocalizedString(@"%d weeks ago",@""),wInter];
                        }
                    }else {
                        return [self formatDate:date style:YNFormatDateStyleWeek];
                    }
                }
            }
        }
    }
}

+ (NSString *)formatDate:(NSDate *)date style:(YNFormatDateStyle)style{
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    if (style == YNFormatDateStyleAgo) {
        return [self formatDateWithAgo:date];
    }else {
        NSString *formatString = nil;
        switch (style) {
            case YNFormatDateStyleNormal:
                formatString = @"MM/dd/yyyy 'at' HH:mm:ss aaa";
                break;
            case YNFormatDateStyleWeek:
                formatString = @"EEE MMM dd HH:mm a";
                break;
            case YNFormatDateStyleDay:
                formatString = @"yyyy-MM-dd";
                break;
            case YNFormatDateStylePointDay:
                formatString = @"yyy.MM.dd";
            default:
                break;
        }
        [format setDateFormat:formatString];
        return [format stringFromDate:date];
    }
}

+ (NSString *)formatDate:(NSDate *)date {
    return [self formatDate:date style:YNFormatDateStyleAgo];
}

+ (NSDate *)parseFBDateString:(NSString *)str {
    if (str == nil)
        return nil;
    NSDateFormatter *formatter = [self getDateFormatter:@"yyyy-MM-ddHH:mm:ssZZZZ"];
    return [formatter dateFromString:[str stringByReplacingOccurrencesOfString:@"T" withString:@""]];
}

+ (NSDateFormatter *)getDateFormatter:(NSString *)pattern
{
    if (_cachedDateFormatter == nil)
        _cachedDateFormatter = [[NSMutableDictionary alloc] initWithCapacity:5];
    NSDateFormatter *formatter = [_cachedDateFormatter objectForKey:pattern];
    if (formatter != nil)
        return formatter;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:pattern];
    [_cachedDateFormatter setObject:formatter forKey:pattern];
    return formatter;
}

+ (NSString *)timeFormat:(NSDate *)date style:(YNFormatTimeStyle)style{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:(style == YNFormatTimeStyle24)?@"HH:mm":@"hh:mm aaa"];
    return [format stringFromDate:date];
}


+ (NSString *)dateStringFromSicne1970:(NSInteger)time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    
    return [dateFormatter stringFromDate:date];
}

- (NSUInteger)day {
    return [NSDate day:self];
}

- (NSUInteger)month {
    return [NSDate month:self];
}

- (NSUInteger)year {
    return [NSDate year:self];
}

- (NSUInteger)hour {
    return [NSDate hour:self];
}

- (NSUInteger)minute {
    return [NSDate minute:self];
}

- (NSUInteger)second {
    return [NSDate second:self];
}

+ (NSUInteger)day:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    // NSDayCalendarUnit
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitDay) fromDate:date];
#else
    NSDateComponents *dayComponents = [calendar components:(NSDayCalendarUnit) fromDate:date];
#endif
    
    return [dayComponents day];
}

+ (NSUInteger)month:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    // NSDayCalendarUnit
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitMonth) fromDate:date];
#else
    NSDateComponents *dayComponents = [calendar components:(NSMonthCalendarUnit) fromDate:date];
#endif
    
    return [dayComponents month];
}

+ (NSUInteger)year:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    // NSDayCalendarUnit
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitYear) fromDate:date];
#else
    NSDateComponents *dayComponents = [calendar components:(NSYearCalendarUnit) fromDate:date];
#endif
    
    return [dayComponents year];
}

+ (NSUInteger)hour:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    // NSDayCalendarUnit
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitHour) fromDate:date];
#else
    NSDateComponents *dayComponents = [calendar components:(NSHourCalendarUnit) fromDate:date];
#endif
    
    return [dayComponents hour];
}

+ (NSUInteger)minute:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    // NSDayCalendarUnit
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitMinute) fromDate:date];
#else
    NSDateComponents *dayComponents = [calendar components:(NSMinuteCalendarUnit) fromDate:date];
#endif
    
    return [dayComponents minute];
}

+ (NSUInteger)second:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    // NSDayCalendarUnit
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitSecond) fromDate:date];
#else
    NSDateComponents *dayComponents = [calendar components:(NSSecondCalendarUnit) fromDate:date];
#endif
    
    return [dayComponents second];
}

- (NSUInteger)daysInYear {
    return [NSDate daysInYear:self];
}

+ (NSUInteger)daysInYear:(NSDate *)date {
    return [self isLeapYear:date] ? 366 : 365;
}

- (BOOL)isLeapYear {
    return [NSDate isLeapYear:self];
}

+ (BOOL)isLeapYear:(NSDate *)date {
    NSUInteger year = [date year];
    if ((year % 4  == 0 && year % 100 != 0) || year % 400 == 0) {
        return YES;
    }
    return NO;
}

- (NSString *)formatYMD {
    return [NSDate formatYMD:self];
}

+ (NSString *)formatYMD:(NSDate *)date {
    return [NSString stringWithFormat:@"%lu-%02lu-%02lu", (unsigned long)[date year], (unsigned long)[date month], (unsigned long)[date day]];
}

- (NSUInteger)weeksOfMonth {
    return [NSDate weeksOfMonth:self];
}

+ (NSUInteger)weeksOfMonth:(NSDate *)date {
    return [[date lastdayOfMonth] weekOfYear] - [[date begindayOfMonth] weekOfYear] + 1;
}

- (NSUInteger)weekOfYear {
    return [NSDate weekOfYear:self];
}

+ (NSUInteger)weekOfYear:(NSDate *)date {
    NSUInteger i;
    NSUInteger year = [date year];
    
    NSDate *lastdate = [date lastdayOfMonth];
    
    for (i = 1;[[lastdate dateAfterDay:-7 * i] year] == year; i++) {
        
    }
    
    return i;
}

- (NSDate *)dateAfterDay:(NSUInteger)day {
    return [NSDate dateAfterDate:self day:day];
}

+ (NSDate *)dateAfterDate:(NSDate *)date day:(NSInteger)day {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    [componentsToAdd setDay:day];
    
    NSDate *dateAfterDay = [calendar dateByAddingComponents:componentsToAdd toDate:date options:0];
    
    return dateAfterDay;
}

- (NSDate *)dateAfterMonth:(NSUInteger)month {
    return [NSDate dateAfterDate:self month:month];
}

+ (NSDate *)dateAfterDate:(NSDate *)date month:(NSInteger)month {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    [componentsToAdd setMonth:month];
    NSDate *dateAfterMonth = [calendar dateByAddingComponents:componentsToAdd toDate:date options:0];
    
    return dateAfterMonth;
}

- (NSDate *)begindayOfMonth {
    return [NSDate begindayOfMonth:self];
}

+ (NSDate *)begindayOfMonth:(NSDate *)date {
    return [self dateAfterDate:date day:-[date day] + 1];
}

- (NSDate *)lastdayOfMonth {
    return [NSDate lastdayOfMonth:self];
}

+ (NSDate *)lastdayOfMonth:(NSDate *)date {
    NSDate *lastDate = [self begindayOfMonth:date];
    return [[lastDate dateAfterMonth:1] dateAfterDay:-1];
}

- (NSUInteger)daysAgo {
    return [NSDate daysAgo:self];
}

+ (NSUInteger)daysAgo:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSDateComponents *components = [calendar components:(NSCalendarUnitDay)
                                               fromDate:date
                                                 toDate:[NSDate date]
                                                options:0];
#else
    NSDateComponents *components = [calendar components:(NSDayCalendarUnit)
                                               fromDate:date
                                                 toDate:[NSDate date]
                                                options:0];
#endif
    
    return [components day];
}

- (NSInteger)weekday {
    return [NSDate weekday:self];
}

+ (NSInteger)weekday:(NSDate *)date {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday) fromDate:date];
    NSInteger weekday = [comps weekday];
    
    return weekday;
}

- (NSString *)dayFromWeekday {
    return [NSDate dayFromWeekday:self];
}

+ (NSString *)dayFromWeekday:(NSDate *)date {
    switch([date weekday]) {
        case 1:
            return @"星期天";
            break;
        case 2:
            return @"星期一";
            break;
        case 3:
            return @"星期二";
            break;
        case 4:
            return @"星期三";
            break;
        case 5:
            return @"星期四";
            break;
        case 6:
            return @"星期五";
            break;
        case 7:
            return @"星期六";
            break;
        default:
            break;
    }
    return @"";
}

- (BOOL)isSameDay:(NSDate *)anotherDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components1 = [calendar components:(NSCalendarUnitYear
                                                          | NSCalendarUnitMonth
                                                          | NSCalendarUnitDay)
                                                fromDate:self];
    NSDateComponents *components2 = [calendar components:(NSCalendarUnitYear
                                                          | NSCalendarUnitMonth
                                                          | NSCalendarUnitDay)
                                                fromDate:anotherDate];
    return ([components1 year] == [components2 year]
            && [components1 month] == [components2 month]
            && [components1 day] == [components2 day]);
}

- (BOOL)isToday {
    return [self isSameDay:[NSDate date]];
}

- (NSDate *)dateByAddingDays:(NSUInteger)days {
    NSDateComponents *c = [[NSDateComponents alloc] init];
    c.day = days;
    return [[NSCalendar currentCalendar] dateByAddingComponents:c toDate:self options:0];
}

/**
 *  Get the month as a localized string from the given month number
 *
 *  @param month The month to be converted in string
 *  [1 - January]
 *  [2 - February]
 *  [3 - March]
 *  [4 - April]
 *  [5 - May]
 *  [6 - June]
 *  [7 - July]
 *  [8 - August]
 *  [9 - September]
 *  [10 - October]
 *  [11 - November]
 *  [12 - December]
 *
 *  @return Return the given month as a localized string
 */
+ (NSString *)monthWithMonthNumber:(NSInteger)month {
    switch(month) {
        case 1:
            return @"January";
            break;
        case 2:
            return @"February";
            break;
        case 3:
            return @"March";
            break;
        case 4:
            return @"April";
            break;
        case 5:
            return @"May";
            break;
        case 6:
            return @"June";
            break;
        case 7:
            return @"July";
            break;
        case 8:
            return @"August";
            break;
        case 9:
            return @"September";
            break;
        case 10:
            return @"October";
            break;
        case 11:
            return @"November";
            break;
        case 12:
            return @"December";
            break;
        default:
            break;
    }
    return @"";
}

+ (NSString *)stringWithDate:(NSDate *)date format:(NSString *)format {
    return [date stringWithFormat:format];
}

- (NSString *)stringWithFormat:(NSString *)format {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:format];
    
    NSString *retStr = [outputFormatter stringFromDate:self];
    
    return retStr;
}

+ (NSDate *)dateWithString:(NSString *)string format:(NSString *)format {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:format];
    
    NSDate *date = [inputFormatter dateFromString:string];
    
    return date;
}

- (NSUInteger)daysInMonth:(NSUInteger)month {
    return [NSDate daysInMonth:self month:month];
}

+ (NSUInteger)daysInMonth:(NSDate *)date month:(NSUInteger)month {
    switch (month) {
        case 1: case 3: case 5: case 7: case 8: case 10: case 12:
            return 31;
        case 2:
            return [date isLeapYear] ? 29 : 28;
    }
    return 30;
}

- (NSUInteger)daysInMonth {
    return [NSDate daysInMonth:self];
}

+ (NSUInteger)daysInMonth:(NSDate *)date {
    return [self daysInMonth:date month:[date month]];
}

- (NSString *)timeInfo {
    return [NSDate timeInfoWithDate:self];
}

+ (NSString *)timeInfoWithDate:(NSDate *)date {
    return [self timeInfoWithDateString:[self stringWithDate:date format:[self ymdHmsFormat]]];
}

+ (NSString *)timeInfoWithDateString:(NSString *)dateString {
    NSDate *date = [self dateWithString:dateString format:[self ymdHmsFormat]];
    
    NSDate *curDate = [NSDate date];
    NSTimeInterval time = -[date timeIntervalSinceDate:curDate];
    
    int month = (int)([curDate month] - [date month]);
    int year = (int)([curDate year] - [date year]);
    int day = (int)([curDate day] - [date day]);
    
    NSTimeInterval retTime = 1.0;
    if (time < 3600) { // 小于一小时
        retTime = time / 60;
        retTime = retTime <= 0.0 ? 1.0 : retTime;
        return [NSString stringWithFormat:@"%.0f分钟前", retTime];
    } else if (time < 3600 * 24) { // 小于一天，也就是今天
        retTime = time / 3600;
        retTime = retTime <= 0.0 ? 1.0 : retTime;
        return [NSString stringWithFormat:@"%.0f小时前", retTime];
    } else if (time < 3600 * 24 * 2) {
        return @"昨天";
    }
    // 第一个条件是同年，且相隔时间在一个月内
    // 第二个条件是隔年，对于隔年，只能是去年12月与今年1月这种情况
    else if ((abs(year) == 0 && abs(month) <= 1)
             || (abs(year) == 1 && [curDate month] == 1 && [date month] == 12)) {
        int retDay = 0;
        if (year == 0) { // 同年
            if (month == 0) { // 同月
                retDay = day;
            }
        }
        
        if (retDay <= 0) {
            // 获取发布日期中，该月有多少天
            int totalDays = (int)[self daysInMonth:date month:[date month]];
            
            // 当前天数 + （发布日期月中的总天数-发布日期月中发布日，即等于距离今天的天数）
            retDay = (int)[curDate day] + (totalDays - (int)[date day]);
        }
        
        return [NSString stringWithFormat:@"%d天前", (abs)(retDay)];
    } else  {
        if (abs(year) <= 1) {
            if (year == 0) { // 同年
                return [NSString stringWithFormat:@"%d个月前", abs(month)];
            }
            
            // 隔年
            int month = (int)[curDate month];
            int preMonth = (int)[date month];
            if (month == 12 && preMonth == 12) {// 隔年，但同月，就作为满一年来计算
                return @"1年前";
            }
            return [NSString stringWithFormat:@"%d个月前", (abs)(12 - preMonth + month)];
        }
        
        return [NSString stringWithFormat:@"%d年前", abs(year)];
    }
    
    return @"1小时前";
}

- (NSString *)ymdFormat {
    return [NSDate ymdFormat];
}

- (NSString *)hmsFormat {
    return [NSDate hmsFormat];
}

- (NSString *)ymdHmsFormat {
    return [NSDate ymdHmsFormat];
}

+ (NSString *)ymdFormat {
    return @"yyyy-MM-dd";
}

+ (NSString *)hmsFormat {
    return @"HH:mm:ss";
}

+ (NSString *)ymdHmsFormat {
    return [NSString stringWithFormat:@"%@ %@", [self ymdFormat], [self hmsFormat]];
}

- (NSDate *)offsetYears:(int)numYears {
    return [NSDate offsetYears:numYears fromDate:self];
}

+ (NSDate *)offsetYears:(int)numYears fromDate:(NSDate *)fromDate {
    if (fromDate == nil) {
        return nil;
    }
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    // NSDayCalendarUnit
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
#else
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
#endif
    
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setYear:numYears];
    
    return [gregorian dateByAddingComponents:offsetComponents
                                      toDate:fromDate
                                     options:0];
}

- (NSDate *)offsetMonths:(int)numMonths {
    return [NSDate offsetMonths:numMonths fromDate:self];
}

+ (NSDate *)offsetMonths:(int)numMonths fromDate:(NSDate *)fromDate {
    if (fromDate == nil) {
        return nil;
    }
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    // NSDayCalendarUnit
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
#else
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
#endif
    
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:numMonths];
    
    return [gregorian dateByAddingComponents:offsetComponents
                                      toDate:fromDate
                                     options:0];
}

- (NSDate *)offsetDays:(int)numDays {
    return [NSDate offsetDays:numDays fromDate:self];
}

+ (NSDate *)offsetDays:(int)numDays fromDate:(NSDate *)fromDate {
    if (fromDate == nil) {
        return nil;
    }
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    // NSDayCalendarUnit
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
#else
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
#endif
    
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:numDays];
    
    return [gregorian dateByAddingComponents:offsetComponents
                                      toDate:fromDate
                                     options:0];
}

- (NSDate *)offsetHours:(int)hours {
    return [NSDate offsetHours:hours fromDate:self];
}

+ (NSDate *)offsetHours:(int)numHours fromDate:(NSDate *)fromDate {
    if (fromDate == nil) {
        return nil;
    }
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    // NSDayCalendarUnit
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
#else
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
#endif
    
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setHour:numHours];
    
    return [gregorian dateByAddingComponents:offsetComponents
                                      toDate:fromDate
                                     options:0];
}


@end

//===============================================================================================================

@implementation NSString (Date)

-(NSDate*)dateWithFormat:(NSString*)format {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    
    return [formatter dateFromString:self];
}
@end

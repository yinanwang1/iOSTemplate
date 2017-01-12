//
//  NSDate+Extension.h
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    YNFormatDateStyleNormal,
    YNFormatDateStyleAgo,			//default style
    YNFormatDateStyleWeek,
    YNFormatDateStyleDay,
    YNFormatDateStylePointDay,
}YNFormatDateStyle;

typedef enum{
    YNFormatTimeStyle24 = 0,
    YNFormatTimeStyle12
}YNFormatTimeStyle;

@interface NSDate(Extension)

/**
 *  2016-1-1
 */
- (NSString *)YMDString;
/**
 *  2016.1.1
 */
- (NSString *)YMDPointString;

+ (NSString *)YMDFromSecondsSince1970:(long long)seconds;

+ (NSString *)stringFromSecondsSince1970:(long long)seconds format:(NSString *)format;
/**
 *  计算时间差
 *
 *  @param timeInterval
 *
 *  @return 
 */
+ (NSString *)updateTimeForRow:(NSInteger)timeInterval;
- (NSDateComponents*)components;
- (NSInteger)weekDay;

// 当前日期加上 monthCount 个月以后的日期
- (NSDate *)dateByAddingMonth:(NSInteger)monthCount;

/**
 *  Transform NSString to NSDate
 *
 *  @param dateString The String like "2014-10-12T20:22:12Z"
 *  @param formatStr  The String like "yyyy-MM-dd'T'HH:mm:ss'Z'". If formatStr is nil, will
 *                    use "yyyy-MM-dd'T'HH:mm:ss'Z'"
 *
 *  @return Data type is NSDate
 */
+ (NSDate *)dateFromString:(NSString *)dateString formatString:(NSString *)formatStr;

/**
 *  Transform NSDate to NSString
 *
 *  @param date      Data type is NSDate
 *  @param formatStr The String like "yyyy-MM-dd'T'HH:mm:ss'Z'". If formatStr is nil, will
 *                   use "yyyy-MM-dd'T'HH:mm:ss'Z'"
 *
 *  @return Data type is NSString, like "2014-10-12T20:22:12Z"
 */
+ (NSString *)stringFromDate:(NSDate *)date formatString:(NSString *)formatStr;

/**
 *  Transform local date to UTC date.
 *
 *  @param date Data type is NSDate and the date is device's time.
 *
 *  @return UTC date
 */
+ (NSDate *)UTCDateFromLocalDate:(NSDate *)date;

/**
 *  Transform UTC date to local date.
 *
 *  @param date Data type is NSDate and UTC date.
 *
 *  @return Local date
 */
+ (NSDate *)localDateFromUTCDate:(NSDate *)date;

//////////////////////////////////////////////////////////////////////////////////////////////
//	4.2f GB/MB/KB
// eg: 15.32 MB
//////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString *)formatFileSizeByByte:(float)bytesSize;

//////////////////////////////////////////////////////////////////////////////////////////////
//	HH:MM:SS
// eg: 3:05:12
//////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString *)formatTime:(NSTimeInterval)inter;


//////////////////////////////////////////////////////////////////////////////////////////////
//	1 min ago / 3 weeks ago
// YNFormatDateStyleAgo is default style
//////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString *)formatDate:(NSDate *)date;
+ (NSString *)formatDate:(NSDate *)date style:(YNFormatDateStyle)style;

+ (NSString *)formatDateWithFBAgo:(NSDate *)date;
+ (NSDate *)parseFBDateString:(NSString *)str;


//////////////////////////////////////////////////////////////////////////////////////////////
//	23:30 or 11:30 PM
// YNFormatTimeStyle24 is default style
//////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString *)timeFormat:(NSDate *)date style:(YNFormatTimeStyle)style;

/**
 *  时间戳转@"yyyy-MM-dd"
 *
 *  @param time 时间戳
 *
 *  @return @"yyyy-MM-dd"字符串
 */
+ (NSString *)dateStringFromSicne1970:(NSInteger)time;

/**
 * 获取日、月、年、小时、分钟、秒
 */
- (NSUInteger)day;
- (NSUInteger)month;
- (NSUInteger)year;
- (NSUInteger)hour;
- (NSUInteger)minute;
- (NSUInteger)second;
+ (NSUInteger)day:(NSDate *)date;
+ (NSUInteger)month:(NSDate *)date;
+ (NSUInteger)year:(NSDate *)date;
+ (NSUInteger)hour:(NSDate *)date;
+ (NSUInteger)minute:(NSDate *)date;
+ (NSUInteger)second:(NSDate *)date;

/**
 * 获取一年中的总天数
 */
- (NSUInteger)daysInYear;
+ (NSUInteger)daysInYear:(NSDate *)date;

/**
 * 判断是否是润年
 * @return YES表示润年，NO表示平年
 */
- (BOOL)isLeapYear;
+ (BOOL)isLeapYear:(NSDate *)date;

/**
 * 获取该日期是该年的第几周
 */
- (NSUInteger)weekOfYear;
+ (NSUInteger)weekOfYear:(NSDate *)date;

/**
 * 获取格式化为YYYY-MM-dd格式的日期字符串
 */
- (NSString *)formatYMD;
+ (NSString *)formatYMD:(NSDate *)date;

/**
 * 返回当前月一共有几周(可能为4,5,6)
 */
- (NSUInteger)weeksOfMonth;
+ (NSUInteger)weeksOfMonth:(NSDate *)date;

/**
 * 获取该月的第一天的日期
 */
- (NSDate *)begindayOfMonth;
+ (NSDate *)begindayOfMonth:(NSDate *)date;

/**
 * 获取该月的最后一天的日期
 */
- (NSDate *)lastdayOfMonth;
+ (NSDate *)lastdayOfMonth:(NSDate *)date;

/**
 * 返回day天后的日期(若day为负数,则为|day|天前的日期)
 */
- (NSDate *)dateAfterDay:(NSUInteger)day;
+ (NSDate *)dateAfterDate:(NSDate *)date day:(NSInteger)day;

/**
 * 返回day天后的日期(若day为负数,则为|day|天前的日期)
 */
- (NSDate *)dateAfterMonth:(NSUInteger)month;
+ (NSDate *)dateAfterDate:(NSDate *)date month:(NSInteger)month;

/**
 * 返回numYears年后的日期
 */
- (NSDate *)offsetYears:(int)numYears;
+ (NSDate *)offsetYears:(int)numYears fromDate:(NSDate *)fromDate;

/**
 * 返回numMonths月后的日期
 */
- (NSDate *)offsetMonths:(int)numMonths;
+ (NSDate *)offsetMonths:(int)numMonths fromDate:(NSDate *)fromDate;

/**
 * 返回numDays天后的日期
 */
- (NSDate *)offsetDays:(int)numDays;
+ (NSDate *)offsetDays:(int)numDays fromDate:(NSDate *)fromDate;

/**
 * 返回numHours小时后的日期
 */
- (NSDate *)offsetHours:(int)hours;
+ (NSDate *)offsetHours:(int)numHours fromDate:(NSDate *)fromDate;

/**
 * 距离该日期前几天
 */
- (NSUInteger)daysAgo;
+ (NSUInteger)daysAgo:(NSDate *)date;

/**
 *  获取星期几
 *
 *  @return Return weekday number
 *  [1 - Sunday]
 *  [2 - Monday]
 *  [3 - Tuerday]
 *  [4 - Wednesday]
 *  [5 - Thursday]
 *  [6 - Friday]
 *  [7 - Saturday]
 */
- (NSInteger)weekday;
+ (NSInteger)weekday:(NSDate *)date;

/**
 *  获取星期几(名称)
 *
 *  @return Return weekday as a localized string
 *  [1 - Sunday]
 *  [2 - Monday]
 *  [3 - Tuerday]
 *  [4 - Wednesday]
 *  [5 - Thursday]
 *  [6 - Friday]
 *  [7 - Saturday]
 */
- (NSString *)dayFromWeekday;
+ (NSString *)dayFromWeekday:(NSDate *)date;

/**
 *  日期是否相等
 *
 *  @param anotherDate The another date to compare as NSDate
 *  @return Return YES if is same day, NO if not
 */
- (BOOL)isSameDay:(NSDate *)anotherDate;

/**
 *  是否是今天
 *
 *  @return Return if self is today
 */
- (BOOL)isToday;

/**
 *  Add days to self
 *
 *  @param days The number of days to add
 *  @return Return self by adding the gived days number
 */
- (NSDate *)dateByAddingDays:(NSUInteger)days;

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
+ (NSString *)monthWithMonthNumber:(NSInteger)month;

/**
 * 根据日期返回字符串
 */
+ (NSString *)stringWithDate:(NSDate *)date format:(NSString *)format;
- (NSString *)stringWithFormat:(NSString *)format;
+ (NSDate *)dateWithString:(NSString *)string format:(NSString *)format;

/**
 * 获取指定月份的天数
 */
- (NSUInteger)daysInMonth:(NSUInteger)month;
+ (NSUInteger)daysInMonth:(NSDate *)date month:(NSUInteger)month;

/**
 * 获取当前月份的天数
 */
- (NSUInteger)daysInMonth;
+ (NSUInteger)daysInMonth:(NSDate *)date;

/**
 * 返回x分钟前/x小时前/昨天/x天前/x个月前/x年前
 */
- (NSString *)timeInfo;
+ (NSString *)timeInfoWithDate:(NSDate *)date;
+ (NSString *)timeInfoWithDateString:(NSString *)dateString;

/**
 * 分别获取yyyy-MM-dd/HH:mm:ss/yyyy-MM-dd HH:mm:ss格式的字符串
 */
- (NSString *)ymdFormat;
- (NSString *)hmsFormat;
- (NSString *)ymdHmsFormat;
+ (NSString *)ymdFormat;
+ (NSString *)hmsFormat;
+ (NSString *)ymdHmsFormat;



@end

//===============================================================================================================

@interface NSString (Date)
-(NSDate*)dateWithFormat:(NSString*)format;
@end

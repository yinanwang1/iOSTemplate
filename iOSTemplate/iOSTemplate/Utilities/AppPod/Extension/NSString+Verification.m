//
//  NSString+NSString_Verification.m
//  iOSTemplate
//
//  Created by ArthurWang on 17/1/12.
//  Copyright (c) 2017年 wang. All rights reserved.
//

#import "NSString+Verification.h"

@implementation NSString (Verification)

- (BOOL)isValidCellPhoneNumber
{
    NSMutableString *tempMStr = [[NSMutableString alloc] initWithString:self];
    NSString *numberStr = [tempMStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    numberStr = [numberStr compressBlank];
    NSString *regex = @"^[0-9]{11}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:numberStr];
}

- (BOOL)isValidPRCResidentIDCardNumber
{
    NSString *regex = @"^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([pred evaluateWithObject:self]) {
        int indexArray[17] = {7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2};
        int numbersArray[18] = {0};
        for (int i = 0; i < 17; i++) {
            numbersArray[i] = (int)([self characterAtIndex:i] - '0');
        }
        if ((char)[self characterAtIndex:17] == 'x' || (char)[self characterAtIndex:17] == 'X') {
            numbersArray[17] = 10;
        } else {
            numbersArray[17] = (int)([self characterAtIndex:17] - '0');
        }
        int sum = 0;
        for (int i = 0; i < 17; i++) {
            sum += (indexArray[i] * numbersArray[i]);
        }
        int lastDigit = sum % 11;
        int lastDigitsArray[11] = {1, 0, 10, 9, 8, 7, 6, 5, 4, 3, 2};
        if (lastDigitsArray[lastDigit] == numbersArray[17]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isValidNickname
{
    NSString *regex = @"^[a-zA-Z0-9_\u4e00-\u9fa5]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

- (BOOL)isValidEmailAddress
{
    NSString *regex = @"^([a-zA-Z0-9]+[_|\\-|\\.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\\-|\\.]?)*[a-zA-Z0-9]+(\\.[a-zA-Z]{2,3})+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}


+ (void)testNSStringVerification
{
    NSAssert([@"12011319820311881x" isValidPRCResidentIDCardNumber], @"验证身份证失败");
    NSAssert([@"12011319820311881X" isValidPRCResidentIDCardNumber], @"验证身份证失败");
    NSAssert(![@"120113198203118811" isValidPRCResidentIDCardNumber], @"验证身份证失败");
    NSAssert([@"a@b.com" isValidEmailAddress], @"验证email失败");
    NSAssert(![@"a@b.com." isValidEmailAddress], @"验证email失败");
    NSAssert([@"13585748212" isValidCellPhoneNumber], @"验证手机号失败");
    NSAssert(![@"23499999999" isValidCellPhoneNumber], @"验证手机号失败");
}

- (NSString*) trim
{
    return [self stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *) compressBlank
{
    return [self  stringByReplacingOccurrencesOfString:@"[ ]+" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, self.length)];
}

+ (NSString *)uppercaseRMBString:(double)value
{
    NSArray *lowerNumber = @[@"〇", @"一", @"二", @"三", @"四", @"五", @"六", @"七", @"八", @"九", @"十"];
    NSArray *upperNumber = @[@"零", @"壹", @"贰", @"叁", @"肆", @"伍", @"陆", @"柒", @"捌", @"玖", @"拾"];
    
    NSNumberFormatter *formatter =  [[NSNumberFormatter alloc] init];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh-Hant"]; // 繁体
    formatter.numberStyle = NSNumberFormatterSpellOutStyle;
    
//    NSString *amountString = [NSString stringWithFormat:@"%0.2f", value];
    NSString *amountString = [formatter stringFromNumber:[NSNumber numberWithDouble:value]];
    amountString = [amountString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"點〇"]];
    
    NSRange range = [amountString rangeOfString:@"點"];
    NSString *integerPart = amountString;
    NSString *decimalPart;
    
    if (range.length > 0 ) {
        integerPart = [amountString substringToIndex:range.location];
        decimalPart = [amountString substringFromIndex:range.location + 1];
    }
    
    NSInteger count = lowerNumber.count;
    for (int i = 0; i < count; i++) {
        integerPart = [integerPart stringByReplacingOccurrencesOfString:lowerNumber[i] withString:upperNumber[i]];
        decimalPart = [decimalPart stringByReplacingOccurrencesOfString:lowerNumber[i] withString:upperNumber[i]];
    }
    
    NSMutableString *rmbString = [NSMutableString stringWithString:integerPart];
    [rmbString appendString:@"元"];
    
    if (decimalPart.length > 0) {
        NSString *jiaoString = [decimalPart substringToIndex:1];
        [rmbString appendString:[NSString stringWithFormat:@"%@角", jiaoString]];
        
        if (decimalPart.length > 1) {
            NSString *centString = [decimalPart substringFromIndex:1];
            [rmbString appendString:[NSString stringWithFormat:@"%@分", centString]];
        }
    }
    else {
        [rmbString appendString:@"整"];
    }
    
    return [NSString stringWithString:rmbString];
}


// add '-' in phone number
- (NSString *)addSegmentPhoneNumber
{
    if (![self isValidCellPhoneNumber]) {
        return self;
    }
    
    NSString *firstSegmentStr = [self substringWithRange:NSMakeRange(0, 3)];
    NSString *secondSegmentStr = [self substringWithRange:NSMakeRange(3, 4)];
    NSString *thirdSegmentStr = [self substringWithRange:NSMakeRange(7, 4)];
    
    return [NSString stringWithFormat:@"%@-%@-%@", firstSegmentStr, secondSegmentStr, thirdSegmentStr];
}

- (BOOL)vaildChineseAndNumberAndABC
{
    NSString *regex = @"^[\u4e00-\u9fa5_a-zA-Z0-9]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
}

@end

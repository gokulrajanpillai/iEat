//
//  NSDate+DateCategory.m
//  iEat
//
//  Created by RAJAN on 5/16/16.
//  Copyright © 2016 RAJAN. All rights reserved.
//

#import "NSDate+DateCategory.h"

@implementation NSDateFormatter(FormatterWithFormat)

///Generate dateFormatter object with a given format
+ (NSDateFormatter *)dateFormatterWithFormat:(NSString *)format {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:format];
    
    return dateFormatter;
}

@end


@implementation NSDate (DateCategory)

///Generate date from UNIX timestamp
+ (NSDate *)dateFromUNIXTimeStamp:(NSString *)timeStamp WithFormat:(NSString *)format{
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[(NSString * )timeStamp doubleValue]];
    
    return [date dateFromString: [date stringFromDateWithFormat:format] WithFormat:format];

}

///Generate UNIX timestamp from date
- (NSString *)UNIXTimeStampString{
    
    return [NSString stringWithFormat:@"%.0f", [self timeIntervalSince1970]];
}

///Generate string from date for a given format
- (NSString *)stringFromDateWithFormat:(NSString *)format {
    
    return [[NSDateFormatter dateFormatterWithFormat:format] stringFromDate:self];
}

///Generate date from string for a given format
- (NSDate *)dateFromString:(NSString *)dateString WithFormat:(NSString *)format {

    return [[NSDateFormatter dateFormatterWithFormat:format] dateFromString: dateString];
}

@end


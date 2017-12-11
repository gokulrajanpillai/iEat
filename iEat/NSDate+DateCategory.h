//
//  NSDate+DateCategory.h
//  iEat
//
//  Created by RAJAN on 5/16/16.
//  Copyright © 2016 RAJAN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (DateCategory)

+ (NSDate *)dateFromUNIXTimeStamp:(NSString *)timeStamp WithFormat:(NSString *)format;

- (NSString *)UNIXTimeStampString;

- (NSDate *)dateFromString:(NSString *)dateString WithFormat:(NSString *)format;

- (NSString *)stringFromDateWithFormat:(NSString *)format;

@end

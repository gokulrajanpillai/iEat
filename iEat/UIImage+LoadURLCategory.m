//
//  UIImage+LoadURLCategory.m
//  iEat
//
//  Created by RAJAN on 5/17/16.
//  Copyright © 2016 RAJAN. All rights reserved.
//

#import "UIImage+LoadURLCategory.h"

@implementation UIImage (LoadURLCategory)

+ (void)loadImageFromURLString:(NSString *)url WithCompletion:(CompletionBlockWithImage)block {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        UIImage *img = [UIImage imageWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            block(img);
        });
    });
}

@end

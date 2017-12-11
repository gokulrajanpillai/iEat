//
//  UIImage+LoadURLCategory.h
//  iEat
//
//  Created by RAJAN on 5/17/16.
//  Copyright © 2016 RAJAN. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ CompletionBlockWithImage)(UIImage *);

@interface UIImage (LoadURLCategory)

+ (void)loadImageFromURLString:(NSString *)url WithCompletion:(CompletionBlockWithImage)block;

@end

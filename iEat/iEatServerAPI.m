//
//  iEatServerAPI.m
//  iEat
//
//  Created by RAJAN on 5/14/16.
//  Copyright © 2016 RAJAN. All rights reserved.
//

#import "iEatServerAPI.h"
#import <UIKit/UIKit.h>

#define API_KEY @"6835a3132ad9abaaf1590ecc4a62729f0adc8bdfcf14b0179fb62bc84dcf4015"

#define API_PARAM @"?api_key=" API_KEY

/// The server is no longer available
#define SERVER_URL @"http://ios.myserver.de"

//Category for appending API_KEY to the URL string directly
@implementation NSString(UrlString)

- (NSString *)appendUrlWithApiKey {

    return [NSString stringWithFormat:@"%@%@",self,API_PARAM];
}

@end

@interface iEatServerAPI()<NSURLConnectionDataDelegate>

@property (nonatomic, assign) RequestType reqType;

@property (nonatomic, assign) id<iEatServerAPIDelegate> delegate;

@end

@implementation iEatServerAPI

+ (iEatServerAPI *)sharedInstance {
    
    static iEatServerAPI *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[iEatServerAPI alloc] init];
    });
    
    return sharedInstance;
}

///To Get the list of all meals in the server database

- (void)getMealsWithDelegate:(id<iEatServerAPIDelegate>)delegate {
    
    self.reqType = RequestTypeGetAllMeals;
    
    self.delegate = delegate;
    
    NSString *url = [SERVER_URL stringByAppendingString:@"/meals"];
    
    NSMutableURLRequest *request =
    [NSMutableURLRequest requestWithURL:[NSURL
                                         URLWithString:[url appendUrlWithApiKey]]
                            cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                        timeoutInterval:10
     ];
    
    [request setHTTPMethod: @"GET"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error == nil) {
            [self.delegate responseReceivedForRequestType:self.reqType WithData:data];
        }
        else {
            NSLog(@"%@",[error description]);
        }
    }] resume];
}


///To Add a new meal to the server database

- (void)addMealWithDictionary:(NSDictionary *)dict {
    
    self.reqType = RequestTypeAddMeal;
    
    NSString *urlString = [[NSString stringWithFormat:@"%@/meals",SERVER_URL] appendUrlWithApiKey];
    
    [self updateServerDataWithUrlString:urlString WithDictionary:dict];
}

- (void)editMealWithDictionary:(NSDictionary *)dict {
    
    self.reqType = RequestTypeEditMeal;
    
    NSString *urlString = [[NSString stringWithFormat:@"%@/meals/%@",SERVER_URL,[dict valueForKey:@"meal_id"]] appendUrlWithApiKey];
    
    [self updateServerDataWithUrlString:urlString WithDictionary:dict];
}

- (void)updateServerDataWithUrlString:(NSString *)url WithDictionary:(NSDictionary *)dict {
    
    NSData *imageData = UIImageJPEGRepresentation((UIImage *)[dict valueForKey:@"meal_picture"],0.2);     //change Image to NSData
    
    if (imageData != nil)
    {
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:url]];
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"meal_title\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[dict valueForKey:@"meal_title"] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"meal_description\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[dict valueForKey:@"meal_description"] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"meal_day\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[dict valueForKey:@"meal_day"] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"meal_picture\"; filename=\"%@.jpg\"\r\n",[dict valueForKey:@"meal_title"]] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imageData]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [request setHTTPBody:body];
        
        NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [urlConnection start];
        
    }
}


- (void)deleteMealWithMealId:(NSString *)mealId
{
    self.reqType = RequestTypeDeleteMeal;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *urlString = [[NSString stringWithFormat:@"%@/meals/%@",SERVER_URL,mealId] appendUrlWithApiKey];
    
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"DELETE"];
 
    NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [urlConnection start];
}

#pragma mark - NSURLConnectionDataDelegate Methods

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    [self.delegate responseReceivedForRequestType:self.reqType WithData:nil];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
//    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",response);
//    NSLog(@"finish");
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Received Data: %@",returnString);
}


@end

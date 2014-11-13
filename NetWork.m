//
//  NetWork.m
//
//  Copyright (c) 2014年 apc. All rights reserved.
//

#import "NetWork.h"

@interface NetWork()
@property (nonatomic) NSMutableData *receivedData;
@property (nonatomic,assign) NSString *apiName;
@end

@implementation NetWork

/** use delegate **/
-(instancetype) initWithApiUrlForPost:(NSString*) apiUrl body:(NSString*) bodyStr apiName:(NSString*) apiName
{
    self.apiName = apiName;
    
    NSURL *url = [NSURL URLWithString:[apiUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLConnection *aConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (!aConnection) {
        NSLog(@"connection error.");
    }
    
    return self;
}

-(instancetype) initWithApiUrlForGet:(NSString*) apiUrl apiName:(NSString*) apiName
{
    self.apiName = apiName;
    
    NSURL *url = [NSURL URLWithString:[apiUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
    
    NSURLConnection *aConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (!aConnection) {
        NSLog(@"connection error.");
    }
    
    return self;
}

- (void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response {
    self.receivedData = [[NSMutableData alloc] init];
}

- (void) connection:(NSURLConnection *) connection didReceiveData:(NSData *)data {
    [self.receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError*)error
{
    NSLog(@"error=%@", [error description]);
    [self.delegate failedGetData:error apiName:self.apiName];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError *error = nil;
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:self.receivedData options:NSJSONReadingAllowFragments error:&error];
    
    if(error == nil) {
        [self.delegate didGetData:jsonObject apiName:self.apiName];
    } else {
        NSLog(@"%@",[error description]);
        [self.delegate didGetData:nil apiName:self.apiName];
    }
}
/** use delegate **/

/** use block**/
-(void) connectForGetWithUrl:(NSString*) apiUrl handler:(CallNetworkbackHandler) handler
{
    NSURL *url = [NSURL URLWithString:apiUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if(error == nil) {
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (handler) {
                    handler(jsonObject, error);
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (handler) {
                    handler(nil, error);
                }
            });
        }
        
    }];
}

-(void) connectForPostWithUrl:(NSString*) apiUrl body:(NSString*) bodyStr handler:(CallNetworkbackHandler) handler
{
    NSURL *url = [NSURL URLWithString:apiUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
    
    request.HTTPMethod = @"POST";
    request.HTTPBody = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if(error == nil) {
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (handler) {
                    handler(jsonObject, error);
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (handler) {
                    handler(nil, error);
                }
            });
        }
        
    }];
}
/** use block**/

@end

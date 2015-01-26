//
//  NetWork.h
//
//  Copyright (c) 2014年 apc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NetWorkDelegate <NSObject>
@optional
-(void) didGetData:(NSDictionary*) recevieMutableDictionary apiName:(NSString*) apiName;
-(void) failedGetData:(NSError*)error  apiName:(NSString*) apiName;
@end

typedef void (^CallNetworkbackHandler)(NSDictionary * resultDictonary, NSError *error);

@interface NetWork : NSObject<NSURLConnectionDataDelegate>

@property (nonatomic, weak) id <NetWorkDelegate> delegate;

-(instancetype) initWithApiUrlForPost:(NSString*) apiUrl body:(NSString*) bodyStr apiName:(NSString*) apiName;
-(instancetype) initWithApiUrlForGet:(NSString*) apiUrl apiName:(NSString*) apiName;
+(void) connectForGetWithUrl:(NSString*) apiUrl handler:(CallNetworkbackHandler) handler;
+(void) connectForPostWithUrl:(NSString*) apiUrl body:(NSString*) bodyStr handler:(CallNetworkbackHandler) handler;
+(void) urlSessionForGetWithUrl:(NSString*) apiUrl handler:(CallNetworkbackHandler) handler;
+(void) urlSessionForPostWithUrl:(NSString*) apiUrl body:(NSString*) bodyStr handler:(CallNetworkbackHandler) handler;

@end

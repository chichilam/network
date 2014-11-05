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

typedef void (^CallbackHandler)(NSDictionary * resultDictonary, NSError *error);

@interface NetWork : NSObject<NSURLConnectionDataDelegate>

@property (nonatomic, weak) id <NetWorkDelegate> delegate;

-(instancetype) initWithApiUrlForPost:(NSString*) apiUrl body:(NSString*) bodyStr apiName:(NSString*) apiName;
-(instancetype) initWithApiUrlForGet:(NSString*) apiUrl apiName:(NSString*) apiName;
-(void) connectWithUrl:(NSString*) apiUrl handler:(CallbackHandler) handler;

@end

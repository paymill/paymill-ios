//
//  PMError.h
//  PayMillSDK
//
//  Created by PayMill on 2/20/13.
//  Copyright (c) 2013 PayMill. All rights reserved.
//
#import <Foundation/Foundation.h>

/**
 Error type
 */
typedef NS_ENUM(NSInteger, PMErrorType){
	WRONG_PARMETERS,
	HTTP_CONNECTION,
	API,
	NOT_INIT,
	INTERNAL,
};
/**
 This is the error object that is returned in every unsuccessful asynchronous callback. There are several types of this error. A detail message may also exist.
 */
@interface PMError : NSObject
/**
  error type
 */
@property (nonatomic) PMErrorType type;
/**
 error message
 */
@property (nonatomic, strong) NSString* message;
/**
 Creates new PMError with a type and empty message.
 @param type error type
 @param message error message
 @return PMError successfully created object.
 */
+(PMError*) newPMErrorWithType:(PMErrorType)type message:(NSString*)message;
@end

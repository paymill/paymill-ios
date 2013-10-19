//
//  PMCreditCardTypeParser.h
//  VoucherMill
//
//  Created by Aleksandar Yalnazov on 09/01/13.
//  Copyright (c) 2013 Paymill. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PMCardCheckResult)
{
	VALID,
	NOT_YET_KNOWN,
	INVALID
};

@interface PMCreditCardCheck : NSObject

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *pattern;
@property (nonatomic, strong) NSString *subPatterns;
@property (nonatomic) BOOL luhn;
@property (nonatomic) int cvcMinLength;
@property (nonatomic) int cvcMaxLength;
@property (nonatomic, strong) NSArray *numLength;
@property (nonatomic) PMCardCheckResult result;
@end


@interface PMCreditCardTypeParser : NSObject
+(id)instance;
-(PMCreditCardCheck *)checkExpression:(NSString *)expression;
@property (nonatomic, strong) NSArray *ccChecks;
@property (nonatomic, strong) NSArray *expressionPatterns;
@property (nonatomic, strong) NSArray *expressionSubPatterns;
@property (nonatomic, strong) NSArray *cardTypes;
@end

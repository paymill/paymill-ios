//
//  PMCreditCardParser.m
//  VoucherMill
//
//  Created by Aleksandar Yalnazov on 10/16/13.
//  Copyright (c) 2013 Paymill. All rights reserved.
//

#import "PMCreditCardTypeParser.h"

@implementation PMCreditCardCheck
@synthesize subPatterns, pattern, cvcMaxLength, cvcMinLength, luhn, numLength, type, result, imageName;
@end

@implementation PMCreditCardTypeParser
@synthesize ccChecks, expressionPatterns, expressionSubPatterns, cardTypes;
static PMCreditCardTypeParser *sharedInstance;

+(id)instance
{
    //Singleton pattern
    //Static local predicate must be initialized to 0
    
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PMCreditCardTypeParser alloc] init];
    });
    
    return sharedInstance;
}

-(NSArray *)ccChecks {
	//numLength values must be initialized in ascend order!
	
	NSString* path = [[NSBundle mainBundle] pathForResource:@"CardsData"
													 ofType:@"plist"];
	NSDictionary* data = [[NSDictionary alloc] initWithContentsOfFile:path];
	NSArray* cards = [data objectForKey:@"Cards"];
	NSMutableArray* ccData = [NSMutableArray array];
	//loop over credit paymentType array and create the types conditionally
	for (NSString* cardType in cardTypes) {
		ccChecks = [NSMutableArray arrayWithCapacity:[cardTypes count]];
		NSDictionary* cc = [self findDataForCCName:cardType inCards:cards];
		if(cc){
			[ccData addObject:cc];
		}
	}
	NSMutableArray *checks = [NSMutableArray array];
	for(NSDictionary *ccc in ccData)
	{
		NSString *name = [ccc valueForKey:@"cardName"];
		PMCreditCardCheck *ccCheck = [[PMCreditCardCheck alloc]init];
		ccCheck.type = name;
		ccCheck.imageName = [ccc valueForKey:@"imageName"];
		NSString *pattern = [ccc valueForKey:@"pattern"];
		ccCheck.pattern = [self.expressionPatterns objectAtIndex:pattern.intValue];
		ccCheck.subPatterns = [self.expressionPatterns objectAtIndex:pattern.intValue];
		ccCheck.cvcMaxLength = [ccc valueForKey:@"cvcMaxLength"];
		ccCheck.cvcMinLength = [ccc valueForKey:@"cvcMinLength"];
		ccCheck.numLength = [ccc valueForKey:@"numLength"];
		ccCheck.luhn = [ccc valueForKey:@"luhn"];
		
		[checks addObject:ccCheck];
	}
	
	ccChecks = checks;
	return ccChecks;
}

-(NSArray *)expressionPatterns
{
	if(!expressionPatterns) {
		expressionPatterns = [NSArray arrayWithObjects:\
							  @"^3[47]", \
							  @"^(6011|622[126-925]|64[4-9]|65)", \
							  @"^62", \
							  @"^(30[0-5]|36|38)", \
							  @"^63[7-9]", \
							  @"^35([3-8][0-9]|2[8-9])", \
							  @"^(6704|6706|6771|6709)", \
							  @"^(5018|5020|5038|5893|6304|6331|6759|676[1-3]|6799|0604)", \
							  @"^(5[1-5])", \
							  @"^4", \
							  nil];
	}
	return expressionPatterns;
}

-(NSArray *)expressionSubPatterns {
	if(!expressionSubPatterns) {
		expressionSubPatterns = [NSArray arrayWithObjects: \
								 @"^4", \
								 @"^5(?![^1-5])", \
								 @"^5(?![^08])(0?(?![^123])(1?(?![^8])|2?(?![^0])|3?(?![^8]))|(?<![^5])8?(?![^9])(?<![^8])9?(?![^3]))|^6((?![^3])3?((?![^0])0?(?![^4])|(?![^3])(?<![^3])3?(?![^1]))|(?![^7])7((?![^5])5?(?![^9])|(?![^6])6?(?![^1-3])|(?![^9])(?<![^7])9(?![^9])))|^0(?![^6])6?(?![^0])0?(?![^4])", \
								 @"^3(?![^47])", \
								 @"^3(?![^5])5?((?![^2])2?(?![^89])|(?![^3-8])(?<![^5])[3-8]?)", \
								 @"^3((?![^68])|0(?![^0-5]))", \
								 @"^6((?![^5])|(?![^4])4(?![^4-9])|(?![^0])0?($|(?![^1])1(?![^1])))", \
								 @"^6(?![^2])", \
								 @"^6(?![^3])3?(?![^7-9])", \
								 @"^6(?![^7])7?(?![^07])(0?(?![^469])|(?<![^7])7?(?![^1]))", \
								 nil];
		
	}
	return expressionSubPatterns;
}

-(PMCreditCardCheck *)checkExpression:(NSString *)expression
{
	if(!expression || [expression isEqualToString:@""]) {
		PMCreditCardCheck *check = [[PMCreditCardCheck alloc]init];
		check.result = NOT_YET_KNOWN;
		return check;
	}
		
    for (PMCreditCardCheck *check in self.ccChecks)
    {
		if(check.pattern)
        {
			NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:check.pattern options:NSRegularExpressionCaseInsensitive error:nil];
			NSTextCheckingResult *result = [regex firstMatchInString:expression options:0 range:NSMakeRange(0, [expression length])];
			
			if(result.range.length) {
				check.result = VALID;
				return check;
			}
		}
    }
	
	for (PMCreditCardCheck *check in self.ccChecks) {
		if(check.subPatterns) {
			NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:check.subPatterns options:NSRegularExpressionCaseInsensitive error:nil];
			NSTextCheckingResult *result = [regex firstMatchInString:expression options:0 range:NSMakeRange(0, [expression length])];
			
			if(result.range.length) {
				check.result = NOT_YET_KNOWN;
				return check;
			}
			
		}
	}
	
	PMCreditCardCheck *check = [[PMCreditCardCheck alloc]init];
	check.result = INVALID;
	return check;
}

-(NSDictionary *)findDataForCCName:(NSString *)ccName inCards:(NSArray *)cards
{
	//find credit card data for credit card name
	for (NSDictionary* ccData in cards) {
		if([[ccData valueForKey:@"cardName"] isEqual:ccName]){
			return ccData;
		}
	}
	return nil;
}

@end

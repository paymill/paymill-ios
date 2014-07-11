//
//  PMPaymentDataValidator.m
//  VoucherMill
//
//  Created by gabi on 2/25/14.
//  Copyright (c) 2014 Paymill. All rights reserved.
//

#import "PMPaymentDataValidator.h"
#import "PMCreditCardTypeParser.h"
#import <PayMillSDK/PMError.h>
#import "PMUISupport.h"

static NSString* PMPaymentDataUIErrorDomain  = @"com.paymill.vouchermill";
static NSInteger PMPaymentDataUIErrorCode    = -10;

/**************************************/
#pragma mark - Class Extension
/**************************************/
@interface PMPaymentDataValidator ()

@property(nonatomic, strong) NSMutableSet* delegates;

@property (nonatomic, strong) PMCreditCardCheck* creditCardCheck;

@property (nonatomic, strong) NSString* accountHolderStr;
@property (nonatomic, strong) NSString* ibanStr;
@property (nonatomic, strong) NSString* cardNumberStr;
@property (nonatomic, strong) NSString* bicStr;
@property (nonatomic, strong) NSString* cvcStr;
@property (nonatomic, strong) NSString* expiryMonth;
@property (nonatomic, strong) NSString* expiryYear;

@end

/**************************************/
#pragma mark - Class Implementation
/**************************************/
@implementation PMPaymentDataValidator

/**************************************/
#pragma mark - Init
/**************************************/
- (id)init
{
    self = [super init];
    
    if ( nil != self ) {
        _delegates = [NSMutableSet new];
    }
    
    return self;
}

/**************************************/
#pragma mark - Delegates Logic
/**************************************/
- (void)registerDelegate:(id<PMPaymentDataValidatorUIRepresentationDelegate>)delegate
{
    NSValue* value = [NSValue valueWithPointer:(const void*) delegate];
    
    if ( ![self.delegates containsObject:value] ) {
        [self.delegates addObject:value];
    }
}

- (void)unregisterDelegate:(id<PMPaymentDataValidatorUIRepresentationDelegate>)delegate
{
    NSValue* value = [NSValue valueWithPointer:(const void*) delegate];
    
    if ( [self.delegates containsObject:value] ) {
        [self.delegates removeObject:value];
    }
}

- (void)updateCreditCardImageForImageName:(NSString*)imageName
{
    for ( NSValue* object in self.delegates ) {
        id<PMPaymentDataValidatorUIRepresentationDelegate> delegate = (id<PMPaymentDataValidatorUIRepresentationDelegate>)[object pointerValue];
        if ( [delegate respondsToSelector:@selector(paymentDataValidator:didRecognizeCCNumberWithImageName:)]) {
            [delegate paymentDataValidator:self didRecognizeCCNumberWithImageName:imageName];
        }
    }
}

- (void)updateActiveTextField:(UITextField*)textField
{
    for ( NSValue* object in self.delegates ) {
        id<PMPaymentDataValidatorUIRepresentationDelegate> delegate = (id<PMPaymentDataValidatorUIRepresentationDelegate>)[object pointerValue];
        if ( [delegate respondsToSelector:@selector(paymentDataValidator:didChangeActiveTextField:)]) {
            [delegate paymentDataValidator:self didChangeActiveTextField:textField];
        }
    }
}

- (void)checkDateExpiration
{
    BOOL isExpired = [self isExpiredMonth:[self.expiryMonth integerValue] andYear:[self.expiryYear integerValue]];
    
    for ( NSValue* object in self.delegates ) {
        id<PMPaymentDataValidatorUIRepresentationDelegate> delegate = (id<PMPaymentDataValidatorUIRepresentationDelegate>)[object pointerValue];
        if ( [delegate respondsToSelector:@selector(paymentDataValidator:didCheckDateExpiration:)]) {
            [delegate paymentDataValidator:self didCheckDateExpiration:isExpired];
        }
    }
}

- (NSString*)updateDateExpirationTextFieldValue:(UITextField*)textField
{
    NSString* dateValue = nil;
    for ( NSValue* object in self.delegates ) {
        id<PMPaymentDataValidatorUIRepresentationDelegate> delegate = (id<PMPaymentDataValidatorUIRepresentationDelegate>)[object pointerValue];
        if ( [delegate respondsToSelector:@selector(paymentDataValidator:didChangeDateExpiratioTextFieldValue:)]) {
            dateValue = [delegate paymentDataValidator:self didChangeDateExpiratioTextFieldValue:textField];
        }
    }
    
    return dateValue;
}


/**************************************/
#pragma mark - Public Methods
/**************************************/
- (void)validateObject
{
    NSError* error = nil;
    
    if ( self.paymentDataType == PMPaymentDataTypeCreditCard ) {
        [self validateCreditCardDataReturningError:&error];
    }
    else if ( self.paymentDataType == PMPaymentDataTypeDirectDebit ){
        [self validateDirectDebitDataReturningError:&error];
    }
    
    for ( NSValue* object in self.delegates ) {
        id<PMPaymentDataValidatorUIRepresentationDelegate> delegate = (id<PMPaymentDataValidatorUIRepresentationDelegate>)[object pointerValue];
        if ( [delegate respondsToSelector:@selector(paymentDataValidator:didValidateObjectWithError:)]) {
            [delegate paymentDataValidator:self didValidateObjectWithError:error];
        }
    }
}

- (NSString*)dateString
{
    if ( nil == self.expiryYear || nil == self.expiryMonth ) {
        return nil;
    }
    
    return [NSString stringWithFormat:@"%@/%@", self.expiryMonth, self.expiryYear];
}

/******************************************/
#pragma mark - Credit Card Data Validation
/******************************************/
- (BOOL)validateName:(id *)ioValue error:(NSError **)outError
{
    if ( *ioValue == nil ) {
        return [self handleValidationErrorForMessage:kPMEnterNameMessage error:outError];
    }
    
    return YES;
}

- (BOOL)validateBic:(id *)ioValue error:(NSError **)outError
{
    if ( *ioValue == nil ) {
        return [self handleValidationErrorForMessage:kPMIncorrectBICMessage error:outError];
    }
    
    NSString *ioValueString = (NSString *) *ioValue;
    return ( [ioValueString length] == 7 || [ioValueString length] == 11 );
}

- (BOOL)validateIban:(id *)ioValue error:(NSError **)outError
{
    int IBAN_MIN_SIZE = 15;
	int IBAN_MAX_SIZE = 34;
    
	long IBAN_MAX     = 999999999;
	long IBAN_MODULUS = 97;

    if ( *ioValue == nil ) {
        return [self handleValidationErrorForMessage:kPMIncorrectIBANMessage error:outError];
    }
    
    NSString* ioValueString = (NSString *) *ioValue;
    NSString* trimmed = [ioValueString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //Check that the total IBAN length is correct. If not, the IBAN is invalid.
    if ( [trimmed length] < IBAN_MIN_SIZE || [trimmed length] > IBAN_MAX_SIZE) {
        return [self handleValidationErrorForMessage:kPMIncorrectIBANMessage error:outError];
    }
    
    //Move the initial four characters to the end of the string.
    NSString* reformat = [NSString stringWithFormat:@"%@%@", [trimmed substringFromIndex:4], [trimmed substringWithRange:NSMakeRange(0, 4)]];
    
    /*
     To validate the checksum, we must convert the string to an integer.
     Replace each letter in the string with two digits, thereby expanding the string, where A = 10, B = 11, ..., Z = 35
     */
    long total = 0;
    for ( int i = 0; i < [reformat length]; i++ ) {
        unichar charValue = [reformat characterAtIndex:i];
        
        //Expects string to contain digits and/or uppercase letters
        if ( !isdigit(charValue) && !isupper(charValue) ) {
            return [self handleValidationErrorForMessage:kPMIncorrectIBANMessage error:outError];
        }
        
        //We need to get the int value that the specified Unicode character represents.
        if ( isdigit(charValue) ) {
            total = (10 * total + digittoint(charValue));
        }
        
        /*
         There is no direct way to get this value, when the character is not numeric ( '0' - '9'), so we make calculation to provide the relevant unichar value, as a value between 10 and 35
         */
        else if ( charValue >= 'A' && charValue <= 'Z' ) {
            total = ( 100 * total + (charValue - 'A' + 10) );
        }
        
        if ( total > IBAN_MAX ) {
            total = (total % IBAN_MODULUS);
        }
    }
    
    return (total % IBAN_MODULUS) == 1;
}

- (BOOL)validateCCNumber:(id *)ioValue error:(NSError **)outError
{
    if ( *ioValue == nil ) {
        return [self handleValidationErrorForMessage:kPMIncorrectCCNumberMessage error:outError];
    }
    
    NSError *regexError = nil;
    NSString *ioValueString = (NSString *) *ioValue;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\\s+|-]"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&regexError];
    
    NSString *rawNumber = [regex stringByReplacingMatchesInString:ioValueString options:0 range:NSMakeRange(0, [ioValueString length]) withTemplate:@""];
    
    if (rawNumber == nil || rawNumber.length < 10 || rawNumber.length > 19 || ![self luhnCheck:rawNumber]) {
        return [self handleValidationErrorForMessage:kPMIncorrectCCNumberMessage error:outError];
    }
    
    return YES;
}

- (BOOL)validateDataExpirationWithError:(NSError **)outError
{
    if ( ( nil == self.expiryYear ) || ( nil == self.expiryMonth ) ) {
        return [self handleValidationErrorForMessage:kPMIncorrectExpDateMessage error:outError];
    }
    
    if ( ( nil != self.expiryMonth ) && [self isExpiredMonth:[self.expiryMonth integerValue] andYear:[self.expiryYear integerValue]]) {
        return [self handleValidationErrorForMessage:kPMIncorrectExpDateMessage error:outError];
    }
    
    return YES;
}

- (BOOL)validateCvc:(id *)ioValue error:(NSError **)outError
{
    if ( *ioValue == nil ) {
        return [self handleValidationErrorForMessage:kPMIncorrectCVCMessage error:outError];
    }

    NSString *ioValueString = [(NSString *) *ioValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *cardType = self.creditCardCheck.type;
    
    BOOL validLenghtForUnrecognizedCardType = (cardType == nil && [ioValueString length] >= 3 && [ioValueString length] <= 4);
    BOOL validLenghtForAmericanExpCardType = [cardType isEqualToString:kPMTypeAmericanExp] && [ioValueString length] == 4;
    BOOL validLenghtForOtherCardType = ![cardType isEqualToString:kPMTypeAmericanExp] && [ioValueString length] == 3;
    
    BOOL validLength = ( validLenghtForUnrecognizedCardType || validLenghtForAmericanExpCardType || validLenghtForOtherCardType );
    
    if  (!validLength ) {
        return [self handleValidationErrorForMessage:kPMIncorrectCVCMessage error:outError];
    }
    
    return YES;
}

- (BOOL)handleValidationErrorForMessage:(NSString*)message error:(NSError **)outError
{
    if ( outError != nil ) {
        *outError = [self errorWithMessage:message];
    }
    
    return NO;
}

- (NSError*)errorWithMessage:(NSString*)message
{
	NSDictionary* userInfoDict = nil;
    
	if ( nil != message ) {
		userInfoDict = @{ NSLocalizedDescriptionKey : message};
	}
    
    return [[NSError alloc] initWithDomain:PMPaymentDataUIErrorDomain
                                      code:PMPaymentDataUIErrorCode
                                  userInfo:userInfoDict];
}

- (BOOL)validateCreditCardDataReturningError:(NSError **)outError
{
    NSString* cardNumber = self.cardNumberStr;
    NSString* cvc = self.cvcStr;
    NSString* accountHolder = self.accountHolderStr;
    
    return  [self validateName:&accountHolder error:outError] &&
            [self validateCCNumber:&cardNumber error:outError] &&
            [self validateDataExpirationWithError:outError] &&
            [self validateCvc:&cvc error:outError];
}

- (BOOL)validateDirectDebitDataReturningError:(NSError **)outError
{
    NSString* accountHolder = self.accountHolderStr;
    NSString* iban = self.ibanStr;
    NSString* bic = self.bicStr;
    
    return  [self validateName:&accountHolder error:outError] &&
            [self validateIban:&iban error:outError] &&
            [self validateBic:&bic error:outError];
}

/*******************************************/
#pragma mark - CC Number Validation Methods
/*******************************************/
- (void)didRecognizeCCNumber:(NSString *)ccnumberStr inTextField:(UITextField *)textField
{
    [self updateCreditCardImageForImageName:self.creditCardCheck.imageName];
    textField.textColor = [UIColor darkGrayColor];
    
    for (NSNumber *ln in self.creditCardCheck.numLength)
    {
        if(ccnumberStr.length == ln.integerValue)
        {
            if([self luhnCheck:ccnumberStr]){
                textField.textColor = [UIColor darkGrayColor];
                [self updateCreditCardImageForImageName:self.creditCardCheck.imageName];
			}
            else {
                textField.textColor = [UIColor redColor];
                [self updateCreditCardImageForImageName:nil];
			}
            
            break;
        }
    }
}

- (BOOL)isExpiredMonth:(NSInteger)month andYear:(NSInteger)year
{
    NSDate* now = [NSDate date];
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents* components = [[NSDateComponents alloc] init];
    [components setYear:year + 2000];
    // Cards expire at end of month
    [components setMonth:month+1];
    [components setDay:1];
    NSDate *expiryDate = [calendar dateFromComponents:components];
    return ([expiryDate compare:now] == NSOrderedAscending);
}

- (BOOL)luhnCheck:(NSString *)number
{
    BOOL isOdd = true;
    NSInteger sum = 0;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    for ( NSInteger index = [number length] - 1; index >= 0; index-- ) {
        NSString *digit = [number substringWithRange:NSMakeRange(index, 1)];
        NSNumber *digitNumber = [numberFormatter numberFromString:digit];
        if ( digitNumber == nil ) {
            return NO;
        }
        
        NSInteger digitInteger = [digitNumber intValue];
        isOdd = !isOdd;
        if ( isOdd ) {
            digitInteger *= 2;
        }
        
        if ( digitInteger > 9 ) {
            digitInteger -= 9;
        }
        
        sum += digitInteger;
    }
    
    if ( sum % 10 == 0 ) {
        return YES;
    }
    else {
        return NO;
    }
}

- (NSString *)stringByGrouping:(NSString *)string By:(PMCreditCardCheck *)ccCheck
{
    NSString *resstr = @"";
    
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if( string.length <=4 ) {
        return string;
    }
    
    int i = 0;
    int step = 4;
    for ( i = 0; i+step < string.length; i += step ) {
        if (self.creditCardCheck.result == VALID && (((NSNumber *)[self.creditCardCheck.numLength objectAtIndex:0]).intValue == 15 || ((NSNumber *)[self.creditCardCheck.numLength objectAtIndex:0]).intValue == 14))
        {
            if( i == 4 ) {
                step = (int)(((string.length - i) < 6) ? string.length - i : 6);
            }
            if( i == 10 ) {
                step = (int)(string.length - i);
            }
        }
        
        NSRange r = {i, step};
        
        resstr = [resstr stringByAppendingString:[string substringWithRange:r]];
        resstr = [resstr stringByAppendingString:@" "];
    }
    
    NSRange r = {i, string.length-i};
    resstr = [resstr stringByAppendingString:[string substringWithRange:r]];
    
    resstr = [resstr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return resstr;
}

/******************************************/
#pragma mark - UITextFieldDelegate Methods
/******************************************/
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if( [string isEqualToString:@""] ) {
		//[self updateCreditCardImageForImageName:nil];
        return YES;
    }

    NSString* _newStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSCharacterSet* nonNumberSet = [NSCharacterSet decimalDigitCharacterSet];
    
    if( textField.tag == PMTextFieldTypeIBANNumber ) {
        if ( [_newStr length] > 34 ) {
            return NO;
        }
    }
    else if ( textField.tag == PMTextFieldTypeBIC ) {
        if ( [_newStr length] > 11 ) {
            return NO;
        }
    }
    else if ( textField.tag == PMTextFieldTypeCardAccountHolder || textField.tag == PMTextFieldTypeAccountHolder ) {
        return ( [string stringByTrimmingCharactersInSet:nonNumberSet].length > 0 ) ;
    }
    else if ( textField.tag == PMTextFieldTypeCardNumber ) {
        if ( [string stringByTrimmingCharactersInSet:nonNumberSet].length > 0 ) {
            return NO;
        }
        
        if ( range.location > 256) {
            range.location = 0;
        }
        
        NSString* newStr = [_newStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        self.creditCardCheck = [[PMCreditCardTypeParser instance] checkExpression:newStr];
        
        if( self.creditCardCheck.result == VALID ) {
            int lastLength = [(NSNumber *)[self.creditCardCheck.numLength lastObject] intValue];
            if( newStr.length > lastLength ) {
                textField.text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                if ( range.location < 6 ) {
                    NSString *msg = [NSString stringWithFormat:@"%@ %@", kPMLongCCNumberMessage, self.creditCardCheck.type];
                    [PMUISupport showAlertWithMessage:msg];
                }
                return NO;
            }
            
            [self didRecognizeCCNumber:newStr inTextField:textField];
        }
        else if( self.creditCardCheck.result == INVALID ) {
            textField.textColor = [UIColor redColor];
            [self updateCreditCardImageForImageName:nil];
        }
        else if( self.creditCardCheck.result == NOT_YET_KNOWN ) {
            [self updateCreditCardImageForImageName:nil];
            textField.textColor = [UIColor darkGrayColor];
        }
        
        // Get the selected text range
        UITextRange *selectedRange = [textField selectedTextRange];
        
        // Calculate the existing position, relative to the end of the field (will be a - number)
        int pos = (int)[textField offsetFromPosition:textField.endOfDocument toPosition:selectedRange.start];
        
        int spaceNumberBefore = (int)(textField.text.length - [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length);
        textField.text = [self stringByGrouping:_newStr By:self.creditCardCheck];
        
        int spaceNumberAfter = (int)(textField.text.length - [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length);
        int spaceNumberCorrection = spaceNumberBefore - spaceNumberAfter;
        if (spaceNumberCorrection && pos)// && -pos >= textField.text.length)
        {
            pos += spaceNumberCorrection;
        }
        
        if ( range.length > string.length/* && string.length > */ && range.length > 1 ) {
            pos += range.length;
        }
        
        if( (range.location + string.length) < textField.text.length && string.length > 0 ) {
            NSString *sstr = [textField.text substringWithRange:(NSRange){range.location, string.length}];
            int spnum = (int)(sstr.length - [sstr stringByReplacingOccurrencesOfString:@" " withString:@""].length);
            pos += spnum;
        }
        
        if ( pos >= 0 ) {
            pos = 0;
        }
        if ( -pos >= textField.text.length ) {
            pos = -(int)textField.text.length;
        }
        
        if ( (range.location + range.length) < textField.text.length ) {
            if( [[textField.text substringWithRange:range] isEqualToString:@" "] ) {
                pos --;
            }
        }
        
        UITextPosition *newPos = [textField positionFromPosition:textField.endOfDocument offset:pos];
        
        // Reselect the range, to move the cursor to that position
        textField.selectedTextRange = [textField textRangeFromPosition:newPos toPosition:newPos];
        
        return NO;
    }
    else if( textField.tag == PMTextFieldTypeCVC && self.creditCardCheck.result == VALID ) {
        NSString *newStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        if( [newStr length] < self.creditCardCheck.cvcMinLength ) {
            textField.textColor = [UIColor orangeColor];
        }
        else {
            textField.textColor = [UIColor darkGrayColor];
        }
        
        if( [newStr length] > self.creditCardCheck.cvcMaxLength ) {
            return NO;
        }
        
        NSCharacterSet* numberSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        return ( [string stringByTrimmingCharactersInSet:numberSet].length > 0 || [string isEqualToString:@""] );
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self updateActiveTextField:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch ( textField.tag ) {
     case PMTextFieldTypeAccountHolder:
            self.accountHolderStr = textField.text;
            break;
     case PMTextFieldTypeCardAccountHolder:
            self.accountHolderStr = textField.text;
            break;
     case PMTextFieldTypeIBANNumber:
            self.ibanStr = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            break;
     case PMTextFieldTypeCardNumber:
            self.cardNumberStr = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            break;
     case PMTextFieldTypeBIC:
            self.bicStr = textField.text;
            break;
     case PMTextFieldTypeCVC:
            self.cvcStr = textField.text;
            break;
     case PMTextFieldTypeExpDate:
            [self setExpirationDateComponents:[self updateDateExpirationTextFieldValue:textField]];
            break;
     default:
            break;
     }
}

/**************************************/
#pragma mark - Helper Methods
/**************************************/
- (void)setExpirationDateComponents:(NSString*)dateString
{
    NSArray* components = [dateString componentsSeparatedByString:@"/"];
    if ( [components count] == 2 ) {
        self.expiryMonth = [components objectAtIndex:0];
        self.expiryYear  = [components objectAtIndex:1];
        
        [self checkDateExpiration];
    }
}

@end

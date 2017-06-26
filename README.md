![PAYMILL icon](https://static.paymill.com/r/335f99eb3914d517bf392beb1adaf7cccef786b6/img/logo-download_Light.png)
# PAYMILL iOS/MacOS SDK

The iOS/MacOS SDK provides a flexible and easy to integrate payment solution for your iOS/MacOS applications.

## Sample App for iOS

View our open source sample / demo app [VoucherMill](/samples/vouchermill). 

## Tutorial

In the [Honey Store tutorial](https://github.com/paymill/paymill-example-ios-parse-honeystore) we show you how to use the iOS SDK together with your backend, enabling returning (1-click) payments. In addition, we integrated the free [card.io](https://www.card.io/) library for card scanning.

## Getting started

- Start with the [SDK guide](https://www.paymill.com/en-gb/documentation-3/reference/mobile-sdk/).
- Install the latest release.
- If you want to create transaction and preauthorizations directly from within your app, [install](https://paymill.com/mobile-app-install/) the PAYMILL mobile app.
- Check the sample / demo app [VoucherMill](/samples/vouchermill) for a showcase and stylable payment screens.
- Check the [full API documentation](http://paymill.github.io/paymill-ios/docs/sdk/).

## Requirements

iOS 6.0 or later / OS X 10.6 or later.

## Installation

- Xcode users add 'PayMillSDK' folder to their project.
- CocoaPods  users add this dependency to their `Podfile`:
```
  pod 'PayMillSDK',  '~> 2.2.0'
```

*In cases Cocoapods central repository is not available, you can add folowing line to your `Podfile`:*
```
pod 'PayMillSDK', :git=>'https://github.com/paymill/paymill-ios.git', :branch=>'master', :tag=>'2.2.0'
```

## Working with the SDK


### PMPayment, PMParams and PMFactory


A [PMPayment](http://paymill.github.io/paymill-ios/docs/sdk/Classes/PMPayment.html) object contains the credit card or bank account information of a customer. A [PMPaymentParams](http://paymill.github.io/paymill-ios/docs/sdk/Classes/PMPaymentParams.html) object contains the parameters of a payment - amount, currency, description. Both must always be created with the [PMFactory](http://paymill.github.io/paymill-ios/docs/sdk/Classes/PMFactory.html) class.

### Generate a token

Create [PMPayment](http://paymill.github.io/paymill-ios/docs/sdk/Classes/PMPayment.html)  and [PMPaymentParams](http://paymill.github.io/paymill-ios/docs/sdk/Classes/PMPaymentParams.html) and call [PMManager generateTokenWithMethod](http://paymill.github.io/paymill-ios/docs/sdk/Classes/PMManager.html#//api/name/generateTokenWithPublicKey:testMode:method:parameters:success:failure:) with your PAYMILL public key and mode.

```objective-c
	NSError *error;
	PMPaymentParams *params;
	id paymentMethod = [PMFactory genCardPaymentWithAccHolder:@"Max Musterman" 
	cardNumber:@"4711100000000000" expiryMonth:@"12" expiryYear:@"2014" 
	verification:@"333" error:&error];
	
	if(!error) {
		params = [PMFactory genPaymentParamsWithCurrency:@"EUR" amount:100 
		description:@"Description" error:&error];
	}
	
	if(!error) {
	    //generate token with PAYMILL public key 
		[PMManager generateTokenWithPublicKey:myPublicKey testMode:YES 
		method:paymentMethod parameters:params
		success:^(NSString *token) {
			//token successfully created
		}
		failure:^(NSError *error) {
			//token generation failed
		}];
	}   

```
### Create a transaction

To create transactions and preauthorizations directly from the SDK you first need to install the Mobile App. In the code you will have to initialize the SDK, by calling [PMManger initWithTestMode](http://paymill.github.io/paymill-ios/docs/sdk/Classes/PMManager.html#//api/name/initWithTestMode:merchantPublicKey:newDeviceId:init:) method with your PAYMILL public key and mode.

```objective-c
 //init with PAYMILL public key  
 [PMManager initWithTestMode:YES merchantPublicKey:myPublicKey newDeviceId:nil init:^(BOOL success, NSError *error) {  
        if(success) {  
            // init successfull   
            // start using the SDK  
    }  
    }];
    
 NSError *error;  
 PMPaymentParams *params;  
 id paymentMethod = [PMFactory genCardPaymentWithAccHolder:@"Max Musterman" cardNumber:@"4711100000000000" expiryMonth:@"12" expiryYear:@"2014"  
 verification:@"333" error:&error];  

 if(!error) {  
     params = [PMFactory genPaymentParamsWithCurrency:@"EUR" amount:100 description:@"Description" error:&error];  
 }
 
 if(!error) {  
     [PMManager transactionWithMethod:paymentMethod parameters:params consumable:TRUE success:^(PMTransaction *transaction) {  
         // transaction successfully created  
     }  
     failure:^(NSError *error) {  
        // transaction creation failed  
     }];  
 }     

```


## Release notes

###2.2.0
+ iOS10.3 supoort added

###2.1.1
* Bug fixes

###2.1.0
+ Added new methods to create transactions and preauthorizations with a payment object.
+ Added a Safe Store to securely save payment objects with a user password.

###2.0.3
* Bug fixes

###2.0.2
* Mandatory changes in infrastructure
* Bug fixes

###2.0.1
+ MacOS Support
* Bug fixes

### 2.0.0
+ Added new method to generate Payments using IBAN and BIC in the [PMFactory](http://paymill.github.io/paymill-ios/docs/sdk/Classes/PMFactory.html).
+ Added new methods to generate token without amount and currency in the
[PMFactory](http://paymill.github.io/paymill-ios/docs/sdk/Classes/PMManager.html).
* All failure callbacks are now returning NSError instead PMError. Check PMError.h to see returned error codes. 
* Improved error handling. BRIDGE error type added in PMError. You can use this to give the user concrete information, why his card is rejected.
* ARM 64 support

### 1.0.3

* PMErrorType documented
* Bug fixes

### 1.0.2

* Bridge error response fixed
* Credit card holder issue fixed
* Appledoc improved


### 1.0.1
* Typos in headers and appledoc fixed
* Linkage issue fixed

### 1.0
+ First live release.
+ Added the possiblity to generate tokens without initializing the SDK. The method can be used exactly like the JS-Bridge and does not require extra activation for mobile.
+ Added getVersion for the SDK.
* Bug fixes

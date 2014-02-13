![PAYMILL icon](https://static.paymill.com/r/335f99eb3914d517bf392beb1adaf7cccef786b6/img/logo-download_Light.png)
# PAYMILL iOS SDK

The iOS SDK provides a flexible and easy to integrate payment solution for your iOS applications.

## Sample App


<a href="https://itunes.apple.com/us/app/vouchermill/id757789501">
  <img alt="Get it on the App Store"
       src="https://devimages.apple.com.edgekey.net/app-store/marketing/guidelines/images/app-store-icon.png" />
</a>

Our open source sample / demo app [VoucherMill](/samples/vouchermill) is available for download on the App Store. 
 
## Getting started

- Start with the [SDK guide](https://www.paymill.com/en-gb/documentation-3/reference/mobile-sdk/).
- Install the latest release.
- If you want to create transaction and preauthorizations directly from within your app, [install](https://paymill.com/mobile-app-install/) the PAYMILL mobile app.
- Check the sample / demo app [VoucherMill](/samples/vouchermill) for a showcase and stylable payment screens.
- Check the [full API documentation](http://paymill.github.io/paymill-ios/docs/sdk/).

## Requirements

iOS 5.0 or later.

## Installation

- Xcode users add 'PayMillSDK' folder to their project.
- CocoaPods  users add this dependency to their `Podfile`:
```
  pod 'PayMillSDK',  '~> 1.1.0'
```

## Working with the SDK

### PMPayment, PMParams and PMFactory


A [PMPayment](http://paymill.github.io/paymill-ios/docs/sdk/Classes/PMPayment.html) object contains the credit card or bank account information of a customer. A [PMPaymentParams](http://paymill.github.io/paymill-ios/docs/sdk/Classes/PMPaymentParams.html) object contains the parameters of a payment - amount, currency, description. Both must always be created with the [PMFactory](http://paymill.github.io/paymill-ios/docs/sdk/Classes/PMFactory.html) class.

### Generate a token

Create [PMPayment](http://paymill.github.io/paymill-ios/docs/sdk/Classes/PMPayment.html)  and [PMPaymentParams](http://paymill.github.io/paymill-ios/docs/sdk/Classes/PMPaymentParams.html), add listeners and call [PMManager generateTokenWithMethod](http://paymill.github.io/paymill-ios/docs/sdk/Classes/PMManager.html#//api/name/generateTokenWithPublicKey:testMode:method:parameters:success:failure:) with your PAYMILL public key and mode.

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
     [PMManager generateTokenWithMethod:paymentMethod parameters:params success:^(NSString *token) {  
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

### 1.1.0
+ Added new method to generate Payments using IBAN and BIC in the [PMFactory](http://paymill.github.io/paymill-ios/docs/sdk/Classes/PMFactory.html).
+ Added new methods to generate token without amount and currency in the
[PMFactory](http://paymill.github.io/paymill-ios/docs/sdk/Classes/PMManager.html).
*All failure callbacks are now returning NSError instead PMError. Check PMError.h to see returned error codes. 
* Improved error handling and added additional BRIDGE error type in PMError. You can use this to give the user conrecte information, why his card is rejected.

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

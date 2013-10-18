![PAYMILL icon](https://static.paymill.com/r/335f99eb3914d517bf392beb1adaf7cccef786b6/img/logo-download_Light.png)
# PAYMILL iOS SDK

The iOS SDK provides a flexible and easy to integrate payment solution for your iOS applications.

## Sample App


<a href="https://itunes.apple.com/us/app/vouchermill">
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

- Xcode users add 'PayMillSDK' folder to your project.
- Cocopods users add this dependency to their `Podfile`:
```
  pod 'PayMillSDK',  '~> 1.1.4'
```

## Working with the SDK

### PMMethod, PMParams and PMFactory


A [PMPaymentMethod](http://paymill.github.io/paymill-android/docs/sdk/reference/com/paymill/android/factory/PMPaymentMethod.html) object contains the credit card or bank account information of a customer. A [PMPaymentParams](http://paymill.github.io/paymill-android/docs/sdk/reference/com/paymill/android/factory/PMPaymentParams.html) object contains the parameters of a payment - amount, currency, description. Both must always be created with the [PMFactory](http://paymill.github.io/paymill-android/docs/sdk/reference/com/paymill/android/factory/PMFactory.html)class.

### Generate a token

Create [PMPaymentMethod](http://paymill.github.io/paymill-android/docs/sdk/reference/com/paymill/android/factory/PMPaymentMethod.html) and [PMPaymentParams](http://paymill.github.io/paymill-android/docs/sdk/reference/com/paymill/android/factory/PMPaymentParams.html), add listeners and call [PMManager generateTokenWithMethod:parameters:success:failure:](http://paymill.github.io/paymill-android/docs/sdk/reference/com/paymill/android/service/PMManager.html#generateToken%28android.content.Context,%20com.paymill.android.factory.PMPaymentMethod,%20com.paymill.android.factory.PMPaymentParams,%20com.paymill.android.service.PMService.ServiceMode,%20java.lang.String%29) with your PAYMILL public key and mode.

``` 
 //init with PAYMILL public key  
 [PMManager initWithTestMode:YES merchantPublicKey:myPublicKey newDeviceId:nil init:^(BOOL success, PMError *error) {  
        if(success) {  
            // init successfull   
            // start using the SDK  
    }  
    }];
    
 PMError *error;  
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
     failure:^(PMError *error) {  
          //token generation failed       
     }];  
 }   

```
### Create a transaction

To create transactions and preauthorizations directly from the SDK you first need to install the Mobile App. In the code you will have to initialize the SDK, by calling [PMManger initWithTestMode:merchantPublicKey:newDeviceId:init:](http://paymill.github.io/paymill-android/docs/sdk//reference/com/paymill/android/service/PMManager.html#init(android.content.Context, com.paymill.android.service.PMService.ServiceMode, java.lang.String, com.paymill.android.listener.PMBackgroundListener, java.lang.String) method with your PAYMILL public key and mode.

``` 
 //init with PAYMILL public key  
 [PMManager initWithTestMode:YES merchantPublicKey:myPublicKey newDeviceId:nil init:^(BOOL success, PMError *error) {  
        if(success) {  
            // init successfull   
            // start using the SDK  
    }  
    }];
    
 PMError *error;  
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
     failure:^(PMError *error) {  
        // transaction creation failed  
     }];  
 }     

```


## Release notes

### 1.0
+ First live release.
+ Added the possiblity to generate tokens without initializing the SDK. The method can be used exactly like the JS-Bridge and does not require extra activation for mobile.
+ Added getVersion for the SDK.
* Bug fixes

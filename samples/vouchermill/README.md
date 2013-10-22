# VoucherMill
The PAYMILL iOS SDK Sample / Demo App

<a href="https://itunes.apple.com/us/app/vouchermill">
  <img alt="Get it on the App Store"
       src="https://devimages.apple.com.edgekey.net/app-store/marketing/guidelines/images/app-store-icon.png" />
</a>

## Using the payment screens


### Installation


To use the payment screens you need to copy the whole `PaymentScreens` directory into your project.

You should make sure that all included images are added to your project's `Bundle Resources`.


### Styling the payment screens
If you like the layout of the payment screens and you simply want to change the colors, you can set them using the [PMStyle](http://paymill.github.io/paymill-ios/docs/sdk/Classes/PMStyle.html) class.

### Work with the Payment View Controller


API Docs for the Payment View Controller are available [here](http://paymill.github.io/paymill-ios/docs/sdk/) .

- Create the `PMPaymentParams` object that describes the amount, currency and description. Note, that you need to specify one, even if only generate a token.

```
PMError *error;
PMPaymentParams *pmParams = [PMFactory genPaymentParamsWithCurrency:@"EUR" amount:100 description:@"Description" error:&error];  
```

- Create and configure a [PMSettings](http://paymill.github.io/paymill-ios/docs/sdk/Classes/PMSettings.html) object.

```
//set payment view settings
PMSettings pmSettings= [[PMSettings alloc] init];
pmSettings.paymentType = TOKEN;
pmSettings.cardTypes = [NSArray arrayWithObjects:@"American Express", @"Visa", nil];//switch on American Expres and Visa
pmSettings.directDebitCountry = @"DE"; //switch on direct debit for Germany
pmSettings.isTestMode = YES;
pmSettings.consumable = YES;
```
- Call the [PMPaymentViewController](http://paymill.github.io/paymill-ios/docs/sdk/Classes/PMPaymentViewController.html) designated initializer to create it.

```
id paymentViewController = [PMPaymentViewController alloc] initWithParams:pmParams publicKey:publicKey settings:pmSetings style:pmStyle 
			success:^(id) {
			//handle success
			} failure:^(PMError *) {
			//handle error
			}];
```
- Push or present the view controller modally. 


Complete example:

```
-(void)test {
   //create payment params	 
   PMError *error;
   PMPaymentParams *pmParams = [PMFactory genPaymentParamsWithCurrency:@"EUR" amount:100 description:@"Description" error:&error];
   //create payment settings
   PMSettings pmSettings= [[PMSettings alloc] init];
   pmSettings.paymentType = TOKEN;
   pmSettings.cardTypes = [NSArray arrayWithObjects:@"American Express", @"Visa", nil];//switch on American Expres and Visa
   pmSettings.directDebitCountry = @"DE"; //switch on direct debit for Germany
   pmSettings.isTestMode = YES;
   pmSettings.consumable = YES;
   //create the payment view controller
   id paymentViewController = [PMPaymentViewController alloc] initWithParams:pmParams publicKey:publicKey settings:pmSetings style:pmStyle 
			success:^(id resObject) {
			   //handle success
			   //since the payment type set in the settings is TOKEN, we expect a NSString to come back from PAYMILL
		           token =  (NSString*)resObject;		
			} failure:^(PMError *) {
			   //handle error
			}];
   //present the view controller modally				
   [self presentViewController:paymentViewController animated:YES completion:nil];
}
```



## Issues


If you find a bug, please use the [issue tracker](https://github.com/paymill/paymill-ios/issues) to create a ticket.

## Developers


If you want to contribute your code, fork the repository, commit your changes and create a pull request. Please make sure you include a detailed description of your changes.


## License

The MIT License (MIT)

Copyright (c) [2013] [PAYMILL GmbH]

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


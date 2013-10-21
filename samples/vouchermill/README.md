# VoucherMill
The PAYMILL Android SDK Sample / Demo App

<a href="https://play.google.com/store/apps/details?id=com.paymill.android.samples.vouchermill">
  <img alt="Get it on Google Play"
       src="https://developer.android.com/images/brand/en_generic_rgb_wo_45.png" />
</a>

## Using the payment screens


### Installation


To use the payment screens you need to copy the whole package `com.paymill.android.payment`, as well as all resources from the `res/` folder that start with the prefix `pm_` into your project.

Your manifest should include following declarations:

```
   <!-- Copy this into your project's manifest if you use our payment activity -->
   <activity
       android:name="com.paymill.android.payment.PaymentActivity"
        android:theme="@style/Holo.Theme.Light.NoActionBar" >
   </activity>

   <!-- Always copy this to your project's manifest, as it is needed by the SDK -->
   <service android:name="com.paymill.android.service.PMService" >
   </service>
```


### Styling the payment screens


#### Change only colors
If you like the layout of the payment screens and you simply want to change the colors, you can set them from the pm_styles.xml file.
#### Change layout
If you also want to change the layouts of the fragments you can change the pm_credit_card_fragment.xml and pm_elv_fragment.xml
#### Reuse Fragments
If you want to use the fragments in your own activity, you have to create them with the `instance` method specifying a valid [Settings](http://paymill.github.io/paymill-android/docs/samples/vouchermill/reference/com/paymill/android/payment/PaymentActivity.Settings.html) object. You also have to implement the `startRequest()` callback, that will receive the `PMPaymentMethod` object.
#### Reuse validation logic.
Use the [CreditCardValidator](http://paymill.github.io/paymill-android/docs/samples/vouchermill/reference/com/paymill/android/payment/CreditCardValidator.html) and [CardTypeParser](http://paymill.github.io/paymill-android/docs/samples/vouchermill/reference/com/paymill/android/payment/CardTypeParser) classes.

### Work with the PaymentActivity


API Docs for the PaymentActivity are available [here](http://paymill.github.io/paymill-android/docs/samples/vouchermill/) .

- Create the `PMPaymentParams` object that describes the amount, currency and description. Note, that you need to specify one, even if only generate a token.

```
PMPaymentParams params = PMFactory.genPaymentParams("EUR", 100, null);
```

- Create and configure a [Settings](http://paymill.github.io/paymill-android/docs/samples/vouchermill/reference/com/paymill/android/payment/PaymentActivity.Settings.html) object.

```
Settings settings= new Settings(); // all cc types enabled
settings.disableCreditCardType(CardType.AmericanExpress); // disable American Express
```
- Call one of the [Factory](http://paymill.github.io/paymill-android/docs/samples/vouchermill/reference/com/paymill/android/payment/PaymentActivity.Factory.html) methods to create an Intent and start the PaymentActivity.

```
Intent i = PaymentActivity.Factory.getTokenIntent(this, params,
				settings, ServiceMode.TEST, "yourpublickey");
startActivityForResult(i, PaymentActivity.REQUEST_CODE);
```

- In your `onActivityResult()` method, call `getResultFrom()` to retrieve the Result. If the method returns, the callback is not from the PaymentActivity.
___
Complete example:

```
public void test() {
		PMPaymentParams params = PMFactory.genPaymentParams("EUR", 100, null);
		Settings settings = new Settings(); // all cc types enabled
		// e.g. disable a credit card type
		settings.disableCreditCardType(CardType.AmericanExpress); 
		Intent i = PaymentActivity.Factory.getTokenIntent(this, params,
				settings, ServiceMode.TEST, "yourpublickey");
		startActivityForResult(i, PaymentActivity.REQUEST_CODE);
}

protected void onActivityResult(int requestCode, int resultCode, Intent data) {
	PaymentActivity.Result result = PaymentActivity.Factory.getResultFrom(
			requestCode, resultCode, data);
	if (result == null) {
		// this is not the result we were looking for
		// if you wait for results from other activites, check here...
		return;
	} else {
		//work with the result
		Log.d("PAYMILL", "token"+result.getResultToken());
	}
}
```



## Issues


If you find a bug, please use the [issue tracker](https://github.com/paymill/paymill-android/issues) to create a ticket.

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


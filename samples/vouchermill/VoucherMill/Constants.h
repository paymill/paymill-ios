//
//  Constants.h
//  VoucherMill
//
//  Created by Aleksandar Yalnazov on 7/17/13.
//  Copyright (c) 2013 Paymill. All rights reserved.
//

#ifndef VoucherMill_Constants_h
#define VoucherMill_Constants_h

#define PM_SAFE_BLOCK_CALL(block, /* block arguments */ ...)  if ( nil != block ) { block(__VA_ARGS__); }
#define darkOrangeColor [UIColor colorWithRed:149.0/255.0 green:0/255.0 blue:11.0/255.0 alpha:1.0]
#define lightOrangeColor [UIColor colorWithRed:239.0/255.0 green:80/255.0 blue:0/255.0 alpha:1.0]
#define kBUYVOUCHER @"BuyVoucherSegue"
#define kONLINEVOUCHERS @"OnlineVouchersSegue"
#define kOFFLINEVOUCHERS @"OfflineVouchersSegue"
#define kNOTCONSUMED @"NotConsumedSegue"
#define kBuyDetailsSuccess @"BuyDetailsSuccessSegue"
#define kBuyDetailsError @"BuyDetailsErrorSegue"
#define kBOUGHT @"Bought"
#define kRESERVED @"Reserved"
#define kGENERATETOKEN @"GenerateTokenSegue"
#define kLabelFontSize 14
#define kTickets @"tickets"
#define kBurger @"burger"
#define kCustom @"custom"
#define kTyre @"tyre"
#define kTicketsBig @"tickets_big"
#define kBurgerBig @"burger_big"
#define kCustomBig @"custom_big"
#define kTyreBig @"tyre_big"

#endif

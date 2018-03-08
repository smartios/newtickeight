//
//  MyViewController.h
//  Signature
//
//  Created by Singsys on 3/9/15.
//  Copyright (c) 2015 Singsys. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ConfirmDeliveryVC.h"

@protocol imgProtocol <NSObject>

-(void)sendImage:(NSData *)image;

@end

@interface MyViewController : UIViewController<UIAlertViewDelegate>

@property (nonatomic, strong) NSObject <imgProtocol> *delegate;
@property (nonatomic, strong) UIImageView *mySignatureImage;
@property (nonatomic, assign) CGPoint lastContactPoint1, lastContactPoint2, currentPoint;
@property (nonatomic, assign) CGRect imageFrame;
@property (nonatomic, assign) BOOL fingerMoved;
@property (nonatomic, assign) float navbarHeight;

//@property (strong, nonatomic) ConfirmDeliveryVC *displaySignatureViewController;

@property (strong,nonatomic) NSString *tempValue;

-(IBAction)pushBackButton:(id)sender;
- (IBAction)saveSignature:(id)sender;
@end

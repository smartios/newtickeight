//
//  MyViewController.m
//  Signature
//
//  Created by Singsys on 3/9/15.
//  Copyright (c) 2015 Singsys. All rights reserved.
//

#import "MyViewController.h"
#import "MBProgressHUD.h"
#import "Reachability.h"

//#import "SlideNavigationController.h"



@interface MyViewController ()

@end

@implementation MyViewController

@synthesize mySignatureImage;
@synthesize lastContactPoint1, lastContactPoint2, currentPoint, delegate;
@synthesize imageFrame;
@synthesize fingerMoved;
@synthesize navbarHeight;

@synthesize tempValue;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated
{
	
    //self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
	self.navigationController.navigationBar.hidden = YES;
    //[[SlideNavigationController sharedInstance] setEnableSwipeGesture:NO];
}
-(void)viewWillDisappear:(BOOL)animated
{
    //[[SlideNavigationController sharedInstance] setEnableSwipeGesture:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"temp in MyView %@",tempValue);
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 40, 40);
    [backButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17.0]];
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    
    [backButton addTarget:self action:@selector(pushBackButton:)    forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton] ;
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 40, 40)] ;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0f];
    //label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    [label setText:@"Add Receiver's Signature"];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    
    
    //------
    
    UIButton *rightbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    rightbtn.frame=CGRectMake(275, 0, 20, 20);
    
    [rightbtn setImage:[UIImage imageNamed:@"doneimage"] forState:UIControlStateNormal];
    [rightbtn setImage:[UIImage imageNamed:@"doneimage"] forState:UIControlStateHighlighted];

    [rightbtn addTarget:self action:@selector(saveSignature:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *editbaritem=[[UIBarButtonItem alloc] initWithCustomView:rightbtn];
    
    self.navigationItem.rightBarButtonItem=editbaritem;
    
    
    
    //set the view background to light gray
    //self.view.backgroundColor = [UIColor lightGrayColor];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //get reference to the navigation frame to calculate navigation bar height
    CGRect navigationframe = [[self.navigationController navigationBar] frame];
    navbarHeight = navigationframe.size.height;
    
    //create a frame for our signature capture based on whats remaining
//    imageFrame = CGRectMake(self.view.frame.origin.x+10,
//	self.view.frame.origin.y-5,
//	self.view.frame.size.width-20,
//	self.view.frame.size.height-navbarHeight-30);
	
//    imageFrame = CGRectMake(0, 64,
//	self.view.frame.size.width,
//	self.view.frame.size.height - 64);
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	imageFrame = CGRectMake(0, 64, screenRect.size.width, screenRect.size.height-64);
	
    //allocate an image view and add to the main view
    mySignatureImage = [[UIImageView alloc] initWithImage:nil];
    mySignatureImage.frame = imageFrame;
    mySignatureImage.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mySignatureImage];
}

-(IBAction)pushBackButton:(id)sender
{
    NSData *imageData = UIImagePNGRepresentation(mySignatureImage.image);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@""];
    
    NSLog(@"filePath %@",filePath);
    
    [imageData writeToFile:filePath atomically:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
}


//when one or more fingers touch down in a view or window
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //did our finger moved yet?
    fingerMoved = NO;
    UITouch *touch = [touches anyObject];
    
    //just clear the image if the user tapped twice on the screen
    if ([touch tapCount] == 2) {
        mySignatureImage.image = nil;
        return;
    }
    
    //we need 3 points of contact to make our signature smooth using quadratic bezier curve
    currentPoint = [touch locationInView:mySignatureImage];
    lastContactPoint1 = [touch previousLocationInView:mySignatureImage];
    lastContactPoint2 = [touch previousLocationInView:mySignatureImage];
    
}


//when one or more fingers associated with an event move within a view or window
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //well its obvious that our finger moved on the screen
    fingerMoved = YES;
    UITouch *touch = [touches anyObject];
    
    //save previous contact locations
    lastContactPoint2 = lastContactPoint1;
    lastContactPoint1 = [touch previousLocationInView:mySignatureImage];
    //save current location
    currentPoint = [touch locationInView:mySignatureImage];
    
    //find mid points to be used for quadratic bezier curve
    CGPoint midPoint1 = [self midPoint:lastContactPoint1 withPoint:lastContactPoint2];
    CGPoint midPoint2 = [self midPoint:currentPoint withPoint:lastContactPoint1];
    
    //create a bitmap-based graphics context and makes it the current context
    UIGraphicsBeginImageContext(imageFrame.size);
    
    //draw the entire image in the specified rectangle frame
    [mySignatureImage.image drawInRect:CGRectMake(0, 0, imageFrame.size.width, imageFrame.size.height)];
    
    //set line cap, width, stroke color and begin path
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 3.0f);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    
    //begin a new new subpath at this point
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), midPoint1.x, midPoint1.y);
    //create quadratic Bézier curve from the current point using a control point and an end point
    CGContextAddQuadCurveToPoint(UIGraphicsGetCurrentContext(),
                                 lastContactPoint1.x, lastContactPoint1.y, midPoint2.x, midPoint2.y);
    
    //set the miter limit for the joins of connected lines in a graphics context
    CGContextSetMiterLimit(UIGraphicsGetCurrentContext(), 2.0);
    
    //paint a line along the current path
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    
    //set the image based on the contents of the current bitmap-based graphics context
    mySignatureImage.image = UIGraphicsGetImageFromCurrentImageContext();
    
    //remove the current bitmap-based graphics context from the top of the stack
    UIGraphicsEndImageContext();
    
    //lastContactPoint = currentPoint;
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    //just clear the image if the user tapped twice on the screen
    if ([touch tapCount] == 2) {
        mySignatureImage.image = nil;
        return;
    }
    
    
    //if the finger never moved draw a point
    if(!fingerMoved) {
        UIGraphicsBeginImageContext(imageFrame.size);
        [mySignatureImage.image drawInRect:CGRectMake(0, 0, imageFrame.size.width, imageFrame.size.height)];
        
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 3.0f);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        
        mySignatureImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
}

//calculate midpoint between two points
- (CGPoint) midPoint:(CGPoint )p0 withPoint: (CGPoint) p1 {
    return (CGPoint) {
        (p0.x + p1.x) / 2.0,
        (p0.y + p1.y) / 2.0
    };
}


//save button was clicked, its time to save the signature
- (IBAction)saveSignature:(id)sender
{
    //-------------------------
    
        NSData *imageData = UIImageJPEGRepresentation(mySignatureImage.image, 0.3);
    
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//	
//        NSString *documentsDirectory = [paths objectAtIndex:0];
//        
//        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"signature_%@.jpg",[[NSUserDefaults standardUserDefaults ]objectForKey:@"id_order"]]];
//        
//        NSLog(@"filePath %@",filePath);
//        
//       BOOL issaved =  [imageData writeToFile:filePath atomically:YES];
//        
//        //-----------------------
//	
//        //create path to where we want the image to be saved
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//              //if the folder doesn't exists then just create one
//        NSError *error = nil;
//        if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
//            [[NSFileManager defaultManager] createDirectoryAtPath:filePath
//                                      withIntermediateDirectories:NO
//                                                       attributes:nil
//                                                            error:&error];
//        
//        //convert image into .png format
//        
//        [fileManager createFileAtPath:filePath contents:imageData attributes:nil];
    
    if (imageData.length > 0 )
    {
        [self getSessionData:imageData];
      //[self getSessionData ];
    }
    
    
    
    
    
}

//webservice

-(void) getSessionData:(NSData*)imageData
{

    MBProgressHUD * hud = [[MBProgressHUD alloc] init];
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.detailsLabel.text = @"";
    hud.label.text = @"Please Wait...";

    
        //[ showWithStatus: [appDel getString: @"loading"]];

     AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
        //AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];

        manager.requestSerializer = requestSerializer;
    
    
    NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
    
    
        [param setValue:[[[NSUserDefaults standardUserDefaults] valueForKey:@"userData"] valueForKey:@"id_user"]  forKey:@"id_user"];

    
    NSString *access = [[NSUserDefaults standardUserDefaults] stringForKey:@"access_token"];
    NSString *url = @"https://qliniq.com/webservice/add_signature?access_token=";
    NSString *ur = [url stringByAppendingString: access];
    
    [manager POST: ur parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
   //     NSData *imageDataSend = UIImageJPEGRepresentation(imageData, 1.0);
        [formData appendPartWithFileData:imageData name:@"signature" fileName:[NSString stringWithFormat:@"signature.jpg"] mimeType:@"image/jpg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [hud hideAnimated:true];
        
    
        if([[responseObject objectForKey:@"status"] isEqualToString:@"SUCCESS"])
        {
            NSMutableDictionary *tempDic2 = [[NSMutableDictionary alloc] init];
            tempDic2 = [[[NSUserDefaults standardUserDefaults] valueForKey:@"userData"] mutableCopy];
            [tempDic2 setValue:[[responseObject objectForKey:@"data"] valueForKey:@"signature"] forKey:@"signature"];
            [[NSUserDefaults standardUserDefaults] setObject:tempDic2 forKey:@"userData"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[self navigationController] popViewControllerAnimated:true];
        }
        else
        {
            MBProgressHUD * hud = [[MBProgressHUD alloc] init];
            hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabel.text = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"message"]];
            //NSTimeInterval *delay = 2.0;
            [hud hideAnimated:true afterDelay:2.0];

        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [hud hideAnimated:true];
        
    }];
    
    
    }


//some action was taken on the alert view
- (void) alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //which button was pressed in the alert view
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    
    //user wants to save the signature now
    if ([buttonTitle isEqualToString:@"Ok"]){
        
    }
    
    //just forget it
    else if ([buttonTitle isEqualToString:@"Cancel"]){
        NSLog(@"Cancel button was pressed.");
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

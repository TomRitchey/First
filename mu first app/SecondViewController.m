//
//  SecondViewController.m
//  mu first app
//
//  Created by Kacper Augustyniak on 26/05/2015.
//  Copyright (c) 2015 Kacper Augustyniak. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "SecondViewController.h"
//#import "CameraDelegate.h"

@interface SecondViewController ()

@property(nonatomic, retain) UIViewWithBorder *viewWithBorder;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *hideKeyboard;
@property (strong, nonatomic) IBOutlet UIStepper *stepper2;
@property (strong, nonatomic) IBOutlet UILabel *stepperCount2;
@property (strong, nonatomic) IBOutlet UIPinchGestureRecognizer *pinchAction;
@property (strong, nonatomic) IBOutlet UIRotationGestureRecognizer *rotationAction;
@property (strong, nonatomic) IBOutlet UILabel *pinchInfo;

@end



@implementation SecondViewController
NSString* nameString = @"Pizza parts";
CGFloat ratio = 0.8;
CGFloat center_x;
CGFloat center_y;
CGRect screen;
CGFloat screenWidth;
CGFloat screenHeight;
CGFloat rectWidth;
AVCaptureVideoPreviewLayer *previewLayer;

UIViewWithBorder *viewWithBorder;
//CameraDelegate * camera_session;

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.stepper2.value = 8;
    screen = [[UIScreen mainScreen] bounds];
    screenWidth = CGRectGetWidth(screen);
    screenHeight = CGRectGetHeight(screen);
    rectWidth = ratio*screenWidth;
   
    center_x = (screenWidth-rectWidth)/2;
    center_y = (screenHeight-rectWidth)/2;
    self.stepper2.minimumValue = 1;
    self.stepperCount2.text = [NSString stringWithFormat:@"%@ %0.0f",nameString, self.stepper2.value];

    viewWithBorder = [[UIViewWithBorder alloc] initWithFrame:CGRectMake((screenWidth-rectWidth)/2, (screenHeight-rectWidth)/2, rectWidth, rectWidth)];
    
    viewWithBorder.backgroundColor = [UIColor clearColor];
    viewWithBorder.lineWidth = 5.0;
    viewWithBorder.pizzaParts = self.stepper2.value;
    
    
    [self.view addSubview:viewWithBorder];
    [self.view setNeedsDisplay];
    
    NSLog(@" layer uiview %lu",(unsigned long)[self.view.subviews indexOfObject:viewWithBorder]);
    NSLog(@" layer text %lu",(unsigned long)[self.view.subviews indexOfObject:self.stepperCount2]);
    NSLog(@" layer stepper %lu",(unsigned long)[self.view.subviews indexOfObject:self.stepper2]);

    [[self view]exchangeSubviewAtIndex:[self.view.subviews indexOfObject:viewWithBorder] withSubviewAtIndex:[self.view.subviews indexOfObject:self.stepper2]];

    //[[self view]exchangeSubviewAtIndex:[self.view.subviews indexOfObject:viewWithBorder] withSubviewAtIndex:[self.view.subviews indexOfObject:self.stepper]];
    // Orientation change detector
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(orientationChanged:)
     name:UIDeviceOrientationDidChangeNotification
     object:[UIDevice currentDevice]];
    
    [super viewDidLoad];
    //tło z kamery
    // Do any additional setup after loading the view.
    
    //Capture Session
    AVCaptureSession *session = [[AVCaptureSession alloc]init];
    session.sessionPreset = AVCaptureSessionPresetPhoto;
    
    //Add device
    AVCaptureDevice *device =
    [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //Input
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    if (!input)
    {
        NSLog(@"No Input");
    }
    
    [session addInput:input];
    
    //Output
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
    [session addOutput:output];
    output.videoSettings =
    @{ (NSString *)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA) };
    
    //Preview Layer
    previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    UIView *myView = self.view;
    previewLayer.frame = myView.bounds;
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;

    

    
    //[self.view.layer addSublayer:previewLayer ];
    //[previewLayer removeFromSuperlayer];
    [self.view.layer insertSublayer:previewLayer atIndex:0];
    //Start capture session
    [session startRunning];
    
   // NSLog(@" layer camera %lu",(unsigned long)[self.view.layer indexOfObject:self.previ]);
    
    [UIView animateWithDuration:5 animations:^{
        self.pinchInfo.alpha = 0;
        //[self.pinchInfo setHidden:YES];
    }];
    
    //
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)stepperTapped:(id)sender {
    self.stepperCount2.text = [NSString stringWithFormat:@"%@ %0.0f",nameString, self.stepper2.value];
    
    viewWithBorder.pizzaParts = self.stepper2.value;
    
    [self redrawingDevice];
}


- (IBAction)pinchScreen:(id)sender {
    rectWidth = rectWidth+3*(self.pinchAction.velocity);
    [self redrawingDevice];
}


- (IBAction)screenTap:(id)sender {
    [self.stepperCount2 resignFirstResponder];
}


- (IBAction)rotate:(id)sender {
    
    viewWithBorder.startAngle = self.rotationAction.rotation;
    [self redrawingDevice];
}


- (void) orientationChanged:(NSNotification *)note
{
    [self redrawingDevice];
}

- (void)redrawingDevice{
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    [self adaptVideoOrientation];
    
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation)){
        center_x = (screenWidth-rectWidth)/2;
        center_y = (screenHeight-rectWidth)/2;
    }else{
        center_y = (screenWidth-rectWidth)/2;
        center_x = (screenHeight-rectWidth)/2;
    }
    [viewWithBorder setFrame:CGRectMake(center_x, center_y, rectWidth, rectWidth)];
    [viewWithBorder setNeedsDisplay];
}

-(void)adaptVideoOrientation{
    switch ([UIApplication sharedApplication].statusBarOrientation){
        case UIInterfaceOrientationLandscapeLeft:
    [previewLayer removeFromSuperlayer];
    previewLayer.frame = self.view.bounds;
    previewLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
    [self.view.layer insertSublayer:previewLayer atIndex:0];
            break;
    case UIInterfaceOrientationLandscapeRight:
        [previewLayer removeFromSuperlayer];
        previewLayer.frame = self.view.bounds;
        previewLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
        [self.view.layer insertSublayer:previewLayer atIndex:0];
            break;
        default:
    [previewLayer removeFromSuperlayer];
    previewLayer.frame = self.view.bounds;
    previewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
    [self.view.layer insertSublayer:previewLayer atIndex:0];
        break;}
}
@end

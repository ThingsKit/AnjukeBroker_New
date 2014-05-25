//
//  LocationSpecifyViewController.m
//  AnjukeBroker_New
//
//  Created by leozhu on 14-5-25.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "LocationSpecifyViewController.h"
#import "KKAnnotation.h"

@interface LocationSpecifyViewController ()

@property (nonatomic, strong) MKMapView* mapView;
@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) KKAnnotation* annotation;

@end

@implementation LocationSpecifyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton* right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.frame = CGRectMake(0, 0, 45, 45);
    [right setTitle:@"还原" forState:UIControlStateNormal];
    [right addTarget:self action:@selector(removeSpecificCoordinate:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    // Do any additional setup after loading the view.
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20-44)];
    _mapView.showsUserLocation = YES;
    _mapView.mapType = MKMapTypeStandard;
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    //地图的长按手势
    UILongPressGestureRecognizer* gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
    gesture.minimumPressDuration = 1;
    [_mapView addGestureRecognizer:gesture];
    
    
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager setDistanceFilter:kCLDistanceFilterNone];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
    _locationManager.delegate = self;
    
    //开始实时定位
    [_locationManager startUpdatingLocation];
    
}

#pragma mark -
#pragma mark rightBarButtonItem
- (void)removeSpecificCoordinate:(UIButton*)button{
    //保存当前选定的坐标值
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"latitude_specify"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"longitude_specify"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"还原确认" message:@"指定坐标已经清空" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
    [alert show];
}


#pragma mark -
#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
	 didUpdateLocations:(NSArray *)locations{
    [manager stopUpdatingLocation];
    
    CLLocation* location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    MKCoordinateSpan span = {.1, .1};
    MKCoordinateRegion region = {coordinate, span};
    
    [_mapView setRegion:region animated:YES];
    
}


#pragma mark -
#pragma mark MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    NSLog(@"update user location");
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) { //如果是系统默认的标注视图
        return nil;
    }
    
    static NSString* identifier = @"AnnotationView";
    MKPinAnnotationView* annotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        
        annotationView.canShowCallout = YES;
    }
    
    annotationView.annotation = annotation;
    annotationView.pinColor = MKPinAnnotationColorGreen;
    annotationView.animatesDrop = YES;
    
    return annotationView;
}


#pragma mark -
#pragma mark LongPressGesture
- (void)longPressGesture:(UILongPressGestureRecognizer*)gesture{
    
    
    if (gesture.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    //首先移除之前的annotationView
    [_mapView removeAnnotation:_annotation];
    
    CGPoint touchPoint = [gesture locationInView:self.mapView];
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    NSLog(@"Location found from Map: %f %f",coordinate.latitude,coordinate.longitude);
    
    //保存当前选定的坐标值
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:coordinate.latitude] forKey:@"latitude_specify"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:coordinate.longitude] forKey:@"longitude_specify"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //地图滚动显示改区域
    MKCoordinateSpan span = {.1, .1};
    MKCoordinateRegion region = {coordinate, span};
    [_mapView setRegion:region animated:YES];
    
    //创建annotation对象
    if (self.annotation == nil) {
        _annotation = [[KKAnnotation alloc] init];
    }
    _annotation.coordinate = coordinate;
    _annotation.title = [NSString stringWithFormat:@"%f %f", coordinate.latitude, coordinate.longitude];
    [_mapView addAnnotation:_annotation];
    [_mapView selectAnnotation:_annotation animated:YES];
    
}

#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

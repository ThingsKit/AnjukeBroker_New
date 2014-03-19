//
//  MapViewController.m
//  AnjukeBroker_New
//
//  Created by shan xu on 14-3-18.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "MapViewController.h"
#import "RegionAnnotation.h"
#import "RegionAnnotationView.h"

@interface MapViewController ()

@end

@implementation MapViewController
@synthesize mapTypeIndex;
@synthesize regionMapView;
@synthesize addressStr;
@synthesize updateInt;
@synthesize UserRegion;
@synthesize lastloc;
@synthesize navLoc;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        updateInt = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"位置";
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    self.regionMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    self.regionMapView.delegate = self;
    self.regionMapView.showsUserLocation = YES;
    [self.view addSubview:self.regionMapView];
    
    if (mapTypeIndex == RegionChoose) {
        UIImageView *certerIcon = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width-40)/2, (self.view.bounds.size.height-64-40)/2, 40, 40)];
        certerIcon.image = [UIImage imageNamed:@"anjuke_icon_esf@2x.png"];
        [self.view addSubview:certerIcon];
        
        UIButton *goUserLocBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        goUserLocBtn.frame = CGRectMake(10, self.view.bounds.size.height-64-50, 40, 40);
        [goUserLocBtn addTarget:self action:@selector(goUserLoc:) forControlEvents:UIControlEventTouchUpInside];
        goUserLocBtn.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:goUserLocBtn];
    }else{
//        CLLocationCoordinate2D loc = [lastloc coordinate];
//        UserRegion = MKCoordinateRegionMakeWithDistance(loc, 200, 200);
//        [self.regionMapView setRegion:UserRegion animated:YES];
//        
//        [self showAnnotation:lastloc coord:loc];
    }
}
-(void)goUserLoc:(id *)sender{
    [self.regionMapView setRegion:UserRegion animated:YES];
}
#pragma MKMapViewDelegate
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    CLLocationCoordinate2D loc = [userLocation coordinate];
    //放大地图到自身的经纬度位置。
    UserRegion = MKCoordinateRegionMakeWithDistance(loc, 200, 200);

    if (mapTypeIndex != RegionNavi) {
        if (updateInt >= 1) {
            return;
        }
        [self showAnnotation:userLocation.location coord:loc];
    }
    [self.regionMapView setRegion:UserRegion animated:YES];
    updateInt += 1;
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    if (mapTypeIndex == RegionNavi) {
        return;
    }
    NSLog(@"regionDidChangeAnimated");
    [mapView removeAnnotations:mapView.annotations];
    if (updateInt == 0){
        return;
    }
    CLLocationCoordinate2D centerCoordinate = mapView.region.center;
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:centerCoordinate.latitude longitude:centerCoordinate.longitude];
    
    self.lastloc = loc;
    DLog(@"regionChangedloc--->>%@",loc);

    [self showAnnotation:loc coord:centerCoordinate];
}

-(void)showAnnotation:(CLLocation *)location coord:(CLLocationCoordinate2D)coords{
    if (mapTypeIndex == RegionNavi) {
        [self addAnnotationView:location coord:coords address:nil loadStatus:4];
        return;
    }
    
    [self addAnnotationView:location coord:coords address:nil loadStatus:1];

    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *array, NSError *error) {
        if (self.lastloc != location) {
//            [self.regionMapView removeAnnotations:self.regionMapView.annotations];            
            return;
        }

        if (array.count > 0) {
            CLPlacemark *placemark = [array objectAtIndex:0];
            NSString *address = [placemark.addressDictionary objectForKey:@"Name"];
            NSLog(@"address--->>%@",address);
            [self addAnnotationView:location coord:coords address:address loadStatus:2];
        }else{
            [self addAnnotationView:location coord:coords address:nil loadStatus:3];
        }
    }];
}

-(void)addAnnotationView:(CLLocation *)location coord:(CLLocationCoordinate2D)coords address:(NSString *)address loadStatus:(int)loadStatus{
    [self.regionMapView removeAnnotations:self.regionMapView.annotations];
    
    RegionAnnotation *annotation = [[RegionAnnotation alloc] init];
    annotation.coordinate = coords;
    annotation.title = address;
    if (mapTypeIndex == RegionChoose) {
        annotation.styleDetail = StyleForChoose;
    }else{
        annotation.styleDetail = StyleForNav;
    }
    
    if (loadStatus == 1) {
        annotation.loadStatus = RegionLoading;
    }else if (loadStatus == 2){
        NSLog(@"RegionLoadSuc");
        annotation.loadStatus = RegionLoadSuc;
    }else if (loadStatus == 3){
        annotation.loadStatus = RegionLoadFail;
    }else if (loadStatus == 4){
        annotation.loadStatus = RegionLoadForNavi;
    }
    
    [self.regionMapView addAnnotation:annotation];
    [self.regionMapView selectAnnotation:annotation animated:YES];
    updateInt += 1;
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    if (mapTypeIndex == RegionNavi) {
        return;
    }

    NSLog(@"regionWillChangeAnimated");
    [mapView removeAnnotations:mapView.annotations];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    NSLog(@"viewForAnnotationtimes");
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
//        [(MKUserLocation *)annotation setTitle:@"当前位置"];
        return nil;
    }
    NSString *str = NSStringFromClass([annotation class]);
    NSLog(@"str-->>%@",str);
    
    static NSString* identifier = @"MKAnnotationView";
    if ([annotation isKindOfClass:[RegionAnnotation class]]) {
        NSLog(@"createNewLoc");
        RegionAnnotationView *annotationView;
        annotationView = (RegionAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (annotationView == nil) {
            annotationView = [[RegionAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        if (mapTypeIndex == RegionNavi) {
            annotationView.image = [UIImage imageNamed:@"anjuke_icon_esf@2x.png"];
        }
        [annotationView setCanShowCallout:NO];

        annotationView.annotation = annotation;

        return annotationView;
    }
    return nil;
}


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

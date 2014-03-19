//
//  MapViewController.m
//  AnjukeBroker_New
//
//  Created by shan xu on 14-3-18.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "MapViewController.h"
#import "RegionAnnotation.h"

#define SYSTEM_NAVIBAR_COLOR [UIColor colorWithRed:1 green:1 blue:1 alpha:1]
#define ISIOS7 ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=7)

@interface MapViewController ()
@property(nonatomic,strong) MKMapView *regionMapView;
@property(nonatomic,assign) int updateInt;
@property(nonatomic,assign) MKCoordinateRegion userRegion;
@property(nonatomic,strong) CLLocation *lastloc;
@property(nonatomic,assign) CLLocationCoordinate2D lastCoords;
@end

@implementation MapViewController
@synthesize mapType;
@synthesize regionMapView;
@synthesize addressStr;
@synthesize updateInt;
@synthesize userRegion;
@synthesize lastloc;
@synthesize lat;
@synthesize lon;
@synthesize naviRegion;
@synthesize siteDelegate;
@synthesize lastCoords;

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
    if (ISIOS7) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }

    NSString *titStr;
    if (mapType == RegionNavi) {
        titStr = @"查看地理位置";
    }else{
        titStr = @"位置";
        
        UIBarButtonItem *rBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleBordered target:self action:@selector(rightButtonAction:)];
        if (!ISIOS7) {
            rBtn.tintColor = SYSTEM_NAVIBAR_COLOR;
        }
        self.navigationItem.rightBarButtonItem = rBtn;
    }

    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 31)];
    lb.backgroundColor = [UIColor clearColor];
    lb.font = [UIFont systemFontOfSize:19];
    lb.textAlignment = NSTextAlignmentCenter;
    lb.textColor = SYSTEM_NAVIBAR_COLOR;
    lb.text = titStr;
    self.navigationItem.titleView = lb;
    
    self.regionMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    self.regionMapView.delegate = self;
    self.regionMapView.showsUserLocation = YES;
    [self.view addSubview:self.regionMapView];
 
    UIButton *goUserLocBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    goUserLocBtn.frame = CGRectMake(10, self.view.bounds.size.height-64-50, 40, 40);
    [goUserLocBtn addTarget:self action:@selector(goUserLoc:) forControlEvents:UIControlEventTouchUpInside];
    goUserLocBtn.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:goUserLocBtn];
    
    if (mapType == RegionChoose) {
        UIImageView *certerIcon = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width-40)/2, (self.view.bounds.size.height-64-40)/2, 40, 40)];
        certerIcon.image = [UIImage imageNamed:@"anjuke_icon_esf@2x.png"];
        [self.view addSubview:certerIcon];
        
    }else{
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = lat;
        coordinate.longitude = lon;
        
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:lat longitude:lon];

        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinate, 200, 200);
        naviRegion = [self.regionMapView regionThatFits:viewRegion];
        [self.regionMapView setRegion:naviRegion animated:YES];
        
        [self showAnnotation:loc coord:coordinate];
    }
}
-(void)rightButtonAction:(id *)sender{
    if (lastCoords.latitude && lastCoords.longitude && addressStr && ![addressStr isEqualToString:@""]) {
        [siteDelegate returnSiteAttr:lastCoords.latitude lon:lastCoords.longitude address:addressStr];
        
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"您还没有定位到有效地址，请重新选择发送地址" delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alert show];
    }
}
-(void)goUserLoc:(id *)sender{
    [self.regionMapView setRegion:userRegion animated:YES];
}
-(void)doAcSheet{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择以下方式导航" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"google 地图" otherButtonTitles:@"高德地图",@"百度地图",@"绘制路线", nil];
    sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [sheet showInView:self.view];
}
#pragma MKMapViewDelegate
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    CLLocationCoordinate2D loc = [userLocation coordinate];
    //放大地图到自身的经纬度位置。
    userRegion = MKCoordinateRegionMakeWithDistance(loc, 200, 200);

    if (mapType != RegionNavi) {
        if (updateInt >= 1) {
            return;
        }
        [self showAnnotation:userLocation.location coord:loc];
        [self.regionMapView setRegion:userRegion animated:YES];
        updateInt += 1;
    }
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    if (mapType == RegionNavi) {
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
    if (mapType == RegionNavi) {
        [self addAnnotationView:location coord:coords address:addressStr loadStatus:4];
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

            lastCoords = coords;
            addressStr = address;
            NSLog(@"address--->>%@",address);
            [self addAnnotationView:location coord:coords address:address loadStatus:2];
        }else{
            lastCoords.latitude = 0;
            lastCoords.longitude = 0;
            addressStr = nil;
            [self addAnnotationView:location coord:coords address:nil loadStatus:3];
        }
    }];
}

-(void)addAnnotationView:(CLLocation *)location coord:(CLLocationCoordinate2D)coords address:(NSString *)address loadStatus:(int)loadStatus{
    [self.regionMapView removeAnnotations:self.regionMapView.annotations];
    
    RegionAnnotation *annotation = [[RegionAnnotation alloc] init];
    annotation.coordinate = coords;
    annotation.title = address;
    if (mapType == RegionChoose) {
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
    if (mapType == RegionNavi) {
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
        if (mapType == RegionNavi) {
            
            CGRect frame = annotationView.frame;
            frame.size.width = 300.0;
            frame.size.height = 300.0;
            frame.origin.x = -100;
            frame.origin.y = 0;
            annotationView.frame = frame;
            
            annotationView.image = [UIImage imageNamed:@"anjuke_icon_esf@2x.png"];
            annotationView.backgroundColor = [UIColor redColor];
            annotationView.clipsToBounds = NO;
            annotationView.acSheetDelegate = self;
        }
        [annotationView setCanShowCallout:NO];

        annotationView.annotation = annotation;

        return annotationView;
    }
    return nil;
}
//-(void)naviMap:(UIButton *)btn{
//    DLog(@"naviMap--test");
//}

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

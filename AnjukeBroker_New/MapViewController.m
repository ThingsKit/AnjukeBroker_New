//
//  MapViewController.m
//  AnjukeBroker_New
//
//  Created by shan xu on 14-3-18.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "MapViewController.h"
#import "RegionAnnotation.h"
#import "WGS84TOGCJ02.h"
#import "CSqlite.h"


#import "LocationChange.h"
#define SYSTEM_NAVIBAR_COLOR [UIColor colorWithRed:1 green:1 blue:1 alpha:1]
#define ISIOS7 ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=7)

@interface MapViewController ()
@property(nonatomic,strong) CSqlite *m_sqlite;
@property(nonatomic,assign) CLLocationCoordinate2D naviCoords;
@property(nonatomic,assign) CLLocationCoordinate2D nowCoords;
@property (nonatomic, strong) MKMapView *regionMapView;
@property (nonatomic, assign) int updateInt;
@property (nonatomic, assign) MKCoordinateRegion userRegion;
@property (nonatomic, strong) CLLocation *lastloc;
@property (nonatomic, assign) CLLocationCoordinate2D lastCoords;
@property (nonatomic, strong) NSMutableDictionary *locationDic;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *region;

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
@synthesize lastCoords;
@synthesize m_sqlite;
@synthesize naviCoords;
@synthesize nowCoords;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        updateInt = 0;
        self.locationDic = [NSMutableDictionary dictionary];
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
        naviCoords.latitude = lat;
        naviCoords.longitude = lon;
        
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:lat longitude:lon];

        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(naviCoords, 200, 200);
        naviRegion = [self.regionMapView regionThatFits:viewRegion];
        [self.regionMapView setRegion:naviRegion animated:YES];
        
        [self showAnnotation:loc coord:naviCoords];
    }
}

-(void)rightButtonAction:(id *)sender{
    
    if (lastCoords.latitude && lastCoords.longitude && addressStr && ![addressStr isEqualToString:@""]) {
        if (self.siteDelegate && [self.siteDelegate respondsToSelector:@selector(loadMapSiteMessage:)])
        {
            [self.locationDic setValue:self.addressStr forKey:@"address"];
            [self.locationDic setValue:self.city forKey:@"city"];
            [self.locationDic setValue:self.region forKey:@"region"];
            [self.locationDic setValue:[NSString stringWithFormat:@"%f",lastCoords.latitude] forKey:@"lat"];
            [self.locationDic setValue:[NSString stringWithFormat:@"%f",lastCoords.longitude] forKey:@"lng"];
            
           [self.siteDelegate loadMapSiteMessage:self.locationDic];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"您还没有定位到有效地址，请重新选择发送地址" delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alert show];
    }
}

-(void)goUserLoc:(id *)sender{
    [self.regionMapView setRegion:userRegion animated:YES];
}

-(void)navOption{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择以下方式导航" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"google 地图" otherButtonTitles:@"高德地图",@"百度地图",@"绘制路线", nil];
    sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [sheet showInView:self.view];
}

-(CLLocationCoordinate2D)transMLGBGPS:(CLLocationCoordinate2D)yGps
{
    int TenLat=0;
    int TenLog=0;
    TenLat = (int)(yGps.latitude*10);
    TenLog = (int)(yGps.longitude*10);
    NSString *sql = [[NSString alloc]initWithFormat:@"select offLat,offLog from gpsT where lat=%d and log = %d",TenLat,TenLog];
    sqlite3_stmt* stmtL = [m_sqlite NSRunSql:sql];
    int offLat=0;
    int offLog=0;
    while (sqlite3_step(stmtL)==SQLITE_ROW){
        offLat = sqlite3_column_int(stmtL, 0);
        offLog = sqlite3_column_int(stmtL, 1);
     }
    
    yGps.latitude = yGps.latitude+offLat*0.0001;
    yGps.longitude = yGps.longitude + offLog*0.0001;
    return yGps;
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        if (!ISIOS7) {//ios6 调用goole网页地图
            NSString *urlString = [[NSString alloc]
                                   initWithFormat:@"http://maps.google.com/maps?saddr=&daddr=%f,%f&dirfl=d",31.23179401,121.45062754];
            
            NSURL *aURL = [NSURL URLWithString:urlString];
            [[UIApplication sharedApplication] openURL:aURL];
        }else{//ios7 跳转apple map
            CLLocationCoordinate2D to;
            
            to.latitude = 31.23179401;
            to.longitude = 121.45062754;
            MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:to addressDictionary:nil]];
            
            toLocation.name = addressStr;
            [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentLocation, toLocation, nil] launchOptions:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeDriving, [NSNumber numberWithBool:YES], nil] forKeys:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeKey, MKLaunchOptionsShowsTrafficKey, nil]]];
        }
    }else if (buttonIndex == 1) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
            DLog(@"已经安装google");
        }else{
            DLog(@"还没安装google");
        }
        NSString *urlStr = [NSString stringWithFormat:@"comgooglemaps://?saddr=&daddr=31.23179401,121.45062754&directionsmode=transit"];

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }else if (buttonIndex == 2){
//        CLLocation *loc = [locations objectAtIndex:0];
//        //判断是不是属于国内范围
//        CLLocation *loc = [[CLLocation alloc] initWithLatitude:31.23179401 longitude:121.45062754];
//        CLLocationCoordinate2D coord;
//        if (![WGS84TOGCJ02 isLocationOutOfChina:[loc coordinate]]) {
//            //转换后的coord
//            coord = [WGS84TOGCJ02 transformFromWGSToGCJ:[loc coordinate]];
//        }
        
//        double resultX = 0 ,resultY = 0;
//        bd_encrypt(31.23179401, 121.45062754, &resultX, &resultY);
//        NSLog(@"1--->>%g %g",resultX,resultY);
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:31.23179401 longitude:121.45062754];
        
        CLLocationCoordinate2D coord = [loc coordinate];
        
        coord = [self transMLGBGPS:coord];
        
        NSLog(@"newcoord--->>%f/%f",coord.latitude,coord.longitude);
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"iosamap://navi?sourceApplication=broker&backScheme=openbroker2&poiname=&poiid=BGVIS&lat=%f&lon=%f&dev=1&style=2",coord.latitude,coord.longitude]];

//        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"iosamap://navi?sourceApplication=broker&backScheme=openbroker2&poiname=&poiid=BGVIS&lat=%f&lon=%f&dev=1&style=2",31.23179401,121.45062754]];

        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://navi"]]) {
            DLog(@"已经安装高德");
        }else{
            DLog(@"还没安装高德");
        }
        [[UIApplication sharedApplication] openURL:url];
    
    }else if (buttonIndex == 3){
//        CLLocation *loc = [[CLLocation alloc] initWithLatitude:31.23179401 longitude:121.45062754];
//        CLLocationCoordinate2D coord;
//        if (![WGS84TOGCJ02 isLocationOutOfChina:[loc coordinate]]) {
//            //转换后的coord
//            coord = [WGS84TOGCJ02 transformFromWGSToGCJ:[loc coordinate]];
//        }

        CLLocation *loc = [[CLLocation alloc] initWithLatitude:31.23179401 longitude:121.45062754];
        CLLocationCoordinate2D coord = [loc coordinate];
        
        coord = [self transMLGBGPS:coord];
        
        NSLog(@"newcoord--->>%f/%f",coord.latitude,coord.longitude);
        
//        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"iosamap://navi?sourceApplication=broker&backScheme=openbroker2&poiname=&poiid=BGVIS&lat=%f&lon=%f&dev=1&style=2",coord.latitude,coord.longitude]];

        
//        NSString *stringURL = [NSString stringWithFormat:@"baidumap://map/direction?origin=%f,%f&destination=%f,%f&&mode=driving",31.21774195,121.53035400,31.23179401,121.45062754];
        NSString *stringURL = [NSString stringWithFormat:@"baidumap://map/direction?origin=%f,%f&destination=%f,%f&&mode=driving",31.21774195,121.53035400,coord.latitude,coord.longitude];

        NSURL *url = [NSURL URLWithString:stringURL];
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://map/"]]) {
            DLog(@"已经安装百度");
        }else{
            DLog(@"还没安装百度");
        }
        [[UIApplication sharedApplication] openURL:url];
//        if (![[UIApplication sharedApplication] openURL:url]) {
//        }
    }else if (buttonIndex == 4){
        [self drawRout];
    }
}
-(void)drawRout{
    MKPlacemark *fromPlacemark = [[MKPlacemark alloc] initWithCoordinate:nowCoords addressDictionary:nil];
    
    MKPlacemark *toPlacemark   = [[MKPlacemark alloc] initWithCoordinate:naviCoords addressDictionary:nil];
    
    MKMapItem *fromItem = [[MKMapItem alloc] initWithPlacemark:fromPlacemark];
    
    MKMapItem *toItem   = [[MKMapItem alloc] initWithPlacemark:toPlacemark];
    
    [self findDirectionsFrom:fromItem
                          to:toItem];
}
#pragma mark - Private
-(void)findDirectionsFrom:(MKMapItem *)from to:(MKMapItem *)to{
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = from;
    request.destination = to;
    request.transportType = MKDirectionsTransportTypeWalking;
//    request.
    if (ISIOS7) {
        request.requestsAlternateRoutes = YES;
    }
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         
         if (error) {
             
             NSLog(@"error:%@", error);
         }
         else {
             NSLog(@"---->>%d",[response.routes count]);
             MKRoute *route1 = response.routes[0];
             
             [self.regionMapView addOverlay:route1.polyline];
         }
     }];
}
#pragma MKMapViewDelegate
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView
            rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.lineWidth = 5.0;
    renderer.strokeColor = [UIColor purpleColor];
    return renderer;
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    nowCoords = [userLocation coordinate];
    //放大地图到自身的经纬度位置。
    userRegion = MKCoordinateRegionMakeWithDistance(nowCoords, 200, 200);

    if (mapType != RegionNavi) {
        if (updateInt >= 1) {
            return;
        }
        [self showAnnotation:userLocation.location coord:nowCoords];
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
    
//    [self addAnnotationView:location coord:coords address:nil loadStatus:1];
    [self addAnnotationView:location coord:coords address:@"加载中..." loadStatus:1];

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
            self.addressStr = address;
            self.city = placemark.administrativeArea;
            self.region = placemark.subLocality;
            NSLog(@"address--->>%@",address);
            [self addAnnotationView:location coord:coords address:address loadStatus:2];
        }else{
            lastCoords.latitude = 0;
            lastCoords.longitude = 0;
//            addressStr = nil;
            addressStr = @"请滑动重新寻址";
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
    
//    if (loadStatus == 1) {
//        annotation.loadStatus = RegionLoading;
//    }else if (loadStatus == 2){
//        NSLog(@"RegionLoadSuc");
//        annotation.loadStatus = RegionLoadSuc;
//    }else if (loadStatus == 3){
//        annotation.loadStatus = RegionLoadFail;
//    }else if (loadStatus == 4){
//        annotation.loadStatus = RegionLoadForNavi;
//    }
    
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
        MKAnnotationView *annotationView;
        annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        
        
        if (mapType == RegionNavi) {
            annotationView.image = [UIImage imageNamed:@"anjuke_icon_esf@2x.png"];

            UIButton *naviBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            naviBtn.backgroundColor = [UIColor blackColor];
            [naviBtn addTarget:self action:@selector(doAcSheet) forControlEvents:UIControlEventTouchUpInside];
            //    naviBtn.frame = CGRectMake(addSize.width+15, 5, 40, 30);
            naviBtn.frame = CGRectMake(55, 5, 40, 30);

            annotationView.rightCalloutAccessoryView = naviBtn;
        }else{
    
//            if (loadStatus == 1) {
//                annotation.loadStatus = RegionLoading;
//            }else if (loadStatus == 2){
//                NSLog(@"RegionLoadSuc");
//                annotation.loadStatus = RegionLoadSuc;
//            }else if (loadStatus == 3){
//                annotation.loadStatus = RegionLoadFail;
//            }else if (loadStatus == 4){
//                annotation.loadStatus = RegionLoadForNavi;
//            }
 
        }
        [annotationView setCanShowCallout:YES];
        annotationView.annotation = annotation;

        return annotationView;

//        RegionAnnotationView *annotationView;
//        annotationView = (RegionAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
//        
//        if (annotationView == nil) {
//            annotationView = [[RegionAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
//        }
//        if (mapType == RegionNavi) {
//            
//            CGRect frame = annotationView.frame;
//            frame.size.width = 300.0;
//            frame.size.height = 300.0;
//            frame.origin.x = -100;
//            frame.origin.y = 0;
//            annotationView.frame = frame;
//            
//            annotationView.image = [UIImage imageNamed:@"anjuke_icon_esf@2x.png"];
//            annotationView.backgroundColor = [UIColor redColor];
//            annotationView.clipsToBounds = NO;
//            annotationView.acSheetDelegate = self;
//        }
//        [annotationView setCanShowCallout:NO];
//
//        annotationView.annotation = annotation;
//
//        return annotationView;
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

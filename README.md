# LocationManager

> 简单的获取用户的定位信息和手机运营商信息。

![效果图](http://thyrsi.com/t6/361/1534990613x-1404755690.jpg)

## 通过苹果提供的`CoreLocation`类获取定位信息，具体如下：

~~~Swift
import UIKit
import CoreLocation

class LocationManager: NSObject {
    
    private lazy var manager: CLLocationManager = {
        let manager = CLLocationManager()
        // 设置定位服务管理器代理
        manager.delegate = self
        // 设置定位模式
        manager.desiredAccuracy = kCLLocationAccuracyBest
        // 更新距离
        manager.distanceFilter = 100
        // 发送授权申请
        manager.requestWhenInUseAuthorization()
        return manager
    }()
    
    // 当前坐标
    private var curLocation: CLLocation?
    // 当前选中位置的坐标
    private var curAddressCoordinate: CLLocationCoordinate2D?
    // 当前位置地址
    private var curAddress: String?
    
    typealias locationCallBack = (_ curLocation:CLLocation?, _ curAddress:String?, _ errorReason:String?) -> ()
    public var callBack: locationCallBack?
    
    
    static let share: LocationManager = LocationManager()
    
    private override init() {}
    
    // MARK: - actions
    
    public func startLocation(_ complation: @escaping locationCallBack) {
        self.callBack = complation
        if CLLocationManager.locationServicesEnabled() {
            manager.startUpdatingLocation()
        }
    }
}

// MARK: - <CLLocationManagerDelegate>

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //获取最新的坐标
        curLocation = locations.last!
        //停止定位
        if locations.count > 0 {
            manager.stopUpdatingLocation()
            coordinateConvertToAddress()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        callBack!(nil,nil,"定位失败===\(error)")
    }
    
    private func coordinateConvertToAddress() {
        guard let location = self.curLocation else {
            return
        }
        CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in
            guard error == nil else {
                self.callBack!(nil,nil,"\(String(describing: error))")
                return
            }
            let mark = placemark!.first
            self.curAddress = ""
            // 省
            if let administrativeArea = mark?.administrativeArea {
                self.curAddress?.append(administrativeArea)
            }
            // 自治区
            if let subAdministrativeArea = mark?.subAdministrativeArea {
                self.curAddress?.append(subAdministrativeArea)
            }
            // 市
            if let locality = mark?.locality {
                self.curAddress?.append(locality)
            }
            // 区
            if let subLocality = mark?.subLocality {
                self.curAddress?.append(subLocality)
            }
            // 地名
            if let name = mark?.name {
                self.curAddress?.append(name)
            }
            self.callBack!(self.curLocation, self.curAddress, nil)
        }
    }
}
~~~

## 通过`CoreTelephony`类，获取运营商信息，如下：

~~~Swift
// 获取运营商信息
        let info = CTTelephonyNetworkInfo()
        if let carrier = info.subscriberCellularProvider, let currentRadioTech = info.currentRadioAccessTechnology {
            var info = "数据业务信息：\(currentRadioTech)" + "\n"
            info = info + "网络制式：\(getNetworkType(currentRadioTech: currentRadioTech))" + "\n"
            info = info + "运营商名字：\(carrier.carrierName!)" + "\n"
            info = info + "移动国家码(MCC)：\(carrier.mobileCountryCode!)" + "\n"
            info = info + "移动网络码(MNC)：\(carrier.mobileNetworkCode!)" + "\n"
            info = info + "ISO国家代码：\(carrier.isoCountryCode!)" + "\n"
            info = info + "是否允许VoIP：\(carrier.allowsVOIP) "
            self.telephonyInfoLabel.text = info
        }
~~~
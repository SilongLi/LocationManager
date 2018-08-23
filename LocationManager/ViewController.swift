//
//  ViewController.swift
//  LocationManager
//
//  Created by lisilong on 2018/8/22.
//  Copyright © 2018 lisilong. All rights reserved.
//

import UIKit
import CoreTelephony

class ViewController: UIViewController {
    
    lazy var longitudeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.black
        label.sizeToFit()
        return label
    }()
    
    lazy var latitudeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.black
        label.sizeToFit()
        return label
    }()
    
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.black
        label.sizeToFit()
        return label
    }()
    
    lazy var telephonyInfoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let size = UIScreen.main.bounds.size
        view.addSubview(longitudeLabel)
        view.addSubview(latitudeLabel)
        view.addSubview(addressLabel)
        view.addSubview(telephonyInfoLabel)
        longitudeLabel.frame = CGRect.init(x: 0.0, y: 180, width: size.width, height: 30)
        latitudeLabel.frame = CGRect.init(x: 0.0, y: 220, width: size.width, height: 30)
        addressLabel.frame = CGRect.init(x: 0.0, y: 260, width: size.width, height: 30)
        telephonyInfoLabel.frame = CGRect.init(x: 0.0, y: 300, width: size.width, height: 200)
        
        // 经纬度和地区信息
        LocationManager.share.startLocation { [weak self] (location, address, error) in
            guard error == nil else {
                print(error ?? "")
                return
            }
            self?.longitudeLabel.text = "经度：\(location?.coordinate.longitude ?? -0.0)"
            self?.latitudeLabel.text = "纬度：\(location?.coordinate.latitude ?? -0.0)"
            self?.addressLabel.text = "地区：\(address ?? "")"
        }
        
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
    }
    
    // 根据数据业务信息获取对应的网络类型
    func getNetworkType(currentRadioTech: String) -> String {
        var networkType = ""
        switch currentRadioTech {
        case CTRadioAccessTechnologyGPRS:
            networkType = "2G"
        case CTRadioAccessTechnologyEdge:
            networkType = "2G"
        case CTRadioAccessTechnologyeHRPD:
            networkType = "3G"
        case CTRadioAccessTechnologyHSDPA:
            networkType = "3G"
        case CTRadioAccessTechnologyCDMA1x:
            networkType = "2G"
        case CTRadioAccessTechnologyLTE:
            networkType = "4G"
        case CTRadioAccessTechnologyCDMAEVDORev0:
            networkType = "3G"
        case CTRadioAccessTechnologyCDMAEVDORevA:
            networkType = "3G"
        case CTRadioAccessTechnologyCDMAEVDORevB:
            networkType = "3G"
        case CTRadioAccessTechnologyHSUPA:
            networkType = "3G"
        default:
            break
        }
        return networkType
    }
}


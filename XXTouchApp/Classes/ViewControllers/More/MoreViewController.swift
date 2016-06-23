//
//  MoreViewController.swift
//  OneFuncApp
//
//  Created by mcy on 16/6/6.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController {
  private let tableView = UITableView(frame: CGRectZero, style: .Grouped)
  private lazy var serviceList: [String] = {
    let serviceList = [
      "重启服务"
    ]
    return serviceList
  }()
  
  private lazy var iconServiceList: [String] = {
    let iconServiceList = [
      "restar_01"
    ]
    return iconServiceList
  }()
  
  private lazy var authorizationList: [String] = {
    let authorizationList = [
      "授权"
    ]
    return authorizationList
  }()
  
  private lazy var iconAuthorizationList: [String] = {
    let iconAuthorizationList = [
      "authorization"
    ]
    return iconAuthorizationList
  }()
  
  private lazy var settingList: [String] = {
    let settingList = [
      "按键设置",
      "录制设置",
      "开机启动设置",
      "用户偏好设置"
    ]
    return settingList
  }()
  
  private lazy var iconSettingList: [String] = {
    let iconSettingList = [
      "keysettings",
      "recording",
      "startup",
      "user"
    ]
    return iconSettingList
  }()
  
  private lazy var systemList: [String] = {
    let systemList = [
      "应用列表",
      "清空GPS伪装信息",
      "清理UI缓存",
      "全清设备",
      "注销设备",
      "重启设备"
    ]
    return systemList
  }()
  
  private lazy var iconSystemList: [String] = {
    let iconSystemList = [
      "application",
      "gps",
      "uicache",
      "equipment",
      "cancellation",
      "restar_02"
    ]
    return iconSystemList
  }()
  
  private lazy var helpList: [String] = {
    let helpList = [
      "开发文档",
      "关于"
    ]
    return helpList
  }()
  
  private lazy var iconHelpList: [String] = {
    let iconHelpList = [
      "document",
      "about"
    ]
    return iconHelpList
  }()
  
  private lazy var titleList: [String] = {
    let titleList = [
      "服务",
      "授权",
      "设置",
      "系统",
      "帮助"
    ]
    return titleList
  }()
  private var host = ""
  private let remoteButton = UIButton(type: .Custom)
  private let remoteButtonHeight: CGFloat = 40
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    makeConstriants()
    setupAction()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    getDeviceinfo()
  }
  
  private func setupUI() {
    view.backgroundColor = UIColor.whiteColor()
    navigationItem.title = "更多"
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.contentInset.bottom = remoteButtonHeight
    tableView.scrollIndicatorInsets.bottom = tableView.contentInset.bottom
    
    remoteButton.setTitle("远程服务读取中..", forState: .Normal)
    remoteButton.backgroundColor = ThemeManager.Theme.lightTextColor
    remoteButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    remoteButton.alpha = 0.95
    remoteButton.userInteractionEnabled = false
    
    view.addSubview(tableView)
    view.addSubview(remoteButton)
  }
  
  private func makeConstriants() {
    tableView.snp_makeConstraints { (make) in
      make.edges.equalTo(view)
    }
    
    remoteButton.snp_makeConstraints { (make) in
      make.leading.trailing.equalTo(view)
      make.bottom.equalTo(view).offset(-Constants.Size.tabBarHeight)
      make.height.equalTo(remoteButtonHeight)
    }
  }
  
  private func setupAction() {
    remoteButton.addTarget(self, action: #selector(remoteClick(_:)), forControlEvents: .TouchUpInside)
  }
  
}

extension MoreViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return titleList.count
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0: return 1
    case 1: return 1
    case 2: return settingList.count
    case 3: return systemList.count
    case 4: return helpList.count
    default:
      return 0
    }
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 55
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0: return MoreCustomCell(icon: iconServiceList[indexPath.row], title: serviceList[indexPath.row])
    case 1: return MoreCustomCell(icon: iconAuthorizationList[indexPath.row], title: authorizationList[indexPath.row])
    case 2: return MoreCustomCell(icon: iconSettingList[indexPath.row], title: settingList[indexPath.row])
    case 3: return MoreCustomCell(icon: iconSystemList[indexPath.row], title: systemList[indexPath.row])
    case 4: return MoreCustomCell(icon: iconHelpList[indexPath.row], title: helpList[indexPath.row])
    default:
      return UITableViewCell()
    }
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    switch indexPath.section {
    /// 服务
    case 0: return service(indexPath.row)
    /// 授权
    case 1: return authorization(indexPath.row)
    /// 设置
    case 2: return key(indexPath.row)
    /// 系统
    case 3: return system(indexPath.row)
    /// 帮助
    case 4: return help(indexPath.row)
    default:break
    }
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return titleList[section]
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 30
  }
  
  func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0.01
  }
}

// MARK: - 服务
extension MoreViewController {
  private func fetchRemoteAccessStatus() {
    let request = Network.sharedManager.post(url: ServiceURL.Url.isRemoteAccessOpened, timeout:Constants.Timeout.request)
    let session = Network.sharedManager.session()
    let task = session.dataTaskWithRequest(request) { [weak self] data, _, error in
      guard let `self` = self else { return }
      if let data = data {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0:
          if json["data"]["opened"].boolValue {
            self.remoteButton.selected = true
            self.remoteButtonUpdate(self.host, backgroundColor: ThemeManager.Theme.greenBackgroundColor)
          } else {
            self.remoteButton.selected = false
            self.remoteButtonUpdate("远程服务已关闭", backgroundColor: ThemeManager.Theme.lightTextColor)
          }
        default:
          self.alert(title: Constants.Text.prompt, message: json["message"].stringValue, delegate: nil, cancelButtonTitle: Constants.Text.ok)
        }
      }
      if error != nil {
        self.alert(title: Constants.Text.prompt, message: Constants.Error.failure, delegate: nil, cancelButtonTitle: Constants.Text.ok)
      }
      self.remoteButton.userInteractionEnabled = true
    }
    task.resume()
  }
  
  @objc private func remoteClick(button: UIButton) {
    button.userInteractionEnabled = false
    if !button.selected {
      // 打开远程服务
      button.selected = true
      openAndCloseRemoteAccess(ServiceURL.Url.openRemoteAccess)
    } else {
      // 关闭远程服务
      button.selected = false
      openAndCloseRemoteAccess(ServiceURL.Url.closeRemoteAccess)
    }
  }
  
  private func openAndCloseRemoteAccess(url: String) {
    self.view.showHUD()
    let request = Network.sharedManager.post(url: url, timeout:Constants.Timeout.request)
    let session = Network.sharedManager.session()
    let task = session.dataTaskWithRequest(request) { [weak self] data, _, error in
      guard let `self` = self else { return }
      self.view.hideHUD()
      if let data = data {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0:
          self.fetchRemoteAccessStatus()
        default:
          self.alert(title: Constants.Text.prompt, message: json["message"].stringValue, delegate: nil, cancelButtonTitle: Constants.Text.ok)
        }
      }
      if error != nil {
        self.alert(title: Constants.Text.prompt, message: Constants.Error.failure, delegate: nil, cancelButtonTitle: Constants.Text.ok)
      }
    }
    task.resume()
  }
  
  private func remoteButtonUpdate(title: String, backgroundColor: UIColor) {
    self.remoteButton.setTitle(title, forState: .Normal)
    self.remoteButton.backgroundColor = backgroundColor
  }
  
  private func service(rowIndex: Int) {
    switch rowIndex {
    /// 重启服务
    case 0:
      self.alertOther(title: Constants.Text.prompt, message: "确定要重启XXTouch服务么？", delegate: self, cancelButtonTitle: Constants.Text.cancel, otherButtonTitles: Constants.Text.ok, tag: 0)
    default:break
    }
  }
}

// MARK: - 授权
extension MoreViewController {
  private func authorization(rowIndex: Int) {
    switch rowIndex {
    /// 授权
    case 0: self.navigationController?.pushViewController(AuthorizationViewController(), animated: true)
    default:break
    }
  }
}


// MARK: - 设置
extension MoreViewController {
  private func key(rowIndex: Int) {
    switch rowIndex {
    /// 按键设置
    case 0: self.navigationController?.pushViewController(KeyBoardSettingViewController(), animated: true)
    /// 录制设置
    case 1: self.navigationController?.pushViewController(RecordSettingViewController(), animated: true)
    /// 开机启动设置
    case 2: self.navigationController?.pushViewController(StartUpSettingViewController(), animated: true)
    /// 用户偏好设置
    case 3: self.navigationController?.pushViewController(UserSettingViewController(), animated: true)
    default:break
    }
  }
}

// MARK: - 系统
extension MoreViewController {
  private func system(rowIndex: Int) {
    switch rowIndex {
    /// 应用列表
    case 0: self.navigationController?.pushViewController(ApplicationListViewController(), animated: true)
    /// 清空GPS伪装信息
    case 1: self.alertOther(title: Constants.Text.prompt, message: "确定要清空GPS伪装信息么？", delegate: self, cancelButtonTitle: Constants.Text.cancel, otherButtonTitles: Constants.Text.ok, tag: 1)
    /// 清理 UI 缓存
    case 2: self.alertOther(title: Constants.Text.prompt, message: "确定要清理 UI 缓存么？\n（这个操作有可能引起注销或图标不见）", delegate: self, cancelButtonTitle: Constants.Text.cancel, otherButtonTitles: Constants.Text.ok, tag: 2)
    /// 全清设备
    case 3:
      self.alertOther(title: Constants.Text.prompt, message: "确定要全清设备么？\n（这个操作将会关闭所有应用并删除所有应用的资料及重置设备标识信息）", delegate: self, cancelButtonTitle: Constants.Text.cancel, otherButtonTitles: Constants.Text.ok, tag: 3)
    /// 注销设备
    case 4: self.alertOther(title: Constants.Text.prompt, message: "确定要注销设备么？", delegate: self, cancelButtonTitle: Constants.Text.cancel, otherButtonTitles: Constants.Text.ok, tag: 4)
    /// 重启设备
    case 5: self.alertOther(title: Constants.Text.prompt, message: "确定要重启设备么？", delegate: self, cancelButtonTitle: Constants.Text.cancel, otherButtonTitles: Constants.Text.ok, tag: 5)
    default: break
    }
  }
}

// MARK: - 帮助
extension MoreViewController {
  private func help(rowIndex: Int) {
    switch rowIndex {
    /// 开发文档
    case 0:
      let developDocumentViewController = DevelopDocumentViewController()
      developDocumentViewController.hidesBottomBarWhenPushed = true
      self.navigationController?.pushViewController(developDocumentViewController, animated: true)
    /// 关于
    case 1: self.navigationController?.pushViewController(AboutViewController(), animated: true)
    default: break
    }
  }
}

// 获取设备信息
extension MoreViewController {
  private func getDeviceinfo() {
    let request = Network.sharedManager.post(url: ServiceURL.Url.deviceinfo, timeout:Constants.Timeout.request)
    let session = Network.sharedManager.session()
    let task = session.dataTaskWithRequest(request) { [weak self] data, _, error in
      guard let `self` = self else { return }
      if let data = data {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0:
          self.host = "http://"+json["data"]["wifi_ip"].stringValue+":"+json["data"]["port"].stringValue
          self.fetchRemoteAccessStatus()
        default:
          self.alert(title: Constants.Text.prompt, message: json["message"].stringValue, delegate: nil, cancelButtonTitle: Constants.Text.ok)
        }
      }
      if error != nil {
        self.alert(title: Constants.Text.prompt, message: Constants.Error.failure, delegate: nil, cancelButtonTitle: Constants.Text.ok)
      }
    }
    task.resume()
  }
}

extension MoreViewController: UIAlertViewDelegate {
  func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
    switch alertView.tag {
    /// 重启服务
    case 0:
      if buttonIndex == 0 {
        restart()
      }
    /// 清空GPS伪装信息
    case 1:
      if buttonIndex == 0 {
        clearGps()
      }
    /// 清理 UI 缓存
    case 2:
      if buttonIndex == 0 {
        clearUIcache()
      }
    /// 全清设备
    case 3:
      if buttonIndex == 0 {
        clearAll()
      }
    /// 注销设备
    case 4:
      if buttonIndex == 0 {
        respring()
      }
    /// 重启设备
    case 5:
      if buttonIndex == 0 {
        reboot2()
      }
    default: break
    }
  }
  
  private func restart() {
    self.view.showHUD()
    let request = Network.sharedManager.post(url: ServiceURL.Url.restart, timeout:Constants.Timeout.request)
    let session = Network.sharedManager.session()
    let task = session.dataTaskWithRequest(request) { [weak self] data, _, error in
      guard let `self` = self else { return }
      self.view.hideHUD()
      if let data = data {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0:
          self.view.showHUD(.Message, text: "重启成功", autoHide: true, autoHideDelay: 0.5)
        default:
          self.alert(title: Constants.Text.prompt, message: json["message"].stringValue, delegate: nil, cancelButtonTitle: Constants.Text.ok)
        }
      }
      if error != nil {
        self.alert(title: Constants.Text.prompt, message: Constants.Error.failure, delegate: nil, cancelButtonTitle: Constants.Text.ok)
      }
    }
    task.resume()
  }
  
  private func clearGps() {
    self.view.showHUD()
    let request = Network.sharedManager.post(url: ServiceURL.Url.clearGps, timeout:Constants.Timeout.request)
    let session = Network.sharedManager.session()
    let task = session.dataTaskWithRequest(request) { [weak self] data, _, error in
      guard let `self` = self else { return }
      self.view.hideHUD()
      if let data = data {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0:
          self.view.showHUD(.Message, text: "清空成功", autoHide: true, autoHideDelay: 0.5)
        default:
          self.alert(title: Constants.Text.prompt, message: json["message"].stringValue, delegate: nil, cancelButtonTitle: Constants.Text.ok)
        }
      }
      if error != nil {
        self.alert(title: Constants.Text.prompt, message: Constants.Error.failure, delegate: nil, cancelButtonTitle: Constants.Text.ok)
      }
    }
    task.resume()
  }
  
  private func clearUIcache() {
    self.view.showHUD()
    let request = Network.sharedManager.post(url: ServiceURL.Url.clearUIcache, timeout:Constants.Timeout.request)
    let session = Network.sharedManager.session()
    let task = session.dataTaskWithRequest(request) { [weak self] data, _, error in
      guard let `self` = self else { return }
      self.view.hideHUD()
      if let data = data {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0:
          self.view.showHUD(.Message, text: "清理成功", autoHide: true, autoHideDelay: 0.5)
        default:
          self.alert(title: Constants.Text.prompt, message: json["message"].stringValue, delegate: nil, cancelButtonTitle: Constants.Text.ok)
        }
      }
      if error != nil {
        self.alert(title: Constants.Text.prompt, message: Constants.Error.failure, delegate: nil, cancelButtonTitle: Constants.Text.ok)
      }
    }
    task.resume()
  }
  
  private func clearAll() {
    self.view.showHUD()
    let request = Network.sharedManager.post(url: ServiceURL.Url.clearAll, timeout:Constants.Timeout.request)
    let session = Network.sharedManager.session()
    let task = session.dataTaskWithRequest(request) { [weak self] data, _, error in
      guard let `self` = self else { return }
      self.view.hideHUD()
      if let data = data {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0:
          self.view.showHUD(.Message, text: "全清成功", autoHide: true, autoHideDelay: 0.5)
        default:
          self.alert(title: Constants.Text.prompt, message: json["message"].stringValue, delegate: nil, cancelButtonTitle: Constants.Text.ok)
        }
      }
      if error != nil {
        self.alert(title: Constants.Text.prompt, message: Constants.Error.failure, delegate: nil, cancelButtonTitle: Constants.Text.ok)
      }
    }
    task.resume()
  }
  
  private func respring() {
    self.view.showHUD()
    let request = Network.sharedManager.post(url: ServiceURL.Url.respring, timeout:Constants.Timeout.request)
    let session = Network.sharedManager.session()
    let task = session.dataTaskWithRequest(request) { [weak self] data, _, error in
      guard let `self` = self else { return }
      self.view.hideHUD()
      if let data = data {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0:
          self.view.showHUD(.Message, text: "注销成功", autoHide: true, autoHideDelay: 0.5)
        default:
          self.alert(title: Constants.Text.prompt, message: json["message"].stringValue, delegate: nil, cancelButtonTitle: Constants.Text.ok)
        }
      }
      if error != nil {
        self.alert(title: Constants.Text.prompt, message: Constants.Error.failure, delegate: nil, cancelButtonTitle: Constants.Text.ok)
      }
    }
    task.resume()
  }
  
  private func reboot2() {
    self.view.showHUD()
    let request = Network.sharedManager.post(url: ServiceURL.Url.reboot2, timeout:Constants.Timeout.request)
    let session = Network.sharedManager.session()
    let task = session.dataTaskWithRequest(request) { [weak self] data, _, error in
      guard let `self` = self else { return }
      self.view.hideHUD()
      if let data = data {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0:
          self.view.showHUD(.Message, text: "重启成功", autoHide: true, autoHideDelay: 0.5)
        default:
          self.alert(title: Constants.Text.prompt, message: json["message"].stringValue, delegate: nil, cancelButtonTitle: Constants.Text.ok)
        }
      }
      if error != nil {
        self.alert(title: Constants.Text.prompt, message: Constants.Error.failure, delegate: nil, cancelButtonTitle: Constants.Text.ok)
      }
    }
    task.resume()
  }
}

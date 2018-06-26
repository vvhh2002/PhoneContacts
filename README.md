# PhoneContacts

iPhone通讯录应用，基本功能包括通讯录、拨号、网页搜索。

## 安装
- 将项目clone或download至本地
- 在Xcode中打开项目
- 选择真机或模拟器，运行项目

## 功能
- 联系人 Contacts
	- 使用UITableView展示
	- 使用SQLite3存储数据
	- 删除联系人--删
	- 添加联系人信息--增
	- 修改联系人信息--改
	- 列表页增/改后刷新
	- 使用UISearchController 搜索联系人，展示搜索记录--查
	- 新增/编辑联系人页面可收起键盘
	- 联系人分享，调用系统分享功能
	- 拨号按钮，调用系统拨号
	- 通讯录检查：姓名不能为空。
	
- 拨号 Call 
	- 仿原生界面、圆形按钮
	- 拨号键 调用系统拨号功能
	- 拨号显示框有数字时，动态展示删除按钮
	- 拨号显示框有数字时，动态展示通讯录按钮
	- 拨号页面添加至通讯录，使用UIAlertController，显示带文本输入的Alert
	- 通讯录检查：姓名不能为空
	
- 搜索 Search
	- 使用WKWebView 
	- 打开百度页面 

## 示例
- 页面总览  
	<img src="./screenrecords/overview.gif" width="30%" height="30%" />
	<br /> <br /> 
- 添加联系人  
	<img src="./screenrecords/add.gif" width="30%" height="30%" />
	<br /> <br /> 
- 修改联系人  
	<img src="./screenrecords/edit.gif" width="30%" height="30%" />
	<br /> <br /> 
- 删除联系人  
	<img src="./screenrecords/delete.gif" width="30%" height="30%" />
	<br /> <br /> 
- 检索联系人  
	<img src="./screenrecords/search.gif" width="30%" height="30%" />
	<br /> <br /> 
- 分享联系人  
	<img src="./screenrecords/share.gif" width="30%" height="30%" />
	<br /> <br /> 
- 拨打电话  
	<img src="./screenrecords/call.gif" width="30%" height="30%" />
	<br /> <br /> 
- 拨号  
	<img src="./screenrecords/dial_call.gif" width="30%" height="30%" />
	<br /> <br />  
- 新增联系电话  
	<img src="./screenrecords/dial_add.gif" width="30%" height="30%" />

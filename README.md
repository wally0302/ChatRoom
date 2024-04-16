# LineChatRoom
## 描述
這是一個利用 Flutter 和 Firebase 建立的聊天室。
## Demo 

## 功能
- **即時聊天**：使用者可以與其他使用者即時通訊，並且將訊息儲存至 FireStore。
- **創建聊天室**:使用者可以創建多個聊天室。
- **訊息呈現方式**: 訊息下到上為最新到最舊，且訊息內容超過一頁可上下滑動。
- **使用者認證**：透過 Firebase Authentication 實現註冊與登入。
- **個人資料管理**：使用者可以編輯和更新他們的個人訊息。
- **保存登入狀態**:將登入狀態儲存在 local storage，關掉手機不會登出。
- **與 AI 聊天**: 使用 OpenAI API KEY 。
- **搜尋**:使用者可以搜尋其他聊天室，並加入。

## 資料庫欄位
利用 FireStore 儲存資料，以下是各資料表欄位說明。
### User
![User](images/image-2.png)
### Group
![Group](images/image.png)
### Message
![Message](images/image-1.png)


## 應用到的技術
- Flutter
- Firebase Authentication
- Cloud Firestore

## 安裝步驟
- 至 Firebase 進行相關設定，並且要在該專案生成配置文件
- 至 `chat_page.dart`更新 API KEY

```bash
git clone https://github.com/yourusername/ChatApp.git
cd ChatApp
flutterfire configure
flutter pub get
flutter run
```


## 參考資料
- https://firebase.google.com/codelabs/firebase-get-to-know-flutter?hl=zh-tw#0
- https://firebase.google.com/docs/storage?hl=zh-tw
- https://firebase.google.com/docs/auth?hl=zh-tw
- https://www.bing.com/ck/a?!&&p=008f1422a8b46265JmltdHM9MTcxMzIyNTYwMCZpZ3VpZD0zNWZjNTU3ZS00MzI3LTZlNWMtMzFhMi00NjQzNDIzYzZmNWImaW5zaWQ9NTE5Ng&ptn=3&ver=2&hsh=3&fclid=35fc557e-4327-6e5c-31a2-4643423c6f5b&psq=%e5%a6%82%e4%bd%95%e4%bd%bf%e7%94%a8+firebase+auth&u=a1aHR0cHM6Ly9pdGhlbHAuaXRob21lLmNvbS50dy9hcnRpY2xlcy8xMDM0MDA0Nw&ntb=1
- https://www.youtube.com/watch?v=Qwk5oIAkgnY
- https://www.bing.com/ck/a?!&&p=66d48560133657bfJmltdHM9MTcxMzIyNTYwMCZpZ3VpZD0zNWZjNTU3ZS00MzI3LTZlNWMtMzFhMi00NjQzNDIzYzZmNWImaW5zaWQ9NTIyNQ&ptn=3&ver=2&hsh=3&fclid=35fc557e-4327-6e5c-31a2-4643423c6f5b&psq=%e5%a6%82%e4%bd%95%e4%bd%bf%e7%94%a8+firebase+auth&u=a1aHR0cHM6Ly9tZWRpdW0uY29tL0BzaGFpem8vZmlyZWJhc2UtYXV0aGVudGljYXRpb24tcGFydC0xLXVzaW5nLWVtYWlsLXBhc3N3b3JkLWE5ODM3YTc4OGVhNQ&ntb=1
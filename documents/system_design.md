### 業務フロー
<img src="img/%E6%A5%AD%E5%8B%99%E3%83%95%E3%83%AD%E3%83%BC.png" width="500">

### 画面遷移図
<img src="img/%E7%94%BB%E9%9D%A2%E9%81%B7%E7%A7%BB%E5%9B%B3.png" width="500">

### ワイヤーフレーム
<img src="img/%E3%83%AF%E3%82%A4%E3%83%A4%E3%83%BC%E3%83%95%E3%83%AC%E3%83%BC%E3%83%A0.png" width="500">

### テーブル定義
車両テーブル（Vehicles）

| カラム名      | データ型       | NULL | キー | 初期値 | AUTO INCREMENT | 説明 |
| ------------- | -----------|--|--|--|--|----------------------------- |
| vehicle_id    | Integer    ||主キー||YES||
| make          | String     ||||| 車両のメーカー名             |
| model         | String     ||||| 車両のモデル名              |
| year          | Integer    ||||| 車両の製造年                |
| license_plate | String     ||||| ナンバープレート番号        |
| lease_expiry  | Date       |YES|||| リースの満了日              |
| inspection_due| Date       |YES|||| 次の車検日 |

ユーザーテーブル（Users）

| カラム名      | データ型       | NULL | キー | 初期値 | AUTO INCREMENT | 説明 |
| ------------- | -----------|--|--|--|--|----------------------------- |
| user_id      | Integer        ||主キー||YES||
| name         | String         ||||| ユーザー名                  |
| email        | String         ||||| メールアドレス              |
| password     | String         ||||| パスワード（ハッシュ化済み） |

通知テーブル（Notifications）

| カラム名      | データ型       | NULL | キー | 初期値 | AUTO INCREMENT | 説明 |
| ------------- | -----------|--|--|--|--|----------------------------- |
| notification_id | Integer        ||主キー||YES||
| user_id         | Integer   ||外部キー|||通知を受け取るユーザーID   |
| vehicle_id      | Integer    ||外部キー|||通知に関連する車両ID       |
| date            | Date       |||||通知を送る日                |

### システム構成図
<img src="img/VehicleMinders.png width="500">
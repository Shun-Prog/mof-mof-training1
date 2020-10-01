# README

## training(前半)

### 万葉さんの研修カリキュラムを利用
https://github.com/everyleaf/el-training

---
* Ruby version  
2.7.0

* Rails version  
6.0.3.3

* PostgreSQL version  
12.3
---
### テーブルスキーマ設計
##### 凡例
* **モデル名**  
カラム名: 型  
<br>
##### テーブルスキーマ一覧
* **users**
id: integer  
name: string  
email: string  
password: string  
confirmation_password: string  
<br>
* **tasks**  
id: integer  
name: string  
description: text  
user_id: integer  
status: integer  
expired_at: datetime  
priority: integer  
<br>
* **labels**  
id: integer   
name: string  
<br>
* **task_labels**  
id: integer  
task_id: integer  
label_id: integer  

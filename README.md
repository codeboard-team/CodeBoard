# CodeBoard
Enjoy Coding - 享受解題與出題的樂趣

## 簡介 Overview

在全民 Coding 的時代，  有越來越多人進入程式領域學習
[CodeBoard](https://code-board.com/) 陪你寫 Code：
- 線上解題－透過刷題練習，加強邏輯並熟悉語法來累積實力
- 線上出題－開放任意使用者出題，並依個人化安排 Board 題組
- 個人紀錄－解題紀錄 及 視覺化圖表，量化你的努力
- 社群分享－觀摩他人解法，激發新思維
- 應用情境－自我學習／教學應用／同好切磋
- 支援多語言－Ruby、JavaScript、Python

CodeBoard - Waiting for your code !

---

CodeBoard is the best platform to help you enhance your skills, expand your knowledge, interactive with your colleague and also you can create your own questions to anyone who loves coding.

---

## 成果 Demo
- Demo Link：https://code-board.com/  

- 測試帳號：
    - 帳號：codeboard@codeboard.com  
    - 密碼：123456

## 技術 Develop & Tools
- 前端： HTML5 / CSS ( Tailwindcss / SCSS )  /  JavaScript ( jQuery ) / Ace Editor
- 後端： Ruby on Rails
- 資料庫：PostgreSQL
- Docker 容器化技術
- API 串接：Google / GitHub 第三方登入
- 部署： Digital Ocean / Ubuntu 18.04 / Passenger / Nginx / certbot
- 版控： Git / GitHub

## 開發環境 Environment
- Ruby：2.6.5
- Rails：6.0.2
- Database：postgreSQL
- Docker

## 使用須知 Instructions

請於 clone 專案前依上述版本建置開發環境，並完成 Docker 安裝（ 請至 [Docker 官方網站](https://www.docker.com/products/docker-desktop) 下載 ）

### 步驟 1：安裝套件
* 使用終端機進入專案目錄
* 確保已完成安裝所需套件
```
$ bundle install
```
```
$ yarn --check-files
```
### 步驟 2：建立資料庫
* 複製 config / database.yml.example 內容
* 新增 config / database.yml 檔案，並將複製內容貼上，並更改相關設定
* 建立資料庫
```
$ rails db:create
```
* 建立資料表
```
$ rails db:migrate
```
### 步驟 3：程式語言版號設定

* 複製 config / application.yml.example 內容
* 新增 config / application.yml 檔案，並將複製內容貼上（ 可依需求進行版號調整 ）

### 步驟 4：開啟 Server

* 在終端機輸入指令
```
$ rails s
```
* 打開瀏覽器輸入localhost:3000，即可開啟專案

## 團隊 Member
- Henry Tsai
    - Email: henry88002605@gmail.com
    - GitHub: [Sheng-wei-Tsai](https://github.com/Sheng-wei-Tsai)
- Eudora Huang
    - Email: eudora.hsj@gmail.com
    - Medium: [eudora-hsj](https://medium.com/eudora-hsj)
    - GitHub: [eudora-hsj](https://github.com/eudora-hsj)

- Luke Tai
    - Email: kjd1760@gmail.com
    - GitHub: [Luke1760](https://github.com/Luke1760)
- Boyu Chen
    - Email: rider945@outlook.com
    - GitHub: [ItsBoyu](https://github.com/ItsBoyu)

## License
Copyright 2020 © CodeBoard

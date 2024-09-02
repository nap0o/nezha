# 使用教程请移步上游源项目地址,并给源项目关注和Star!
### https://github.com/fscarmen2/Argo-Nezha-Service-Container

### 1.Cloudflare Tunnel设置
<img width="1054" alt="image" src="https://github.com/nap0o/nezha/assets/144927971/8ba04207-e71a-4309-9e24-de2dd6cb48d6">

### 2.新建 containers,选择Node.js Container stack,等待创建完成
<img width="488" alt="image" src="https://github.com/nap0o/nezha/assets/144927971/dad1e139-3b0d-4022-b02d-b3356f24165a">

### 3.管理新建的containers,设置启动命令和端口，注：如果containers是run状态，先stop
<img width="1260" alt="image" src="https://github.com/nap0o/nezha/assets/144927971/fb722f2a-5a59-48a2-9833-d2877b6d96da">

### 4.设置相关参数
<img width="936" alt="image" src="https://github.com/nap0o/nezha/assets/144927971/5cc0ed54-2e3c-41f1-937f-bbea7d438d4e">

### 5.点击Run,进入workspace后台
<img width="730" alt="image" src="https://github.com/nap0o/nezha/assets/144927971/bd1e59ec-0865-49d5-a0dd-a4dad0a49d9f">

### 6.下载项目文件到本地,并上传下图3个文件到项目目录
<img width="289" alt="image" src="https://github.com/nap0o/nezha/assets/144927971/3ee759e4-b055-4942-8af2-d5cbd92d219e">

<img width="342" alt="image" src="https://github.com/nap0o/nezha/assets/144927971/bb69a7b8-8849-42b7-b2c9-d4a35e0e27f4">

### 5.点击下方工具栏,切换到TERMIANL
<img width="977" alt="image" src="https://github.com/nap0o/nezha/assets/144927971/fbb05ff6-30db-4daa-bec0-7bcc4f7b2eb7">

### 6.在TERMIANL中依次执行

- npm install -g pm2
- npm install -r package.json
- node main.js

### 7.出现如下日志后,部署成功
<img width="383" alt="image" src="https://github.com/nap0o/nezha/assets/144927971/6449d0fe-deda-413e-9eb7-2fcdd6d324c2">









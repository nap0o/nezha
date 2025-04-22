#!/usr/bin/env bash

# backup.sh 传参 a 自动更新面板 app 文件及 cloudflared 文件； 传参 f 强制更新面板 app 文件及 cloudflared 文件

WORK_DIR=

########

warning() { echo -e "\033[31m\033[01m$*\033[0m"; }  # 红色
error() { echo -e "\033[31m\033[01m$*\033[0m" && exit 1; } # 红色
info() { echo -e "\033[32m\033[01m$*\033[0m"; }   # 绿色
hint() { echo -e "\033[33m\033[01m$*\033[0m"; }   # 黄色

# 检查更新面板主程序 app 及 cloudflared
cd $WORK_DIR
DASHBOARD_NOW="v$(./app -v)"
#DASHBOARD_LATEST=$(wget -qO- "https://api.github.com/repos/naiba/nezha/releases/latest" | awk -F '"' '/"tag_name"/{print $4}')
DASHBOARD_LATEST="v0.20.13"
[[ "$DASHBOARD_LATEST" =~ ^v([0-9]{1,3}\.){2}[0-9]{1,3}$ && "$DASHBOARD_NOW" != "$DASHBOARD_LATEST" ]] && DASHBOARD_UPDATE=true

CLOUDFLARED_NOW=$(./cloudflared -v | awk '{for (i=0; i<NF; i++) if ($i=="version") {print $(i+1)}}')
CLOUDFLARED_LATEST=$(wget -qO- https://api.github.com/repos/cloudflare/cloudflared/releases/latest | awk -F '"' '/tag_name/{print $4}')
[[ "$CLOUDFLARED_LATEST" =~ ^20[0-9]{2}\.[0-9]{1,2}\.[0-9]+$ && "$CLOUDFLARED_NOW" != "$CLOUDFLARED_LATEST" ]] && CLOUDFLARED_UPDATE=true

# 更新面板和 resource
if [[ "${DASHBOARD_UPDATE}" =~ 'true' ]]; then
  hint "\n Renew dashboard app to $DASHBOARD_LATEST \n"
  hint "\n$(pm2 delete all)\n"
  wget -O $WORK_DIR/app https://github.com/nap0o/nezha/releases/download/nezha-dashboard/app && chmod +x $WORK_DIR/app
  # 重启服务
  hint "\n$(pm2 start $WORK_DIR/ecosystem.config.js)\n"
  sleep 2
fi

# 更新 cloudflared
if [[ "${CLOUDFLARED_UPDATE}" =~ 'true' ]]; then
  hint "\n Renew Cloudflared to $CLOUDFLARED_LATEST \n"
  hint "\n$(pm2 delete all)\n"
  sleep 5
  wget -nv -O $WORK_DIR/cloudflared https://github.com/nap0o/nezha/releases/download/cloudflared/cloudflared-linux-amd64 && chmod +x $WORK_DIR/cloudflared
  # 重启服务
  hint "\n$(pm2 start $WORK_DIR/ecosystem.config.js)\n"
  sleep 5
fi


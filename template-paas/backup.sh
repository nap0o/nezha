#!/usr/bin/env bash

# backup.sh 传参 a 自动还原； 传参 m 手动还原； 传参 f 强制更新面板 app 文件及 cloudflared 文件，并备份数据至成备份库

GH_PAT=
GH_BACKUP_USER=
GH_EMAIL=
GH_REPO=
WORK_DIR=
DAYS=5

########

warning() { echo -e "\033[31m\033[01m$*\033[0m"; }  # 红色
error() { echo -e "\033[31m\033[01m$*\033[0m" && exit 1; } # 红色
info() { echo -e "\033[32m\033[01m$*\033[0m"; }   # 绿色
hint() { echo -e "\033[33m\033[01m$*\033[0m"; }   # 黄色

# 手自动标志
[ "$1" = 'a' ] && WAY=Scheduled || WAY=Manualed
[ "$1" = 'f' ] && WAY=Manualed && FORCE_UPDATE=true

# 检测是否有设置备份数据
if [[ -n "$GH_REPO" && -n "$GH_BACKUP_USER" && -n "$GH_EMAIL" && -n "$GH_PAT" ]]; then
  IS_PRIVATE="$(wget -qO- --header="Authorization: token $GH_PAT" https://api.github.com/repos/$GH_BACKUP_USER/$GH_REPO | sed -n '/"private":/s/.*:[ ]*\([^,]*\),/\1/gp')"
  if [ "$?" != 0 ]; then
    warning "\n Could not connect to Github. Stop backup. \n"
  elif [ "$IS_PRIVATE" != true ]; then
    warning "\n This is not exist nor a private repository. \n"
  else
    IS_BACKUP=true
  fi
fi

# 分步骤处理
if [[ "${IS_BACKUP}${FORCE_UPDATE}" =~ true ]]; then
  # 克隆备份仓库，压缩备份文件，上传更新
  if [ "$IS_BACKUP" = 'true' ]; then
    # 克隆现有备份库
    [ -d $WORK_DIR/$GH_REPO ] && rm -rf $WORK_DIR/$GH_REPO
    git clone https://$GH_PAT@github.com/$GH_BACKUP_USER/$GH_REPO.git --depth 1 --quiet $WORK_DIR/$GH_REPO
  
    # 压缩备份数据，只备份 data/ 目录下的 config.yaml 和 sqlite.db； resource/ 目录下名字有 custom 的自定义主题文件夹
    if [ -d $WORK_DIR/$GH_REPO ]; then
      cd $WORK_DIR
      TIME=$(date "+%Y-%m-%d-%H:%M:%S")
      echo "↓↓↓↓↓↓↓↓↓↓ dashboard-$TIME.tar.gz list ↓↓↓↓↓↓↓↓↓↓"
      find resource/ -type d -name "*custom*" | tar czvf $WORK_DIR/$GH_REPO/dashboard-$TIME.tar.gz -T- data/
      echo -e "↑↑↑↑↑↑↑↑↑↑ dashboard-$TIME.tar.gz list ↑↑↑↑↑↑↑↑↑↑\n\n"
  
      # 更新备份 Github 库，删除 5 天前的备份
      cd $WORK_DIR/$GH_REPO
      [ -e ./.git/index.lock ] && rm -f ./.git/index.lock
      echo "dashboard-$TIME.tar.gz" > README.md
      find ./ -name '*.gz' | sort | head -n -$DAYS | xargs rm -f
      git config --global user.name $GH_BACKUP_USER
      git config --global user.email $GH_EMAIL
      git checkout --orphan tmp_work
      git add .
      git commit -m "$WAY at $TIME ."
      git push -f -u origin HEAD:main --quiet
      IS_BACKUP="$?"
      cd ..
      rm -rf $GH_REPO
      [ "$IS_BACKUP" = 0 ] && echo "dashboard-$TIME.tar.gz" > $WORK_DIR/dbfile && info "\n Succeed to upload the backup files dashboard-$TIME.tar.gz to Github.\n" || hint "\n Failed to upload the backup files dashboard-$TIME.tar.gz to Github.\n"
    fi
  fi
fi

[ $(supervisorctl status all | grep -c "RUNNING") = $(grep -c '\[program:.*\]' $WORK_DIR/damon.conf) ] && info "\n All programs started! \n" || error "\n Failed to start program! \n"

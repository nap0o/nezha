FROM nap0o/nezha:choreo

USER 10086

# 设置 git 环境变量，减少系统开支
RUN git config --global core.bigFileThreshold 1k &&\
    git config --global core.compression 0 &&\
    git config --global advice.detachedHead false &&\
    git config --global pack.threads 1 &&\
    git config --global pack.windowMemory 50m &&\
    git config --global user.email "choreo@example.com" &&\
    git config --global user.name "Choreo Deploy"

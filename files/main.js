const express = require("express");
const { exec } = require("child_process");
const fs = require("fs");
const path = require("path");
const app = express();
const port = process.env.PORT || 3000;
const work_dir = process.env.WORK_DIR || "/tmp/dashboard";

const executeCommand = async (command, successMessage) => {
  try {
    const output = await new Promise((resolve, reject) => {
      exec(command, (err, stdout, stderr) => {
        if (err) {
          reject(err);
        } else {
          resolve(stdout);
        }
      });
    });
    console.log(successMessage);
    return output;
  } catch (err) {
    console.error("发生错误:", err.message);
    throw err;
  }
};

// 执行初始化脚本
executeCommand("bash init.sh", "初始化脚本执行成功").catch((err) => {
  console.error("初始化脚本执行错误:", err.message);
});

// 用pm2启动服务和监测服务状态
const keep_pm2 = async () => {
  // 检查 pm2 命令是否存在
  await executeCommand("command -v pm2", "pm2 命令存在");

  // 定义 ecosystem.config.js 文件路径
  const ecosystemConfigPath = path.join(work_dir, "ecosystem.config.js");

  // 检查 ecosystem.config.js 文件是否存在
  if (!fs.existsSync(ecosystemConfigPath)) {
    console.error("ecosystem.config.js 文件不存在");
    return;
  }

  // 获取 pm2 服务列表
  const pm2ListOutput = await executeCommand("pm2 jlist", "获取 pm2 服务列表成功");
  const pm2Processes = JSON.parse(pm2ListOutput);

  if (pm2Processes.length === 0) {
    console.log(`pm2 正在启动所有服务...`);
    await executeCommand(`pm2 start ${work_dir}/ecosystem.config.js`, "pm2 启动服务成功");
  } else {
    console.log("检查 pm2 各个服务运行状态");
    // 使用 for...of 循环确保等待所有异步操作完成
    for (const pm2Service of pm2Processes) {
      try {
        if (pm2Service.pm2_env.status !== 'online') {
          console.log(`${pm2Service.pm2_env.pm_id}:${pm2Service.name} 运行异常，正在重启...`);
          await executeCommand(`pm2 restart ${pm2Service.pm2_env.pm_id}`, `${pm2Service.pm2_env.pm_id}:${pm2Service.name} 重启成功`);
        } else {
          console.log(`${pm2Service.pm2_env.pm_id}:${pm2Service.name} 正常运行中...`);
        }
      } catch (error) {
        console.error(`处理 ${pm2Service.pm2_env.pm_id}:${pm2Service.name} 服务时发生错误：`, error.message);
      }
    }
  }
};

// 循环执行 keep_pm2 函数
const random_interval = Math.floor(Math.random() * 70) + 60;
setInterval(keep_pm2, random_interval * 1000);

// 定义路由
app.get("/", (req, res) => {
  res.send("Hello Node.js");
});

// 启动 Express 应用
app.listen(port, (err) => {
  if (err) {
    console.error("Express 应用启动错误:", err.message);
  } else {
    console.log(`Express 应用正在监听端口 ${port}`);
  }
});

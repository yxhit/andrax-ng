#!/usr/bin/bash
pkg install tree proot ccrypt wget -y 
if [ $? -eq 0 ];then
echo "ok"
else
echo "安装所需环境失败，请检查环境是否安装成功。"
exit 1
fi
clear
folder=andrax 
if [ -d "$folder" ]; then 
echo "跳过新建目录，检查安装文件是否存在。" 
else 
mkdir -p "$folder" 
mkdir -p tmp
chmod 1777 tmp
fi 
tarball="ANDRAX-NG-Portable-v1002.tar.xz.cpt"
if [ -f "$tarball" ]; then
echo "安装文件存在进行项目安装。"
else
echo "安装文件不存在，请检查安装文件名是否为ANDRAX-NG-Portable-v1002.tar.xz.cpt."
exit 1
fi
cur=$(pwd) 
mv "$tarball" "$folder"
# 进入目标文件夹 
cd "$folder" # 使用 ccrypt 解密文件 
echo "正在解密安装文件，请稍等...预计五分钟左右。请保持屏幕常亮。" 
ccrypt -d -K "#TryHarder?HowifYOUareEASY#" "$tarball" 
# 解密后， 将文件重命名为 tarball 中引用的名称 
mv "${tarball%.cpt}" "$tarball" 
# 解压 Rootfs 
echo "Decompressing Rootfs, please be patient ...sabaaaar bos .ngopi aja dulu" 
proot --link2symlink tar -xvf "$tarball" --exclude='dev' 
# 返回到原始目录 
cd "$cur" 
# 创建启动脚本 
bin=andrax.sh 
rm -f "$bin" 
echo "writing launch script" 
echo '''#!/bin/bash 
unset LD_PRELOAD 
command="proot" 
command+=" --link2symlink" 
command+=" --kill-on-exit"
command+=" -S ./andrax" 
command+=" -b /sys" 
command+=" -b /dev" 
command+=" -b /proc" 
command+=" -b $HOME/tmp:/tmp"
command+=" -w /home/andrax" 
command+=" /usr/bin/env -i" 
command+=" HOME=/root" 
command+=" PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games" 
command+=" TERM=$TERM" 
command+=" LANG=C.UTF-8" 
command+=" /bin/zsh --login" 
com="$@" 
if [ -z "$1" ];then 
exec $command 
else $command -c "$com" 
fi ''' > "$bin" 
# 使启动脚本可执行 
chmod +x "$bin" 
# 运行启动脚本 
./"$bin"

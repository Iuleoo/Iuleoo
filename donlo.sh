#!/bin/bash
echo "-------------开始配置基础环境------------" 
echo "-------------安装vim-------------------"
yum install vim
echo "-------------安装yum-------------------"
yum install yum
echo "-------------执行更新修复依赖------------"
yum install update
yum -f install -y
echo "-------------安装java---------------"
# java下载配置
cd /home/
echo "获取JDK安装包！"
wget https://download.java.net/java/GA/jdk19/877d6127e982470ba2a7faa31cc93d04/36/GPL/openjdk-19_linux-x64_bin.tar.gz
if [ -f openjdk-19_linux-x64_bin.tar.gz ];then
        tar -xf openjdk-19_linux-x64_bin.tar.gz
else
        echo"安装失败，重新下载。"
        cd /home
        wget https://download.java.net/java/GA/jdk19/877d6127e982470ba2a7faa31cc93d04/36/GPL/openjdk-19_linux-x64_bin.tar.gz &>/dev/null
fi

jdkTargz="/home/openjdk-19_linux-x64_bin.tar.gz"

echo "开始检查原先是否已配置JAVA环境变量！"
checkExist(){
	jdk1=$(grep -n "export JAVA_HOME=.*" /etc/profile | cut -f1 -d':')
        if [ -n "$jdk1" ];then
                echo "JAVA_HOME已配置-->已删除"
                sed -i "${jdk1}d" /etc/profile
        fi
	jdk2=$(grep -n "export CLASSPATH=.*\$JAVA_HOME.*" /etc/profile | cut -f1 -d':')
        if [ -n "$jdk2" ];then
                echo "CLASSPATH路径已配置-->已删除"
                sed -i "${jdk2}d" /etc/profile
        fi
	jdk3=$(grep -n "export PATH=.*\$JAVA_HOME.*" /etc/profile | cut -f1 -d':')
        if [ -n "$jdk3" ];then
                echo "PATH-JAVA路径已配置-->已删除"
                sed -i "${jdk3}d" /etc/profile
        fi
}

# 查询是否有jdk.tar.gz
if [ -e $jdkTargz ];
then

echo "— — 存在jdk压缩包 — —"
	echo "正在解压jdk压缩包..."
	tar -zxvf /home/openjdk-19_linux-x64_bin.tar.gz -C /home
	if [ -e "/usr/java" ];then
		echo "存在该文件夹，删除..."
		rm -rf /usr/java
	fi
	echo "----------------------------------------"
	echo "正在建立JDK文件路径..."
	echo "----------------------------------------"
	mkdir -p /usr/java/
	mv /home/jdk-19 /usr/java/
	
# 检查配置信息
	checkExist	
	echo "----------------------------------------"
	echo "正在配置jdk环境..."
	sed -i '$a export JAVA_HOME=/usr/java/jdk-19' /etc/profile
	sed -i '$a export CLASSPATH=$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib' /etc/profile
	sed -i '$a export PATH=$JAVA_HOME/bin:$PATH' /etc/profile

	echo "----------------------------------------"
	echo "JAVA环境配置已完成..."
	echo "----------------------------------------"
    echo "正在重新加载配置文件..."
    echo "----------------------------------------"
    source /etc/profile
    echo "配置版本信息如下："
    echo "----------------如自行使用 Java --version 无此命令，重启即可 -----------------"
		echo "--------------------------------By Tkchole ---------------------------------"
    java -version
else
	echo "未检测到安装包，请将安装包放到/home目录下"
fi

echo "-------------配置Tomcat---------------"
#Tomcat下载配置
cd /home/
echo "-------------获取Tomcat包！-------------"
wget https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.82/bin/apache-tomcat-8.5.82.tar.gz
if [ -f apache-tomcat-8.5.82.tar.gz ];then
        tar -xf apache-tomcat-8.5.82.tar.gz
else
        echo"-------------安装失败，重新下载。-------------"
        cd /home/
        wget https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.82/bin/apache-tomcat-8.5.82.tar.gz
fi

tomcatTar="/home/apache-tomcat-8.5.82.tar.gz"

if [ -e $tomcatTar ];then
    
    echo "-------------正在建立Tomcat路径-------------"
    if [ -e "/usr/local/tomcat" ];then
		echo "存在该文件夹，删除。。"
		rm -rf /usr/local/tomcat
	fi
    echo "---------------------------------"
    mkdir -p /usr/local/tomcat
    mv -f /home/apache-tomcat-8.5.82 /usr/local/tomcat
    echo "CATALINA_HOME=/usr/local/tomcat">>/usr/local/tomcat/apache-tomcat-8.5.82/bin/catalina.sh

    echo "-------------Tomcat配置已完成-------------"
    /usr/local/tomcat/apache-tomcat-8.5.82/bin/startup.sh & >>/dev/null

else
	echo "未检测到安装包，请检查网络或者查看 Home 目录下是否有 tomcat 包"
fi

echo "----------------------------------------------------------------"
echo "-------------命令执行完成"
echo "-------------如在此脚本下安装的Java"
echo "-------------请重启后执行：/usr/local/tomcat/apache-tomcat-8.5.82/bin/startup.sh"
echo "-------------即可启动Tomcat"


echo "----------------------------------------------------------------"
echo "安装完成"
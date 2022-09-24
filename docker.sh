docker pull centos
docker images
#docker images -a -q (只读取ID)
echo -n "输入需创建容器的镜像id："
read name 
echo "容器将在id -- $name -- 镜像下创建"

#id=$(docker ps -a -q)
# 获取所需容器ID
#echo "下面操作将在此容器ID执行："$id

docker run -itd -p 80:8080 $name /bin/bash 
echo "创建完成"

container=$(docker ps -a -q)
echo ""
docker exec -it $container /bin/bash

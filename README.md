#  地图瓦片命名工具

```
USAGE: rename [--source <source>] [-x <x>] [-y <y>] [-p <p>] [--destination <destination>] [--verbose]

OPTIONS:
  -s, --source <source>   The tiles file path
  -x <x>                  The x-axis value（0...15）. (default: 0)
  -y <y>                  The x-axis value（0...15）. (default: 0)
  -p <p>                  The name prefix. eg prefix_z_x_y . 
  -d, --destination <destination>
                          The tiles file destination folder name 
  --verbose
  -h, --help              Show help information.

```
## x/y 参数说明

使用x/y定义一批图片所对应地图的区域，1.0版本的地图对应都是(4,4)
![](https://chaos-images.oss-cn-beijing.aliyuncs.com/des.jpg)

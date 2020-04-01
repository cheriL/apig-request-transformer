# apig-request-transformer
Transform the request sent by a client on the fly on Kong, before hitting the upstream server.
The plugin implements parameter transformations and additions of various positions.

请求参数转换插件是对客户端发起的请求类型及报文内的参数进行修改，处理在客户端请求经过网关到上游服务器之间，涉及到的参数位置有head,query,path(uri)

### 目录结构

```
apig-request-transformer
├─ apig-request-transformer-0.2.0-1.rockspec  //插件使用luarocks安装卸载，rockspec是插件包的安装描述文件
└─ kong
   └─ plugins
      └─ apig-request-transformer
         ├─ handler.lua //基础模块，封装openresty的不同阶段的调用接口
         ├─ schema.lua //配置模块，定义插件的配置
         ├─ access.lua //access阶段的处理模块
         └─ path_params.lua //path参数处理模块
```
### 配置说明
这里对schema模块的配置项进行说明。

```
config.httpMethod 修改请求的类型
config.backendContentType 修改请求head里Content-Type字段
config.requestPath 控制台下发的api请求路径
config.backendPath 控制台下发的上游服务器路径
config.pathParams 请求路径中的参数组成的列表
config.replace 参数映射表
config.add 参数附加表
```

### Example:

*declarative configuration file:*
```
plugins:
- name: apig-request-transformer
  config:
    httpMethod: POST
    backendContentType: application/json
    replace:
    - head:id;body:id
    - head:sortAs;body:aortAs
    - head:para;body:glossDef.para
    - query:glossSeeAlso1;body:glossDef.glossSeeAlso
    - query:glossSeeAlso2;body:glossDef.glossSeeAlso
```

*request code:*
```
GET     /example?glossSeeAlso1=GML&glossSeeAlso2=XML   HTTP/1.1
id: x-id-example
sortAs: SGML
para: A meta-markup language
```

*transformed request code:*
```
POST     /example   HTTP/1.1
Content-Type: application/json
Content-Length: 139
{
	"id": "x-id-example",
	"sortAs": "SGML",
	"glossDef": {
		"para": "A meta-markup language",
		"glossSeeAlso": ["GML", "XML"]
	}
}
```

### Installation：

```
$ git clone https://github.com/cheriL/apig-request-transformer /opt/kong/plugins 
$ cd /opt/kong/plugins/apig-request-transformer 
$ luarocks make
```

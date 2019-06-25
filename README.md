inspur-request-transformer
===
Kong plugin to transform the request

Configuration
---
Configure this plugin on a Route by adding this section do your declarative configuration file:<br>
plugins:<br>
- name: apig-request-transformer<br>
  route: { route }<br>
  config:<br>
    httpMethod: POST<br>
    backendContentType: application/json<br>
    replace:<br>
    - query:param1;head:key1<br>
    - head:param2;query:key2<br>
    - head:id;body:id<br>
    - head:sortAs;body:aortAs<br>
    - head:para;body:glossDef.para<br>
    - head:glossSeeAlso1;body:glossDef.glossSeeAlso<br>
    - head:glossSeeAlso2;body:glossDef.glossSeeAlso<br>
    add:<br>
    - head:key3:value1<br>
    -query:key4:value2<br>

Parameters
---
name apig-request-transformer<br>
config.httpMethod Changes the HTTP method for the upstream request.<br>
config.backendContentType Only support "application/json" currently<br>
config.requestPath The request path with parameters.<br>
config.backendPath  The upstream request with parameters.<br>
config.pathParams  List of parameters from config.requestPath.<br>
config.replace  List of parameter mappings.<br>
config.add   List of constants.<br>

Examples
---
declarative configuration file:<br>
plugins:<br>
- name: apig-request-transformer<br>
  config:<br>
    httpMethod: POST<br>
    backendContentType: application/json<br>
    replace:<br>
    - head:id;body:id<br>
    - head:sortAs;body:aortAs<br>
    - head:para;body:glossDef.para<br>
    - query:glossSeeAlso1;body:glossDef.glossSeeAlso<br>
    - query:glossSeeAlso2;body:glossDef.glossSeeAlso<br>

request code:<br>
GET     /example?glossSeeAlso1=GML&glossSeeAlso2=XML   HTTP/1.1<br>
id: x-id-example<br>
sortAs: SGML<br>
para: A meta-markup language<br>

transformed request code:<br>
POST     /example   HTTP/1.1<br>
Content-Type: application/json<br>
Content-Length: 139<br>
{
	"id": "x-id-example",
	"sortAs": "SGML",
	"glossDef": {
		"para": "A meta-markup language",
		"glossSeeAlso": ["GML", "XML"]
	}
}

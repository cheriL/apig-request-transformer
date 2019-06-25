inspur-request-transformer
===
Kong plugin to transform the request

Configuration
---
Configure this plugin on a Route by adding this section do your declarative configuration file:
plugins:
- name: apig-request-transformer
  route: { route }
  config:
    httpMethod: POST
    backendContentType: application/json
    replace:
    - query:param1;head:key1
    - head:param2;query:key2
    - head:id;body:id
    - head:sortAs;body:aortAs
    - head:para;body:glossDef.para
    - head:glossSeeAlso1;body:glossDef.glossSeeAlso
    - head:glossSeeAlso2;body:glossDef.glossSeeAlso
    add:
    - head:key3:value1
    -query:key4:value2

Parameters
---
name apig-request-transformer
config.httpMethod Changes the HTTP method for the upstream request.
config.backendContentType Only support "application/json" currently
config.requestPath The request path with parameters.
config.backendPath  The upstream request with parameters.
config.pathParams  List of parameters from config.requestPath.
config.replace  List of parameter mappings.
config.add   List of constants.

Examples
---
declarative configuration file:
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

request code:
GET     /example?glossSeeAlso1=GML&glossSeeAlso2=XML   HTTP/1.1
id: x-id-example
sortAs: SGML
para: A meta-markup language

transformed request code:
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

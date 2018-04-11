<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<base href="<%=basePath%>">

<title>My JSP 'index.jsp' starting page</title>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">
</head>
<script src="jquery-1.10.2.min.js"></script>

<script type="text/javascript" src="jquery.qrcode.min.js"></script>
<script type="text/javascript">
	var websocket = null;

	function connect() {
		var userid = document.getElementById('name').value;
		
		//判断当前浏览器是否支持WebSocket  
		if ('WebSocket' in window) {
			websocket = new WebSocket("ws://localhost:8080/WebSocketDemo/websocket/" + userid);
			console.log("link success")

			//连接发生错误的回调方法  
			websocket.onerror = function() {
				setMessageInnerHTML("error");
			};

			//连接成功建立的回调方法  
			websocket.onopen = function() {
				setMessageInnerHTML("open");
			}

			//接收到消息的回调方法  
			websocket.onmessage = function(event) {
				setMessageInnerHTML(event.data);
			}

			//连接关闭的回调方法  
			websocket.onclose = function() {
				setMessageInnerHTML("退出了聊天室");
			}
		} else {
			alert('当前浏览器 Not support websocket')
		}
	}

	//将消息显示在网页上
	function setMessageInnerHTML(innerHTML) {
		document.getElementById('message').innerHTML += innerHTML + '<br/>';
	}

//将消息显示在网页上
	function setCameraResult(innerHTML) {
		document.getElementById('result').innerHTML += innerHTML + '<br/>';
	}

	//监听窗口关闭事件，当窗口关闭时，主动去关闭websocket连接，防止连接还没断开就关闭窗口，server端会抛异常。  
	window.onbeforeunload = function() {
		closeWebSocket();
	}

	//关闭WebSocket连接  
	function closeWebSocket() {
		websocket.close();
	}

	function send() {
		var sender = document.getElementById('name').value;
		var message = document.getElementById('text').value;
		var jsonstr = '{\"sender\":\"name\",\"To\":\"All\",\"message\":\"obj\"}';

		websocket.send(jsonstr.replace('obj', message).replace('name', sender));
	}

	function buildQRcode() {
		//生成100*100(宽度100，高度100)的二维码
		var name = document.getElementById('name').value;
		$("#output").empty();
jQuery('#output').qrcode({
    render: "canvas", //也可以替换为table
    width: 100,
    height: 100,
    text: "{\"timestanp\":\"as\",\"name\":\""+name+"\"}"
});
$("#result").empty();
	setCameraResult("请用手机扫描二维码");
	}
</script>
<body>



	Welcome
	<br />
	<input id="name" type="text" />
	<button onclick="connect()">输入ID连接</button>
	<br />
	<br />
	<input id="text" type="text" />
	<button onclick="send()">发送消息</button>
	<br />
	<br />
	<div id="output"></div>
	<br />
	<div id="result"></div>
	<br />
	<button onclick="buildQRcode()">生成二维码</button>
	<hr />
	<button onclick="closeWebSocket()">退出聊天</button>
	<hr />

	<div id="message"></div>
</body>
</html>

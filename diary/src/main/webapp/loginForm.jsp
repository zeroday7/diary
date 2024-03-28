<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
	// 0. 로그인(인증) 분기
	// diary.login.my_session => 'ON' => redirect("diary.jsp")
	String sql1 = "select my_session mySession from login";
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	PreparedStatement stmt1 = null;
	ResultSet rs1 = null;
	conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	stmt1 = conn.prepareStatement(sql1);
	rs1 = stmt1.executeQuery();
	String mySession = null;
	if(rs1.next()) {
		mySession = rs1.getString("mySession");
	}
	if(mySession.equals("ON")) {
		response.sendRedirect("/diary/diary.jsp");
		return; // 코드 진행을 끝내는 문법 ex) 메서드 끝낼때 return사용
	}

	// 1. 요청값 분석
	String errMsg = request.getParameter("errMsg");
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
</head>
<body>
	<div>
		<%
			if(errMsg != null) {
		%>
				<%=errMsg%>
		<%		
			}
		%>
	</div>
	<h1>로그인</h1>
	<form method="post" action="/diary/loginAction.jsp">
		<div>memberId :<input type="text" name="memberId"></div>
		<div>memberPw :<input type="password" name="memberPw"></div>
		<div><button type="submit">로그인</button></div>
	</form>
</body>
</html>
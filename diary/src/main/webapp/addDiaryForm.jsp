<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.*"%>
<%
// 0. 로그인(인증) 분기
// diary.login.my_session => 'OFF' => redirect("loginForm.jsp")

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
	// diary.login.my_session => 'OFF' => redirect("loginForm.jsp")
	if(mySession.equals("OFF")) {
		String errMsg = URLEncoder.encode("잘못된 접근 입니다. 로그인 먼저 해주세요", "utf-8");
		response.sendRedirect("/diary/loginForm.jsp?errMsg="+errMsg);
		return; // 코드 진행을 끝내는 문법 ex) 메서드 끝낼때 return사용
	}
%>

<%
	String checkDate = request.getParameter("checkDate");
	if(checkDate == null) {
		checkDate = "";
	}
	String ck = request.getParameter("ck");
	if(ck == null) {
		ck = "";
	}
	
	String msg = "";
	if(ck.equals("T")) {
		msg = "입력이 가능한 날짜입니다";
	} else if(ck.equals("F")){
		msg = "일기가 이미 존재하는 날짜입니다";
	}
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>addDiaryForm</title>
</head>
<body>
	checkDate : <%=checkDate%><br>
	ck : <%=ck%>

	<h1>일기쓰기</h1>
	
	<form method="post" action="/diary/checkDateAction.jsp">	
		<div>
			날짜확인 : <input type="date" name="checkDate" value="<%=checkDate%>">
			<span><%=msg%></span>
		</div>
		<div>
			<button type="submit">날짜가능확인</button>
		</div>
	</form>
	
	<hr>
	
	<form method="post" action="/diary/addDiaryAction.jsp">
		<div>
			날짜 : 
			<%
				if(ck.equals("T")) {
			%>
					<input value="<%=checkDate%>" type="text" name="diaryDate" readonly="readonly">
			<%		
				} else {
			%>
					<input value="" type="text" name="diaryDate" readonly="readonly">				
			<%		
				}
			%>
			
			
		</div>
		
		<div>
			기분 : 
			<input type="radio" name="feeling" value="&#128512;">&#128512;
			<input type="radio" name="feeling" value="&#128545;">&#128545;
			<input type="radio" name="feeling" value="&#128567;">&#128567;
			<input type="radio" name="feeling" value="&#128561;">&#128561;
			<input type="radio" name="feeling" value="&#128565;">&#128565;
			<input type="radio" name="feeling" value="&#128564;">&#128564;
		</div>
		
		<div>
			제목 : <input type="text" name="title">
		</div>
		<div>
			<select name="weather">
				<option value="맑음">맑음</option>
				<option value="흐림">흐림</option>
				<option value="비">비</option>
				<option value="눈">눈</option>
			</select>
		</div>
		<div>
			<textarea rows="7" cols="50" name="content"></textarea>
		</div>
		<div>
			<button type="submit">입력</button>
		</div>
	</form>
</body>
</html>
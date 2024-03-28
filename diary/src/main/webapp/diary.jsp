<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.util.*"%>
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
	// 달력 API
	String targetYear = request.getParameter("targetYear");
	String targetMonth = request.getParameter("targetMonth");
	
	Calendar target = Calendar.getInstance();
	
	if(targetYear != null && targetMonth != null) {
		target.set(Calendar.YEAR, Integer.parseInt(targetYear));
		target.set(Calendar.MONTH, Integer.parseInt(targetMonth)); 
	}
	
	target.set(Calendar.DATE, 1);
	
	// 달력 타이틀로 출력할 변수
	int tYear = target.get(Calendar.YEAR);
	int tMonth = target.get(Calendar.MONTH);
	
	int yoNum = target.get(Calendar.DAY_OF_WEEK); // 일:1, 월:2, .....토:7
	System.out.println(yoNum); 
	// 시작공백의 개수 : 일요일 공백이 없고, 월요일은 1칸, 화요일은 2칸,....yoNum - 1이 공백의 개수
	int startBlank = yoNum - 1;
	int lastDate = target.getActualMaximum(Calendar.DATE); // target달의 마지막 날짜 반환
	System.out.println(lastDate + " <-- lastDate");
	int countDiv = startBlank + lastDate;
	
	// DB에서 tYear와 tMonth에 해당되는 diary목록 추출
	String sql2 = "select diary_date diaryDate, day(diary_date) day, feeling, left(title,5) title from diary where year(diary_date)=? and month(diary_date)=?";
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setInt(1, tYear);
	stmt2.setInt(2, tMonth+1);
	System.out.println(stmt2);
	
	rs2 = stmt2.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>달력</title>
	<style>
		.cell {
			float: left;
			background-color: #FFD9FA;
			width: 70px; height: 70px;
		}
		
		.sun {
			clear: both;
			color: #FF0000;
		}
	</style>
</head>
<body>
	<div>
		<a href="/diary/diary.jsp">다이어리 모양으로 보기</a>
		<a href="/diary/diaryList.jsp">게시판 모양으로 보기</a>
	</div>
	
	<h1><%=tYear%>년 <%=tMonth+1%>월</h1>
	<div>
		<a href="/diary/diary.jsp?targetYear=<%=tYear%>&targetMonth=<%=tMonth-1%>">이전달</a>
		<a href="/diary/diary.jsp?targetYear=<%=tYear%>&targetMonth=<%=tMonth+1%>">다음달</a>
	</div>
	
	<!-- DATE값이 들어갈 DIV -->
	<%
		for(int i=1; i<=countDiv; i=i+1) {
			
			if(i%7 == 1) {
	%>
				<div class="cell sun">
	<%			
			} else {
	%>
				<div class="cell">
	<%				
			}
					if(i-startBlank > 0) {
				%>
						<%=i-startBlank%><br>
				<%
						// 현재날짜(i-startBlank)의 일기가 rs2목록에 있는지 비교
						while(rs2.next()) {
							// 날짜에 일기가 존재한다
							if(rs2.getInt("day") == (i-startBlank)) {
				%>
								<div>
									<span><%=rs2.getString("feeling")%></span>
									<a href='/diary/diaryOne.jsp?diaryDate=<%=rs2.getString("diaryDate")%>'>
										<%=rs2.getString("title")%>...
									</a>
								</div>
				<%				
								break; 
							}
						}
						rs2.beforeFirst(); // 다음 날짜와 비교를 위해 ResultSet의 커스 위치를 처음으로...
					} else {
				%>
						&nbsp;
				<%		
					}
				%>
			</div>
	<%		
		}
	%>
</body>
</html>
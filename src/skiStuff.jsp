<%@ page errorPage="error.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Ski Equipment</title>
	<link rel="stylesheet" href="bootstrap.min.css">
</head>
<body>
	<sql:setDataSource var="myDS" driver="org.postgresql.Driver" url="jdbc:postgresql://localhost:5432/skistuff" user="rupert" password="secret"/>

	<sql:query var="listStuff" dataSource="${myDS}">
		SELECT * FROM skisEtc ORDER BY id;
	</sql:query>

	<%-- Start Pagination Setup--%>
	<c:set var="rowsPerPage" value="5"/>
	<c:set var="pageNumber" value="${empty param.page ? '1' : param.page}"/>
	<c:set var="numPagesRounded">
		<fmt:formatNumber value="${listStuff.rowCount/rowsPerPage}" maxFractionDigits="0"/>
	</c:set>
	<c:set var="numPagesUnRounded" value="${listStuff.rowCount/rowsPerPage}"/>

	<c:choose>
		<c:when test="${numPagesRounded==0}">
			<c:set var="numPagesTotal" value="1"/> 
		</c:when>
		<%-- When a Round up occurs: (8, 7.75) or (8, 8.0) --%>
		<c:when test="${numPagesRounded >= numPagesUnRounded}">
			<c:set var="numPagesTotal" value="${numPagesRounded}"/> 
		</c:when>
		<%-- When a Round down occurs: (7, 7.3333): will need 8 pages --%>
		<c:when test="${numPagesUnRounded > numPagesRounded}">
			<c:set var="numPagesTotal" value="${numPagesRounded+1}"/> 
		</c:when>
	</c:choose>

	<c:set var="start" value="${pageNumber*rowsPerPage-rowsPerPage}"/>
	<c:set var="stop" value="${pageNumber*rowsPerPage-1}"/>
	<%-- End Pagination Setup --%>

	<div class="container">
		<h1>Ski Equipment</h2>
		<p><a href="${pageContext.request.contextPath}/create.jsp">Create a new product</a></p>
		
		<table class="table">
			<tr>
				<th>Id</th>
				<th>Product</th>
				<th>Category</th>
				<th>Price</th>
				<th>Actions</th>
			</tr>
			<c:forEach var="item" items="${listStuff.rows}" begin="${start}" end="${stop}">
				<tr>
					<td><c:out value="${item.id}" /></td>
					<td><c:out value="${item.product}" /></td>
					<td><c:out value="${item.category}" /></td>
					<td><c:out value="\$${item.price}" /></td>
					<td>
						<a href="${pageContext.request.contextPath}/show.jsp?id=${item.id}">Show</a> / 
						<a href="${pageContext.request.contextPath}/edit.jsp?id=${item.id}">Edit</a> / 
						<a href="${pageContext.request.contextPath}/delete.jsp?id=${item.id}">Delete</a>
					</td>
				</tr>
			</c:forEach>
		</table>
		
		<%-- Pagination --%>
		<ul class="pagination">
			<c:if test="${pageNumber > 1}">
				<li><a href="${pageContext.request.contextPath}/?page=${pageNumber-1}" aria-label="Previous"><span aria-hidden="true">&laquo;</span></a></li>
			</c:if>
			<c:forEach var="i" begin="1" end="${numPagesTotal}">
				<c:choose>
					<c:when test="${i != pageNumber}">
						<li><a href="${pageContext.request.contextPath}/?page=${i}">${i}</a></li>
					</c:when>
					<c:otherwise>
						<li class="active"><a href="${pageContext.request.contextPath}/?page=${i}">${i}</a></li>
					</c:otherwise>
				</c:choose>
			</c:forEach>
			<c:if test="${pageNumber < numPagesTotal}">
				<li><a href="${pageContext.request.contextPath}/?page=${pageNumber+1}" aria-label="Next"><span aria-hidden="true">&raquo;</span></a></li>
			</c:if>
		</ul>
	</div>
</body>
</html>
<%@ page errorPage="error.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Product Edited</title>
	<link rel="stylesheet" href="bootstrap.min.css">
</head>
<body>
	<sql:setDataSource var="myDS" driver="org.postgresql.Driver" url="jdbc:postgresql://localhost:5432/skistuff" user="rupert" password="secret" />
	<sql:update dataSource="${myDS}" var="result">
		UPDATE skisEtc SET product=?,
						   category=?,
						   price=<%= Float.parseFloat(request.getParameter("price").trim()) %>
						WHERE id=${param.id};
		<sql:param value="${param.product}" />
		<sql:param value="${param.category}" />
	</sql:update>

	<c:if test="${result >= 1}">
		<div class="container">
			<div class="row">
				<div class="col-sm-12">
					<h1>Product Edited: ${param.product}</h1>
					<p><a href="${pageContext.request.contextPath}/">Back</a></p>
				</div>
			</div>
		</div>
	</c:if>
</body>
</html>
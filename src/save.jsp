<%@ page errorPage="error.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Product Created</title>
	<link rel="stylesheet" href="bootstrap.min.css">
</head>
<body>
	<sql:setDataSource var="myDS" driver="org.postgresql.Driver" url="jdbc:postgresql://localhost:5432/skistuff" user="rupert" password="secret" />

	<c:if test="${empty param.product or empty param.category or empty param.price}">
		<c:redirect url="create.jsp">
			<c:param name="errMsg" value="Please enter product, category and price." />
		</c:redirect>
	</c:if>

	<sql:update dataSource="${myDS}" var="result">
		INSERT INTO skisEtc(product, category, price) 
			VALUES (?, ?, <%= Float.parseFloat(request.getParameter("price").trim()) %>);
		<sql:param value="${param.product}" />
		<sql:param value="${param.category}" />
	<%-- Alternate query:
		INSERT INTO skisEtc(product, category, price)
			VALUES('<%= request.getParameter("product") %>',
		 		   '<%= request.getParameter("category") %>',
		 		    <%= Float.parseFloat(request.getParameter("price").trim()) %>);
	--%>
	</sql:update>

	<c:if test="${result >=1}">
		<div class="container">
			<div class="row">
				<div class="col-sm-12">
					<h1>Product Created: ${param.product}</h1>
					<p><a href="${pageContext.request.contextPath}/">Back</a></p>
				</div>
			</div>
		</div>
	</c:if>
</body>
</html>
<%@ page errorPage="error.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Delete a Product</title>
	<link rel="stylesheet" href="bootstrap.min.css">
</head>
<body>
	<div class="container">
		<div class="row">
			<div class="col-sm-12">
				<h1>Delete Product</h1>
				<p><c:out value="Are you sure you want to delete product with the ID of ${param.id}?" /></p>
				<ul class="list-inline">
					<li><a class="btn btn-primary" href="${pageContext.request.contextPath}/">Cancel</a></li>
					<li><a href="${pageContext.request.contextPath}/deleteForSure.jsp?id=${param.id}">Delete Product</a></li>
				</ul>
			</div>
		</div>
	</div>
</body>
</html>
<%@ page errorPage="error.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Show Product</title>
	<link rel="stylesheet" href="bootstrap.min.css">
</head>
<body>
	<sql:setDataSource var="myDS" driver="org.postgresql.Driver" url="jdbc:postgresql://localhost:5432/skistuff" user="rupert" password="secret" />

	<sql:query var="listStuff" dataSource="${myDS}">
		SELECT * FROM skisEtc WHERE id = ${param.id};
	</sql:query>

	<div class="container">
		<div class="row">
			<div class="col-sm-12">
				<h1>Display Product</h1>
				<table class="table">
					<div class="form-group">
						<label for="id">Id:</label>
						<input type="text" id="id" name="id" class="form-control" value="${param.id}" readonly disabled>
					</div>
					<div class="form-group">
						<label for="product">Product:</label>
						<input type="text" id="product" name="product" class="form-control" value="${listStuff.rows[0].product}" readonly disabled>
					</div>
					<div class="form-group">
						<label for="category">Category:</label>
						<input type="text" id="category" name="category" class="form-control" value="${listStuff.rows[0].category}" readonly disabled>
					</div>
					<div class="form-group">
						<label for="price">Price:</label>
						<input type="number" id="category" name="category" class="form-control" value="${listStuff.rows[0].price}" readonly disabled>
					</div>
				</table>
				<ul class="list-inline">
					<li><a class="btn btn-primary" href="${pageContext.request.contextPath}/edit.jsp?id=${param.id}">Edit</a></li>
					<li><a href="${pageContext.request.contextPath}/">Back</a></li>
				</p>
			</div>
		</div>
	</div>
	
</body>
</html>
<%@ page errorPage="error.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Edit Product</title>
	<link rel="stylesheet" href="bootstrap.min.css">
</head>
<body>
	<sql:setDataSource var="myDS" driver="org.postgresql.Driver" url="jdbc:postgresql://localhost:5432/skistuff" user="rupert" password="secret" />
	<sql:query var="listStuff" dataSource="${myDS}">
		SELECT * FROM skisEtc WHERE id=${param.id};
	</sql:query>

	<div class="container">
		<div class="row">
			<div class="col-sm-12">
				<h1>Edit Product</h1>
				<form action="${pageContext.request.contextPath}/saveEdits.jsp" method="post">
					<div class="form-group">
						<label for="id">Id</label>
						<input type="text" name="id" value="${param.id}" id="id" class="form-control" readonly>
					</div>
					<div class="form-group">
						<label for="product">Product</label>
						<input type="text" name="product" value="${listStuff.rows[0].product}" id="product" class="form-control" minlength="8" required>
					</div>
					<div class="form-group">
						<label for="category">Category</label>
						<input type="text" name="category" value="${listStuff.rows[0].category}" id="category" class="form-control" minlength="8" required>
					</div>
					<div class="form-group">
						<label for="price">Price</label>
						<input type="number" name="price" value="${listStuff.rows[0].price}" id="price" class="form-control" step="0.01" min="0">
					</div>
					<ul class="list-inline">
						<li><input type="submit" class="btn btn-primary" value="Edit Product"></li>
						<li><a href="${pageContext.request.contextPath}/">Cancel</a></li>
					</ul>
				</form>
			</div>
		</div>
	</div>
</body>
</html>
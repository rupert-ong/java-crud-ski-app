<%@ page errorPage = "error.jsp" %>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix="c" %>	
<%@ taglib uri = "http://java.sun.com/jsp/jstl/sql" prefix="sql" %>  
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Create New Product</title>
	<link rel="stylesheet" href="bootstrap.min.css">
</head>
<body>
	<div class="container">
		<div class="row">
			<div class="col-sm-12">
				<h1>Create Product</h1>
				<form action="${pageContext.request.contextPath}/save.jsp" method="post">
					<div class="form-group">
						<label for="product">Product</label>
						<input type="text" name="product" id="product" class="form-control">
					</div>
					<div class="form-group">
						<label for="category">Category</label>
						<input type="text" name="category" id="category" class="form-control">
					</div>
					<div class="form-group">
						<label for="price">Price</label>
						<input type="number" name="price" id="price" class="form-control" step="0.01" min="0">
					</div>
					<ul class="list-inline">
						<li><input type="submit" class="btn btn-primary" value="Create Product"></li>
						<li><a href="${pageContext.request.contextPath}/">Back</a></li>
					</ul>
				</form>
			</div>
		</div>
	</div>
</body>
</html>
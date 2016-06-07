<%@ page errorPage = "error.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Edit Employee ${employeeName}</title>
	<link rel="stylesheet" href="bootstrap.min.css">
</head>
<body>
	<div class="container">
		<div class="row">
			<div class="col-sm-12">
				<h1>Edit Employee ${employeeName}</h1>
				<form action="verifyAndSave" method="post">
					<div class="form-group">
						<label for="id">Id</label>
						<input type="text" name="id" value="${employeeID}" id="id" class="form-control" readonly>
					</div>
					<div class="form-group">
						<label for="product">Name</label>
						<input type="text" name="name" value="${employeeName}" id="name" class="form-control" minlength="6" required>
					</div>
					<div class="form-group">
						<label for="category">Department</label>
						<input type="text" name="department" value="${department}" id="department" class="form-control" minlength="6" required>
					</div>
					<div class="form-group">
						<label for="price">Salary</label>
						<input type="number" name="salary" value="${salary}" id="salary" class="form-control" step="0.01" min="0">
					</div>
					<ul class="list-inline">
						<li><input type="submit" class="btn btn-primary" value="Edit Employee"></li>
						<li><a href="${pageContext.request.contextPath}/findEmployee.html">Cancel</a></li>
					</ul>
				</form>
			</div>
		</div>
	</div>
</body>
</html>
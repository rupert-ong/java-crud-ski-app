<%@ page errorPage="error.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Update Successful</title>
	<link rel="stylesheet" href="bootstrap.min.css">
</head>
<body>
	<div class="container" style="padding-top:20px;">
		<div class="row">
			<div class="col-sm-12">
				<div class="alert alert-success">
					<p><strong>${result}</strong> <a href="${pageContext.request.contextPath}/">Back to Listings</a></p>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
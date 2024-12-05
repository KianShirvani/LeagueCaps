<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="javax.naming.*" %>
<%
    String errorMessage = "";
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String customerId = request.getParameter("customerId");
        String customerPassword = request.getParameter("customerPassword");

        if (customerId == null || customerPassword == null || customerId.isEmpty() || customerPassword.isEmpty()) {
            errorMessage = "Customer ID and Password must be filled out";
        } else {
            // Database connection and validation logic
            Connection conn = null;
            try {
                String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
                String uid = "sa";
                String pw = "304#sa#pw";
                conn = DriverManager.getConnection(url, uid, pw);

                String sql = "SELECT * FROM customer WHERE customerId = ? AND password = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, customerId);
                stmt.setString(2, customerPassword);
                ResultSet rs = stmt.executeQuery();

                if (!rs.next()) {
                    errorMessage = "Invalid Customer ID or Password";
                } else {
                    // Successful login, store customerId and customerPassword in session and redirect to order page
                    session.setAttribute("customerId", customerId);
                    session.setAttribute("customerPassword", customerPassword);
                    response.sendRedirect("order.jsp");
                    return;
                }

                rs.close();
                stmt.close();
                conn.close();
            } catch (Exception e) {
                e.printStackTrace();
                errorMessage = "An error occurred while validating your credentials. Please try again.";
            } finally {
                if (conn != null) {
                    try {
                        conn.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            }
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>LeagueCaps CheckOut Line</title>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
	<link rel="stylesheet" href="styles.css">
	<link rel="shortcut icon" type="image/x-icon" href="img/logo.png" />
    <script>
        function validateForm() {
            var customerId = document.getElementById("customerId").value;
            var customerPassword = document.getElementById("customerPassword").value;

            if (customerId == "" || customerPassword == "") {
                document.getElementById("errorMessage").innerText = "Customer ID and Password must be filled out";
                return false;
            }
            return true;
        }
    </script>
</head>
<body>

	<!-- Navbar Section -->
	<nav class="navbar navbar-expand-lg navbar-dark" style="background-color: midnightblue;">
		<!-- Logo and Brand Name -->
		<a class="navbar-brand ml-4" href="index.jsp"
			style="font-family: 'Playfair Display', serif; text-transform: uppercase; font-size: 2em; color: whitesmoke; text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.7);">
			<img src="img/logo.png" alt="SQL Cap Shop" height="100" class="mr-2"> <!-- Replace with your logo -->
			LeagueCaps
		</a>

		<!-- Shop Dropdown Button -->
		<div class="dropdown mx-3 ml-2">
			<button class="btn btn-warning btn-lg dropdown-toggle" type="button" id="shopDropdown"
				data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
				Shop
			</button>
			<div class="dropdown-menu" aria-labelledby="shopDropdown">
				<a class="dropdown-item" href="listprod.jsp?category=MLB Caps">MLB</a>
				<a class="dropdown-item" href="listprod.jsp?category=NFL Caps">NFL</a>
				<a class="dropdown-item" href="listprod.jsp?category=NBA Caps">NBA</a>
				<div class="dropdown-divider"></div>
				<a class="dropdown-item" href="listprod.jsp">Shop All</a>
			</div>
		</div>

		<!-- Navbar Links -->
		<div class="collapse navbar-collapse" id="navbarNav">
			<ul class="navbar-nav ml-auto align-items-center w-100">
				<!-- Search Bar -->
				<li class="nav-item flex-grow-1">
					<form class="form-inline my-2 my-lg-1 w-100">
						<input class="form-control mr-3 w-75" type="search"
							placeholder="Search for Your Favourite Team!" aria-label="Search"
							style="flex-grow: 1; height: 45px;">
						<button class="btn btn-outline-light my-2 my-sm-0 mr-4" type="submit">Search</button>
					</form>
				</li>

				<!-- Dynamic User Greeting or Sign In -->
				<li class="nav-item">
                <%
                    String authenticatedUser = (String) session.getAttribute("authenticatedUser");
                    if (authenticatedUser != null) {
                %>
                    <a href="logout.jsp" class="btn btn-primary btn-lg mx-2">Logout</a>
                <% } else { %>
                    <a href="login.jsp" class="btn btn-primary btn-lg mx-2">Sign In</a>
                <% } %>
            </li>

				<!-- Create Account Button -->
				<% if (authenticatedUser==null) { // Only display if user is not logged in %>
					<li class="nav-item">
						<a href="createAccount.jsp" class="btn btn-success btn-lg mx-2">Create Account</a>
					</li>
					<% } %>

						<!-- Cart Button -->
						<li class="nav-item">
							<a href="showcart.jsp">
								<img src="img/cart-icon.jpg" alt="Cart" style="height: 40px; width: 40px;" class="mx-2">
								<!-- Replace with your cart image -->
							</a>
						</li>
			</ul>
		</div>
	</nav>




<div class="container mt-5 mb-3">
    <div class="card mb-3">
        <div class="card-header bg-primary text-white text-center">
            <h1>LeagueCaps CheckOut Line</h1>
        </div>
        <div class="card-body">
            <p class="text-center">Enter your customer ID and password to complete the transaction:</p>
            <form method="post" action="checkout.jsp" class="d-flex flex-column align-items-center" onsubmit="return validateForm()">
                <div class="mb-3" style="width: 300px;">
                    <label for="customerId" class="form-label"></label>
                    <input type="text" id="customerId" name="customerId" class="form-control" placeholder="Customer ID" required>
                </div>
                <div class="mb-3" style="width: 300px;">
                    <label for="customerPassword" class="form-label"></label>
                    <input type="password" id="customerPassword" name="customerPassword" class="form-control" placeholder="Password" required>
                </div>
                <div id="errorMessage" class="text-danger mb-3"><%= errorMessage %></div>
                <div class="d-flex justify-content-between" style="width: 300px;">
                    <a href="paymentInfo.jsp" class="btn btn-primary">Previous</a>
                    <a href="index.jsp" class="btn btn-secondary">Home</a>
                    <input type="submit" value="Submit" class="btn btn-success">
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Footer Section -->
<footer class="footer text-light mt-5 py-4" style="background-color: midnightblue;">
    <div class="container">
        <div class="row">
				<!-- About Section -->
				<div class="col-md-3">
					<h5>About</h5>
					<ul class="list-unstyled">
						<li><a href="#" class="text-light">About Us</a></li>
						<li><a href="#" class="text-light">Career Opportunities</a></li>
						<li><a href="#" class="text-light">Affiliates</a></li>
					</ul>
				</div>

				<!-- Shop Section -->
				<div class="col-md-3">
					<h5>Shop</h5>
					<ul class="list-unstyled">
						<li><a href="#" class="text-light">Email Gift Cards</a></li>
						<li><a href="#" class="text-light">Gift Card Balance</a></li>
						<li><a href="#" class="text-light">Coupons</a></li>
						<li><a href="#" class="text-light">Mobile App</a></li>
						<li><a href="#" class="text-light">Student Discount</a></li>
					</ul>
				</div>

				<!-- Support Section -->
				<div class="col-md-3">
					<h5>Support</h5>
					<ul class="list-unstyled">
						<li><a href="#" class="text-light">Contact Us</a></li>
						<li><a href="#" class="text-light">Return Policy</a></li>
						<li><a href="#" class="text-light">Sizing Help</a></li>
						<li><a href="#" class="text-light">Store Locator</a></li>
					</ul>
				</div>

				<!-- Legal Section -->
				<div class="col-md-3">
					<h5>Legal</h5>
					<ul class="list-unstyled">
						<li><a href="#" class="text-light">Terms of Use</a></li>
						<li><a href="#" class="text-light">Privacy Statement</a></li>
						<li><a href="#" class="text-light">Accessibility</a></li>
						<li><a href="#" class="text-light">Ad Choices</a></li>
						<li><a href="#" class="text-light">Your Privacy Choices</a></li>
						<li><a href="#" class="text-light">Modern Slavery Act Policy</a></li>
					</ul>
				</div>
			</div>

			<hr class="bg-light">
			<div class="text-center">
				<p>&copy; 2024 LeagueCaps. All Rights Reserved.</p>
			</div>
		</div>
	</footer>
</body>
</html>

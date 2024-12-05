<!DOCTYPE html>
<html>
<head>
    <title>Shipping Information</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
	<link rel="stylesheet" href="styles.css">
	<link rel="shortcut icon" type="image/x-icon" href="img/logo.png" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        .error-border {
            border: 2px solid red;
        }
    </style>
    <script>
        function validateForm() {
            var address = document.getElementById("address").value;
            var city = document.getElementById("city").value;
            var state = document.getElementById("state").value;
            var postalCode = document.getElementById("postalCode").value;
            var country = document.getElementById("country").value;

            var cityRegex = /^[a-zA-Z\s]+$/;
            var stateRegex = /^[a-zA-Z\s]+$/;
			var postalCodeRegex = /^[a-zA-Z0-9\s]{6,7}$/;
            var countryRegex = /^[a-zA-Z\s]+$/;

            var errorMessage = "";

            // Clear previous error styles
            document.getElementById("address").classList.remove("error-border");
            document.getElementById("city").classList.remove("error-border");
            document.getElementById("state").classList.remove("error-border");
            document.getElementById("postalCode").classList.remove("error-border");
            document.getElementById("country").classList.remove("error-border");

            if (address == "" || city == "" || state == "" || postalCode == "" || country == "") {
                errorMessage += "All fields must be filled out.<br>";
                if (address == "") document.getElementById("address").classList.add("error-border");
                if (city == "") document.getElementById("city").classList.add("error-border");
                if (state == "") document.getElementById("state").classList.add("error-border");
                if (postalCode == "") document.getElementById("postalCode").classList.add("error-border");
                if (country == "") document.getElementById("country").classList.add("error-border");
            }

            if (!cityRegex.test(city)) {
                errorMessage += "Invalid City.<br>";
                document.getElementById("city").classList.add("error-border");
            }

            if (!stateRegex.test(state)) {
                errorMessage += "Invalid State.<br>";
                document.getElementById("state").classList.add("error-border");
            }

            if (!postalCodeRegex.test(postalCode)) {
                errorMessage += "Invalid Postal Code.<br>";
                document.getElementById("postalCode").classList.add("error-border");
            }

            if (!countryRegex.test(country)) {
                errorMessage += "Invalid Country.<br>";
                document.getElementById("country").classList.add("error-border");
            }

            if (errorMessage != "") {
                document.getElementById("errorMessages").innerHTML = '<div class="alert alert-danger" role="alert">' + errorMessage + '</div>';
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



<div class="container mt-5">
    <div class="card">
        <div class="card-header bg-primary text-white text-center">
            <h1>Shipping Information</h1>
        </div>
        <div class="card-body">
            <p class="text-center">Enter your Shipping Information</p>
			<!-- Error Messages Section -->
<div id="errorMessages" class="container mt-3"></div>
            <form method="get" action="paymentInfo.jsp" class="d-flex flex-column align-items-center" onsubmit="return validateForm()">
                <div class="mb-3" style="width: 300px;">
                    <label for="address" class="form-label"></label>
                    <input type="text" id="address" name="address" class="form-control" placeholder="Address" required>
                </div>
                <div class="mb-3" style="width: 300px;">
                    <label for="city" class="form-label"></label>
                    <input type="text" id="city" name="city" class="form-control" placeholder="City" required>
                </div>
                <div class="mb-3" style="width: 300px;">
                    <label for="state" class="form-label"></label>
                    <input type="text" id="state" name="state" class="form-control" placeholder="State" required>
                </div>
                <div class="mb-3" style="width: 300px;">
                    <label for="postalCode" class="form-label"></label>
                    <input type="text" id="postalCode" name="postalCode" class="form-control" placeholder="Postal Code" required>
                </div>
                <div class="mb-3" style="width: 300px;">
                    <label for="country" class="form-label"></label>
                    <input type="text" id="country" name="country" class="form-control" placeholder="Country" required>
                </div>
                <div class="d-flex justify-content-between" style="width: 300px;">
                    <a href="addcart.jsp" class="btn btn-primary">Previous</a>
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

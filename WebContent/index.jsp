<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SQL Cap Shop</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
	<link rel="stylesheet" href="styles.css"> 

    <style>
        .category-buttons a {
            text-decoration: none;
        }
    </style>
</head>
<body>

<!-- Black Friday Sale Popup Modal -->
<div class="modal fade" id="blackFridayModal" tabindex="-1" role="dialog" aria-labelledby="blackFridayModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header" style="background-color: midnightblue; color: white;">
                <h5 class="modal-title" id="blackFridayModalLabel">Black Friday Sale Extended!</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body text-center">
                <!-- Add your image here -->
                <img src="img/blackfriday.jpg" alt="Black Friday Sale" class="img-fluid mb-3" style="max-height: 300px; border-radius: 5px;">
                <p>Great news! We've extended our Black Friday Sale! Use code 'COSC304' and don't miss out on amazing deals.</p>
                <a href="listprod.jsp" class="btn btn-warning btn-lg">Shop Now!</a>
            </div>
        </div>
    </div>
</div>



<!-- Navbar Section -->
<nav class="navbar navbar-expand-lg navbar-dark" style="background-color: midnightblue;">
    <!-- Logo and Brand Name -->
    <a class="navbar-brand ml-4" href="index.jsp" style="font-family: 'Playfair Display', serif; text-transform: uppercase; font-size: 2em; color: whitesmoke; text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.7);">
        <img src="img/logo.png" alt="SQL Cap Shop" height="100" class="mr-2"> <!-- Replace with your logo -->
        LeagueCaps
    </a>

    <!-- Shop Dropdown Button -->
    <div class="dropdown mx-3 ml-2">
        <button class="btn btn-warning btn-lg dropdown-toggle" type="button" id="shopDropdown" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
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

    <!-- Navbar Toggler for Mobile View -->
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav">
        <span class="navbar-toggler-icon"></span>
    </button>

    <!-- Navbar Links -->
    <div class="collapse navbar-collapse" id="navbarNav">
        <ul class="navbar-nav ml-auto align-items-center w-100">
           <!-- Search Bar -->
<!-- Search Bar -->
<li class="nav-item flex-grow-1">
    <form class="form-inline my-2 my-lg-1 w-100" action="listprod.jsp" method="get">
        <!-- Update name to 'productName' to match listprod.jsp -->
        <input class="form-control mr-3 w-75" type="search" name="productName" placeholder="Search for Your Favourite Team!" aria-label="Search" style="flex-grow: 1; height: 45px;">
        <button class="btn btn-outline-light my-2 my-sm-0 mr-4" type="submit">Search</button>
    </form>
</li>


            <!-- Dynamic User Greeting or Sign In -->
            <li class="nav-item">
                <%
                    String authenticatedUser = (String) session.getAttribute("authenticatedUser");
                    if (authenticatedUser != null) {
                %>
                    <a href="logout.jsp" class="btn btn-primary btn-lg mx-2">Welcome: <%= authenticatedUser %></a>
                <% } else { %>
                    <a href="login.jsp" class="btn btn-primary btn-lg mx-2">Sign In</a>
                <% } %>
            </li>

			<!-- Create Account Button -->
				<%
    				if (authenticatedUser == null) { // Only display if user is not logged in
				%>
    				<li class="nav-item">
        				<a href="createAccount.jsp" class="btn btn-success btn-lg mx-2">Create Account</a>
    				</li>
				<% } %>

            <!-- Cart Button -->
            <li class="nav-item">
                <a href="showcart.jsp">
                    <img src="img/cart-icon.jpg" alt="Cart" style="height: 40px; width: 40px;" class="mx-2"> <!-- Replace with your cart image -->
                </a>
            </li>
        </ul>
    </div>
</nav>


	

<!-- Hero Section -->
<div class="text-center bg-light mt-4 mb-4 animated-hero">
	<h1 class="display-2 mb-2" style="font-family: 'Playfair Display', serif; text-transform: uppercase; font-weight: 700;">Welcome to LeagueCaps</h1>
    <p class="lead mt-4" style="font-family: 'Playfair Display', serif; text-transform: uppercase; font-weight: 400;">Find your favorite caps for NBA, NFL, and MLB teams!</p>
</div>


<div class="slideshow">
	<!-- Middle Section with Carousel -->
<div class="container my-5">
    <div id="offersCarousel" class="carousel slide rounded shadow" data-ride="carousel" data-interval="10000">
        <!-- Indicators -->
        <ol class="carousel-indicators">
            <li data-target="#offersCarousel" data-slide-to="0" class="active"></li>
            <li data-target="#offersCarousel" data-slide-to="1"></li>
            <li data-target="#offersCarousel" data-slide-to="2"></li>
        </ol>

        <!-- Carousel Items -->
        <div class="carousel-inner">
            <!-- Slide 1 -->
            <div class="carousel-item active">
                <img src="img/city-edition-offer.jpg" class="d-block w-100" alt="NBA Offer" style="height: 600px; object-fit:scale-down;"> <!-- Replace with your image -->
                <div class="carousel-caption d-none d-md-block">
                    <h5>NBA League Caps</h5>
                    <p class="card-text">NBA team caps inspired by the latest City Edition.</p>
                    <a href="listprod.jsp?category=NBA Caps" class="btn btn-primary btn-lg">Shop NBA</a>
                </div>
            </div>
            <!-- Slide 2 -->
            <div class="carousel-item">
                <img src="img/football-promo.jpg" class="d-block w-100 bg-secondary.bg-gradient" alt="NFL Offer" style="height: 600px; object-fit: scale-down;"> <!-- Replace with your image -->
                <div class="carousel-caption d-none d-md-block">
                    <h5>NFL Fan Favorites</h5>
                    <p class="">Show your team spirit with NFL caps featuring iconic designs.</p>
                    <a href="listprod.jsp?category=NFL Caps" class="btn btn-danger btn-lg">Shop NFL</a>
                </div>
            </div>
            <!-- Slide 3 -->
            <div class="carousel-item">
                <img src="img/mlb-offer.png" class="d-block w-100" alt="MLB Offer" style="height: 600px; object-fit: scale-down;"> <!-- Replace with your image -->
                <div class="carousel-caption d-none d-md-block">
                    <h5>MLB Throwback Collection</h5>
                    <p>Check out our exclusive MLB caps featuring throwback designs.</p>
                    <a href="listprod.jsp?category=MLB Caps" class="btn btn-success btn-lg">Shop MLB</a>
                </div>
            </div>
        </div>
    </div>
</div>
>

    <!-- Controls -->
    <a class="carousel-control-prev" href="#offersCarousel" role="button" data-slide="prev">
        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
        <span class="sr-only">Previous</span>
    </a>
    <a class="carousel-control-next" href="#offersCarousel" role="button" data-slide="next">
        <span class="carousel-control-next-icon" aria-hidden="true"></span>
        <span class="sr-only">Next</span>
    </a>
</div>  <!-- End Div of Slideshow -->


<!-- Dynamic Best Sellers -->
<div class="container my-5">
    <h2 class="text-center mb-4">Best Sellers</h2>
    <div class="row">
        <%
            try {
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
                String uid = "sa";
                String pw = "304#sa#pw";
                NumberFormat currency = NumberFormat.getCurrencyInstance();

                try (Connection con = DriverManager.getConnection(url, uid, pw)) {
                    String sql = "SELECT TOP 3 p.productId, p.productName, p.productDesc, p.productPrice, p.productImageURL, SUM(op.quantity) AS totalSales " +
                                 "FROM product p " +
                                 "JOIN orderproduct op ON p.productId = op.productId " +
                                 "GROUP BY p.productId, p.productName, p.productDesc, p.productPrice, p.productImageURL " +
                                 "ORDER BY totalSales DESC";

                    try (PreparedStatement pstmt = con.prepareStatement(sql)) {
                        ResultSet rst = pstmt.executeQuery();

                        while (rst.next()) {
                            int productId = rst.getInt("productId");
                            String productName = rst.getString("productName");
                            String productDesc = rst.getString("productDesc");
                            String productPrice = currency.format(rst.getDouble("productPrice"));
                            String imagePath = "img/" + productId + ".jpg"; // Path to product image
                            String addToCartLink = "addcart.jsp?id=" + productId + "&name=" + URLEncoder.encode(productName, "UTF-8")
                                                 + "&price=" + rst.getDouble("productPrice");

                            // Generate a styled card for each product
                            out.println("<div class='col-md-4 col-sm-6 mb-4'>");
                            out.println("    <div class='card shadow-sm h-100 border-0'>");
                            out.println("        <div class='card-img-container'>");
                            out.println("            <img src='" + imagePath + "' class='card-img-top img-fluid rounded-top' alt='" + productName + "'>");
                            out.println("        </div>");
                            out.println("        <div class='card-body text-center'>");
                            out.println("            <h5 class='card-title font-weight-bold'>" + productName + "</h5>");
                            out.println("            <p class='card-text text-muted small'>" + productDesc + "</p>");
                            out.println("            <p class='card-text text-primary font-weight-bold'>" + productPrice + "</p>");
                            out.println("        </div>");
                            out.println("        <div class='card-footer text-center bg-white border-0'>");
                            out.println("            <a href='product.jsp?id=" + productId + "' class='btn btn-outline-info btn-sm mr-2'>View Details</a>");
                            out.println("            <a href='" + addToCartLink + "' class='btn btn-success btn-sm'>Add to Cart</a>");
                            out.println("        </div>");
                            out.println("    </div>");
                            out.println("</div>");
                        }

                        rst.close();
                    }
                }
            } catch (Exception e) {
                out.println("<div class='col-12 text-center text-danger'>Error loading Best Sellers: " + e.getMessage() + "</div>");
            }
        %>
    </div>
</div>

<style>
    .card-img-container {
        overflow: hidden;
        border-top-left-radius: 0.25rem;
        border-top-right-radius: 0.25rem;
    }

    .card-img-top {
        width: 100%;
        height: auto;
    }
</style>


  <!-- End Of Dynamic Best Sellers -->


<!-- Categories Section -->
<div class="container my-5">
    <h2 class="text-center mb-4">Shop Your Favorite Sport</h2>
    <div class="row text-center category-buttons">
        <!-- NBA Category -->
        <div class="col-md-4 mb-3">
            <div class="card shadow p-3 border"> <!-- Added white box using card class -->
                <a href="listprod.jsp?category=NBA Caps">
                    <img src="img/nba-logo.png" alt="NBA" class="img-fluid rounded" style="max-height: 150px;"> <!-- Replace with your NBA logo image -->
                </a>
                <p class="mt-2">NBA</p> <!-- Optional caption -->
            </div>
        </div>
        <!-- NFL Category -->
        <div class="col-md-4 mb-3">
            <div class="card shadow p-3 border"> <!-- Added white box using card class -->
                <a href="listprod.jsp?category=NFL Caps">
                    <img src="img/nfl-logo.png" alt="NFL" class="img-fluid rounded" style="max-height: 150px;"> <!-- Replace with your NFL logo image -->
                </a>
                <p class="mt-2">NFL</p> <!-- Optional caption -->
            </div>
        </div>
        <!-- MLB Category -->
        <div class="col-md-4 mb-3">
            <div class="card shadow p-3 border"> <!-- Added white box using card class -->
                <a href="listprod.jsp?category=MLB Caps">
                    <img src="img/mlb-logo.png" alt="MLB" class="img-fluid rounded" style="max-height: 150px;"> <!-- Replace with your MLB logo image -->
                </a>
                <p class="mt-2">MLB</p> <!-- Optional caption -->
            </div>
        </div>
    </div>
</div>


</div>


<!-- Footer Section -->
<footer class="footer text-light py-4" style="background-color: midnightblue;">
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

<!-- Bootstrap JS -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.4.4/dist/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

<script>
    // Automatically show the modal when the page loads
    $(document).ready(function () {
        $('#blackFridayModal').modal('show');
    });
</script>

</body>
</html>

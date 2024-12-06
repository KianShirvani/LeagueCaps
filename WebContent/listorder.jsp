<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Orders</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="styles.css">
    <link rel="shortcut icon" type="image/x-icon" href="img/logo.png" />
</head>
<body>

<!-- Navbar Section -->
<nav class="navbar navbar-expand-lg navbar-dark" style="background-color: midnightblue;">
    <!-- Logo and Brand Name -->
    <a class="navbar-brand ml-4" href="index.jsp">
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

    <!-- Navbar Toggler for Mobile View -->
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav">
        <span class="navbar-toggler-icon"></span>
    </button>

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
            <% if (authenticatedUser == null) { // Only display if user is not logged in %>
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

<div class="container my-4">
    <h1 class="text-center mb-4">Your Orders</h1>

    <%
        // Check if a user is logged in
        // String authenticatedUser = (String) session.getAttribute("authenticatedUser"); // Removed duplicate declaration

        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (java.lang.ClassNotFoundException e) {
            out.println("ClassNotFoundException: " + e);
        }

        String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
        String uid = "sa";
        String pw = "304#sa#pw";
        NumberFormat currency = NumberFormat.getCurrencyInstance(Locale.US);

        try (Connection con = DriverManager.getConnection(url, uid, pw)) {
            PreparedStatement pstmtOrders = null;
            PreparedStatement pstmtOrderProducts = con.prepareStatement("SELECT productId, quantity, price FROM orderproduct WHERE orderId = ?");

            // SQL query variables
            String sqlOrders = "";
            if (authenticatedUser != null) {
                // If user is logged in, get their customerId and display only their orders
                String customerId = (String) session.getAttribute("customerId");
                if (customerId == null) {
                    // Fetch customerId from the database using authenticatedUser
                    String sqlCustomer = "SELECT customerId FROM customer WHERE userid = ?";
                    try (PreparedStatement pstmtCustomer = con.prepareStatement(sqlCustomer)) {
                        pstmtCustomer.setString(1, authenticatedUser);
                        ResultSet rsCustomer = pstmtCustomer.executeQuery();
                        if (rsCustomer.next()) {
                            customerId = rsCustomer.getString("customerId");
                            session.setAttribute("customerId", customerId);
                        } else {
                            out.println("<div class='alert alert-danger'>Customer not found.</div>");
                            return;
                        }
                    }
                }

                sqlOrders = "SELECT O.orderId, O.orderDate, O.shipToAddress, O.shipToCity, O.shipToState, O.shipToPostalCode, O.shipToCountry, O.totalAmount " +
                            "FROM ordersummary O WHERE O.customerId = ?";
                pstmtOrders = con.prepareStatement(sqlOrders);
                pstmtOrders.setString(1, customerId);
            } else {
                // If no user is logged in, display all orders
                sqlOrders = "SELECT O.orderId, O.orderDate, O.shipToAddress, O.shipToCity, O.shipToState, O.shipToPostalCode, O.shipToCountry, O.totalAmount " +
                            "FROM ordersummary O";
                pstmtOrders = con.prepareStatement(sqlOrders);
            }

            ResultSet rst = pstmtOrders.executeQuery();

            if (!rst.isBeforeFirst()) {
                out.println("<div class='alert alert-info'>No orders found.</div>");
            }

            while (rst.next()) {
                int orderId = rst.getInt("orderId");
                String orderDate = rst.getString("orderDate");
                String shiptoAddress = rst.getString("shipToAddress");
                String shiptoCity = rst.getString("shipToCity");
                String shiptoState = rst.getString("shipToState");
                String shiptoPostalCode = rst.getString("shipToPostalCode");
                String shiptoCountry = rst.getString("shipToCountry");
                String totalAmount = currency.format(rst.getDouble("totalAmount"));

                // Card for each order summary
                out.println("<div class='card mb-4'>");
                // Card header
                out.println("<div class='card-header bg-primary text-white'><h5>Order ID: " + orderId + "</h5></div>");

                // Order Summary Table
                out.println("<div class='card-body'>");
                out.println("<p><strong>Order Date:</strong> " + orderDate + "</p>");
                out.println("<p><strong>Shipping Address:</strong> " + shiptoAddress + ", " + shiptoCity + ", " + shiptoState + ", " + shiptoPostalCode + ", " + shiptoCountry + "</p>");
                out.println("<p><strong>Total Amount:</strong> " + totalAmount + "</p>");

                // Fetch Order Products
                pstmtOrderProducts.setInt(1, orderId);
                ResultSet rst2 = pstmtOrderProducts.executeQuery();

                // Order Items Table
                out.println("<h6>Order Items:</h6>");
                out.println("<table class='table table-bordered'><thead><tr><th>Product ID</th><th>Quantity</th><th>Price</th></tr></thead><tbody>");
                int quantityTotal = 0;
                double orderTotal = 0.0;

                while (rst2.next()) {
                    int productId = rst2.getInt("productId");
                    int quantity = rst2.getInt("quantity");
                    double price = rst2.getDouble("price");

                    orderTotal += quantity * price;
                    quantityTotal += quantity;

                    out.println("<tr><td>" + productId + "</td><td>" + quantity + "</td><td>" + currency.format(price) + "</td></tr>");
                }
                String formattedOrderTotal = currency.format(orderTotal);
                out.println("</tbody><tfoot><tr><th>Total</th><th>" + quantityTotal + "</th><th>" + formattedOrderTotal + "</th></tr></tfoot></table>");

                out.println("</div></div>"); // Close card body and card
            }

            // Close the result sets and statements
            rst.close();
            pstmtOrders.close();
            pstmtOrderProducts.close();

        } catch (SQLException ex) {
            out.println("<div class='alert alert-danger'>SQLException: " + ex.getMessage() + "</div>");
            ex.printStackTrace();
        }
    %>

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

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.4.4/dist/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>

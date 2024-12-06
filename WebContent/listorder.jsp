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
</head>
<body>

<!-- Page Header Start-->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
    <a class="navbar-brand" href="shop.html">The SQL Cap Shop</a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNav">
        <ul class="navbar-nav ml-auto">
            <li class="nav-item">
                <a class="nav-link" href="listprod.jsp">Product Page</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="listorder.jsp">List Order</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="showcart.jsp">Shopping Cart</a>
            </li>
        </ul>
    </div>
</nav>
<!-- Page Header End-->

<div class="container my-4">
    <h1 class="text-center mb-4">Your Orders</h1>

    <%
        // Check if a user is logged in
        String authenticatedUser = (String) session.getAttribute("authenticatedUser");

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
                    String sqlCustomer = "SELECT customerId FROM customer WHERE userName = ?";
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

                sqlOrders = "SELECT O.orderId, O.orderDate, O.shiptoAddress, O.shiptoCity, O.shiptoState, O.shiptoPostalCode, O.shiptoCountry, O.totalAmount " +
                            "FROM ordersummary O WHERE O.customerId = ?";
                pstmtOrders = con.prepareStatement(sqlOrders);
                pstmtOrders.setString(1, customerId);
            } else {
                // If no user is logged in, display all orders
                sqlOrders = "SELECT O.orderId, O.orderDate, O.shiptoAddress, O.shiptoCity, O.shiptoState, O.shiptoPostalCode, O.shiptoCountry, O.totalAmount " +
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
                String shiptoAddress = rst.getString("shiptoAddress");
                String shiptoCity = rst.getString("shiptoCity");
                String shiptoState = rst.getString("shiptoState");
                String shiptoPostalCode = rst.getString("shiptoPostalCode");
                String shiptoCountry = rst.getString("shiptoCountry");
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

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.4.4/dist/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>

<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Grocery Order List</title>
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
<h1 class="text-center mb-4">The SQL Cap Shop Orders</h1>

<%
//START OF JAVA CODE
    try {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    } catch (java.lang.ClassNotFoundException e) {
        out.println("ClassNotFoundException: " + e);
    }

    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String uid = "sa";
    String pw = "304#sa#pw";
    NumberFormat currency = NumberFormat.getCurrencyInstance(Locale.US);

    try (Connection con = DriverManager.getConnection(url, uid, pw);
         Statement stmt = con.createStatement();) {

        String sql = "SELECT O.orderId, O.orderDate, C.customerId, C.firstName, C.lastName, O.totalAmount " +
                     "FROM ordersummary as O INNER JOIN customer as C ON O.customerId = C.customerId";
        PreparedStatement pstmt = con.prepareStatement("SELECT productId, quantity, price FROM orderproduct WHERE orderId = ?");
        ResultSet rst = stmt.executeQuery(sql);

        while (rst.next()) {
            int orderId = rst.getInt("orderId");
            String orderDate = rst.getString("orderDate");
            int customerId = rst.getInt("customerId");
            String customerName = rst.getString("firstName") + " " + rst.getString("lastName");
            String totalAmount = currency.format(rst.getDouble("totalAmount"));

            // Card for each order summary
            out.println("<div class='card mb-4'>");
            //Card header
            out.println("<div class='card-header bg-primary text-black'><h5>Order Summary for " + customerName + "</h5></div>");
            
            // Order Summary Table
            out.println("<div class='card-body'>");
            out.println("<table class='table'><thead><tr>");
            out.println("<th>Order ID</th><th>Order Date</th><th>Customer ID</th><th>Total Amount</th>");
            out.println("</tr></thead><tbody>");
            out.println("<tr><td>" + orderId + "</td><td>" + orderDate + "</td><td>" + customerId + "</td><td>" + totalAmount + "</td></tr>");
            out.println("</tbody></table>");

            // Fetch Order Products using prepared statement and associated orderid
            pstmt.setInt(1, orderId);
            ResultSet rst2 = pstmt.executeQuery();

            // Order Items Table
            out.println("<h6>Order Items:</h6>");
            out.println("<table class='table table-bordered'><thead><tr><th>Product ID</th><th>Quantity</th><th>Price</th></tr></thead><tbody>");
            int quantityTotal = 0;
            double orderTotal = 0.0;
            // List all order details from prepared statement for ordered items associated with customer and order ID
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
        //Close the connection
        rst.close();
        pstmt.close();
        stmt.close();

    } catch (SQLException ex) {
        out.println("SQLException: " + ex);
    }
%>

</div>

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.4.4/dist/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>

<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
    <title>SQL Cap Shop Shipment Processing</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h1 class="text-center mb-4">Shipment Processing</h1>
<%
    String userName = (String) session.getAttribute("authenticatedUser");
    if (userName == null) {
%>
    <div class="alert alert-danger" role="alert">
        You must be logged in to process a shipment. <a href="login.jsp" class="alert-link">Login here</a>.
    </div>
<%
        return;
    }

    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String uid = "sa";
    String pw = "304#sa#pw";
    Connection conn = null;
    PreparedStatement fetchOrderProductsStmt = null;
    PreparedStatement checkInventoryStmt = null;
    PreparedStatement updateInventoryStmt = null;
    PreparedStatement createShipmentStmt = null;
    ResultSet orderProductsRs = null;

    try {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        conn = DriverManager.getConnection(url, uid, pw);
        conn.setAutoCommit(false); // Start transaction

        // Assume order ID is passed as a parameter
        String orderId = request.getParameter("orderId");
        if (orderId == null) {
%>
    <div class="alert alert-danger" role="alert">
        Error: Order ID is required.
    </div>
<%
            return;
        }

        // Fetch products in the order
        String fetchOrderProductsSQL = "SELECT productId, quantity FROM orderproduct WHERE orderId = ?";
        fetchOrderProductsStmt = conn.prepareStatement(fetchOrderProductsSQL);
        fetchOrderProductsStmt.setInt(1, Integer.parseInt(orderId));
        orderProductsRs = fetchOrderProductsStmt.executeQuery();

        if (!orderProductsRs.isBeforeFirst()) {
%>
    <div class="alert alert-warning" role="alert">
        No items found for order ID <%= orderId %>.
    </div>
<%
            return;
        }

        // Create a new shipment record
        String createShipmentSQL = "INSERT INTO shipment (shipmentDate, shipmentDesc, warehouseId) VALUES (GETDATE(), 'Order Shipment', 1)";
        createShipmentStmt = conn.prepareStatement(createShipmentSQL, Statement.RETURN_GENERATED_KEYS);
        createShipmentStmt.executeUpdate();
        ResultSet shipmentRs = createShipmentStmt.getGeneratedKeys();
        shipmentRs.next();
        int shipmentId = shipmentRs.getInt(1);

        // Process each product in the order
        boolean canShip = true;
        StringBuilder output = new StringBuilder();
        output.append("<table class='table table-bordered mt-4'><thead><tr>")
              .append("<th>Product ID</th>")
              .append("<th>Ordered Quantity</th>")
              .append("<th>Previous Inventory</th>")
              .append("<th>New Inventory</th>")
              .append("</tr></thead><tbody>");

        while (orderProductsRs.next()) {
            int productId = orderProductsRs.getInt("productId");
            int quantity = orderProductsRs.getInt("quantity");

            // Check inventory in warehouse
            String checkInventorySQL = "SELECT quantity FROM productinventory WHERE productId = ? AND warehouseId = 1";
            checkInventoryStmt = conn.prepareStatement(checkInventorySQL);
            checkInventoryStmt.setInt(1, productId);
            ResultSet inventoryRs = checkInventoryStmt.executeQuery();

            if (inventoryRs.next()) {
                int availableQuantity = inventoryRs.getInt("quantity");
                if (availableQuantity < quantity) {
                    canShip = false;
                    output.append("<div class='alert alert-danger'>Error: Not enough inventory for product ID ").append(productId).append(".</div>");
                    inventoryRs.close();
                    break; // Stop processing if insufficient inventory
                } else {
                    // Update inventory
                    int newQuantity = availableQuantity - quantity;
                    String updateInventorySQL = "UPDATE productinventory SET quantity = ? WHERE productId = ? AND warehouseId = 1";
                    updateInventoryStmt = conn.prepareStatement(updateInventorySQL);
                    updateInventoryStmt.setInt(1, newQuantity);
                    updateInventoryStmt.setInt(2, productId);
                    updateInventoryStmt.executeUpdate();

                    // Add table row
                    output.append("<tr>")
                          .append("<td>").append(productId).append("</td>")
                          .append("<td>").append(quantity).append("</td>")
                          .append("<td>").append(availableQuantity).append("</td>")
                          .append("<td>").append(newQuantity).append("</td>")
                          .append("</tr>");
                }
            } else {
                canShip = false;
                output.append("<div class='alert alert-danger'>Error: Product ID ").append(productId).append(" not found in warehouse.</div>");
                inventoryRs.close();
                break; // Stop processing if product not found
            }
            inventoryRs.close();
        }

        output.append("</tbody></table>");

        if (canShip) {
            conn.commit(); // Commit transaction
            output.append("<div class='alert alert-success mt-4'>Shipment successfully processed.</div>");
%>
    <div>
        <%= output.toString() %>
    </div>
<%
        } else {
            conn.rollback(); // Rollback transaction
%>
    <div class="alert alert-warning" role="alert">
        Shipment failed. Transaction rolled back due to insufficient inventory.
    </div>
<%
        }
    } catch (Exception e) {
        if (conn != null) conn.rollback(); // Rollback transaction on error
%>
    <div class="alert alert-danger" role="alert">
        Error: <%= e.getMessage() %>
    </div>
<%
        e.printStackTrace();
    } finally {
        if (orderProductsRs != null) orderProductsRs.close();
        if (fetchOrderProductsStmt != null) fetchOrderProductsStmt.close();
        if (checkInventoryStmt != null) checkInventoryStmt.close();
        if (updateInventoryStmt != null) updateInventoryStmt.close();
        if (createShipmentStmt != null) createShipmentStmt.close();
        if (conn != null) conn.close();
    }
%>
</div>

<div class="text-center mt-4">
    <a href="shop.html" class="btn btn-primary">Back to Main Page</a>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
<!DOCTYPE html>
<html>
<head>
    <title>Administrator Sales Report by Day</title>
</head>
<body>
<%@ include file="auth.jsp" %>
<%@ include file="jdbc.jsp" %>

<h1>Administrator Sales Report by Day</h1>

<table border="1">
    <thead>
        <tr>
            <th>Order Date</th>
            <th>Total Order Amount</th>
        </tr>
    </thead>
    <tbody>
        <%
            // Database connection details
            String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
            String uid = "sa";
            String pw = "304#sa#pw";
            
            // Correct SQL query for ordersummary table
            String sql = "SELECT CONVERT(DATE, orderDate) AS orderDate, SUM(totalAmount) AS totalSales " +
                         "FROM ordersummary " +
                         "GROUP BY CONVERT(DATE, orderDate) " +
                         "ORDER BY orderDate";

            Connection connection = null;

            try {
                // Establish the database connection
                connection = DriverManager.getConnection(url, uid, pw);

                // Execute the query
                Statement stmt = connection.createStatement();
                ResultSet rs = stmt.executeQuery(sql);

                // Loop through the results and display them in the table
                while (rs.next()) {
                    String orderDate = rs.getString("orderDate");
                    String totalSales = rs.getString("totalSales");

                    out.println("<tr>");
                    out.println("<td>" + orderDate + "</td>");
                    out.println("<td>$" + totalSales + "</td>");
                    out.println("</tr>");
                }
            } catch (SQLException ex) {
                // Output the error message
                out.println("<p>Error: " + ex.getMessage() + "</p>");
            } finally {
                // Close the database connection
                if (connection != null) {
                    try {
                        connection.close();
                    } catch (SQLException e) {
                        out.println("<p>Error closing connection: " + e.getMessage() + "</p>");
                    }
                }
            }
        %>
    </tbody>
</table>

</body>
</html>

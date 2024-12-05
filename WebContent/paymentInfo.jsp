<!DOCTYPE html>
<html>
<head>
    <title>Payment Information</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<div class="container mt-5">
    <div class="card">
        <div class="card-header bg-primary text-white text-center">
            <h1>Payment Information</h1>
        </div>
        <div class="card-body">
            <p class="text-center">Enter your payment information:</p>
            <form method="get" action="checkout.jsp" class="d-flex flex-column align-items-center">
                <div class="mb-3" style="width: 300px;">
                    <label for="paymentType" class="form-label"></label>
                    <input type="text" id="paymentType" name="paymentType" class="form-control" placeholder="Payment Type" required>
                </div>
                <div class="mb-3" style="width: 300px;">
                    <label for="paymentNumber" class="form-label"></label>
                    <input type="text" id="paymentNumber" name="paymentNumber" class="form-control" placeholder="Payment Number" required>
                </div>
                <div class="mb-3" style="width: 300px;">
                    <label for="paymentExpiryDate" class="form-label"></label>
                    <input type="text" id="paymentExpiryDate" name="paymentExpiryDate" class="form-control" placeholder="MM/YY" required>
                </div>
                <div class="d-flex justify-content-between" style="width: 300px;">
                    <a href="shippingInfo.jsp" class="btn btn-primary">Previous</a>
                    <a href="index.jsp" class="btn btn-secondary">Home</a>
                    <input type="submit" value="Submit" class="btn btn-success">
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>

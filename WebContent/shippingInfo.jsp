<!DOCTYPE html>
<html>
<head>
    <title>Shipping Information</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function validateForm() {
            var address = document.getElementById("address").value;
            var city = document.getElementById("city").value;
            var state = document.getElementById("state").value;
            var postalCode = document.getElementById("postalCode").value;
            var country = document.getElementById("country").value;

            if (address == "" || city == "" || state == "" || postalCode == "" || country == "") {
                alert("All fields must be filled out");
                return false;
            }
            return true;
        }
    </script>
</head>
<body>
<div class="container mt-5">
    <div class="card">
        <div class="card-header bg-primary text-white text-center">
            <h1>Shipping Information</h1>
        </div>
        <div class="card-body">
            <p class="text-center">Enter your Shipping Information</p>
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
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>สแกน QR Code - SLF Event Tracking</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- QR Scanner -->
    <script src="https://unpkg.com/html5-qrcode"></script>
</head>
<body class="bg-gray-100 font-sans">
    <div class="container mx-auto px-4 py-8">
        <div class="bg-white rounded-lg shadow-md p-6">
            <div class="flex justify-between items-center mb-6">
                <h1 class="text-2xl font-bold text-gray-800">สแกน QR Code</h1>
                <a href="${pageContext.request.contextPath}/dashboard" class="text-blue-600 hover:underline">กลับหน้าหลัก</a>
            </div>
            
            <div class="mb-6">
                <p class="text-gray-600 mb-4 text-center">กรุณาสแกน QR Code ที่บูธเพื่อสะสมคะแนน</p>
                
                <div id="qr-reader" class="mx-auto" style="max-width: 500px;"></div>
                <div id="qr-reader-results" class="mt-4"></div>
            </div>
            
            <form id="qr-form" action="${pageContext.request.contextPath}/scan-qr" method="post" class="hidden">
                <input type="hidden" id="qrData" name="qrData" value="">
            </form>
        </div>
    </div>
    
    <script>
        function docReady(fn) {
            if (document.readyState === "complete" || document.readyState === "interactive") {
                setTimeout(fn, 1);
            } else {
                document.addEventListener("DOMContentLoaded", fn);
            }
        }
        
        docReady(function() {
            var resultContainer = document.getElementById('qr-reader-results');
            var lastResult, countResults = 0;
            
            function onScanSuccess(decodedText, decodedResult) {
                if (decodedText !== lastResult) {
                    ++countResults;
                    lastResult = decodedText;
                    
                    // Submit form with QR data
                    document.getElementById('qrData').value = decodedText;
                    document.getElementById('qr-form').submit();
                }
            }
            
            var html5QrcodeScanner = new Html5QrcodeScanner(
                "qr-reader", { fps: 10, qrbox: 250 });
            html5QrcodeScanner.render(onScanSuccess);
        });
    </script>
</body>
</html>
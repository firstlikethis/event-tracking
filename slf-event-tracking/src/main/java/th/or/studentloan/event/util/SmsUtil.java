package th.or.studentloan.event.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.URL;
import java.net.URLEncoder;

import javax.net.ssl.HttpsURLConnection;

public class SmsUtil {
    
    private String smsUrl;
    private String publicKey;
    private String source;
    
    public void setSmsUrl(String smsUrl) {
        this.smsUrl = smsUrl;
    }
    
    public void setPublicKey(String publicKey) {
        this.publicKey = publicKey;
    }
    
    public void setSource(String source) {
        this.source = source;
    }
    
    public boolean sendSMS(String phoneNumber, String message) {
        try {
            // Create connection
            URL apiUrl = new URL(smsUrl);
            HttpsURLConnection conn = (HttpsURLConnection) apiUrl.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            conn.setDoOutput(true);
            
            // Prepare and send request body - สำคัญ: ใช้ text แทน message
            String postData = String.format("public_key=%s&text=%s&destination=%s&source=%s",
                    URLEncoder.encode(publicKey, "UTF-8"),
                    URLEncoder.encode(message, "UTF-8"),
                    URLEncoder.encode(phoneNumber, "UTF-8"),
                    URLEncoder.encode(source, "UTF-8"));
            
            // ส่งข้อมูล
            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = postData.getBytes("UTF-8");
                os.write(input, 0, input.length);
            }
            
            // รับการตอบกลับ
            int responseCode = conn.getResponseCode();
            StringBuilder response = new StringBuilder();
            try (BufferedReader br = new BufferedReader(
                    new InputStreamReader(conn.getInputStream(), "UTF-8"))) {
                String responseLine;
                while ((responseLine = br.readLine()) != null) {
                    response.append(responseLine.trim());
                }
            }
            
            return responseCode == 200 || responseCode == 201;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // ฟังก์ชันช่วย: แปลงเบอร์โทรศัพท์ให้อยู่ในรูปแบบมาตรฐาน
    private String formatPhoneNumber(String phoneNumber) {
        if (phoneNumber == null) {
            return null;
        }
        
        // ลบอักขระที่ไม่ใช่ตัวเลข
        return phoneNumber.replaceAll("[^0-9]", "");
    }
}
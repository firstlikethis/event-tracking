package th.or.studentloan.event.util;

import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;

import java.io.IOException;
import java.nio.charset.StandardCharsets;

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
        try (CloseableHttpClient httpClient = HttpClients.createDefault()) {
            HttpPost httpPost = new HttpPost(smsUrl);
            
            // Prepare JSON payload
            String json = String.format(
                "{\"public_key\":\"%s\",\"source\":\"%s\",\"destination\":\"%s\",\"message\":\"%s\"}",
                publicKey, source, phoneNumber, message
            );
            
            StringEntity entity = new StringEntity(json, StandardCharsets.UTF_8);
            httpPost.setEntity(entity);
            httpPost.setHeader("Content-Type", "application/json");
            httpPost.setHeader("Accept", "application/json");
            
            try (CloseableHttpResponse response = httpClient.execute(httpPost)) {
                String responseBody = EntityUtils.toString(response.getEntity());
                int statusCode = response.getStatusLine().getStatusCode();
                
                return statusCode >= 200 && statusCode < 300;
            }
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }
}
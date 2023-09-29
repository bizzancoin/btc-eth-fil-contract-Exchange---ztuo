package com.bizzan.er.market.utils;


import java.io.IOException;
import java.security.KeyManagementException;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import org.apache.http.HttpEntity;
import org.apache.http.HttpStatus;
import org.apache.http.NameValuePair;
import org.apache.http.StatusLine;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.config.Registry;
import org.apache.http.config.RegistryBuilder;
import org.apache.http.config.SocketConfig;
import org.apache.http.conn.DnsResolver;
import org.apache.http.conn.HttpConnectionFactory;
import org.apache.http.conn.ManagedHttpClientConnection;
import org.apache.http.conn.routing.HttpRoute;
import org.apache.http.conn.socket.ConnectionSocketFactory;
import org.apache.http.conn.socket.PlainConnectionSocketFactory;
import org.apache.http.conn.ssl.SSLConnectionSocketFactory;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.DefaultConnectionReuseStrategy;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.DefaultConnectionKeepAliveStrategy;
import org.apache.http.impl.client.DefaultHttpRequestRetryHandler;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.impl.conn.DefaultHttpResponseParserFactory;
import org.apache.http.impl.conn.ManagedHttpClientConnectionFactory;
import org.apache.http.impl.conn.PoolingHttpClientConnectionManager;
import org.apache.http.impl.conn.SystemDefaultDnsResolver;
import org.apache.http.impl.io.DefaultHttpRequestWriterFactory;
import org.apache.http.message.BasicHeader;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;

public class HttpClientUtil {
    
    private static String charSet = "UTF-8";
    private static CloseableHttpClient httpClient = null;
    private static CloseableHttpResponse response = null;
    
    static PoolingHttpClientConnectionManager manager = null;
    
    public static synchronized CloseableHttpClient getHttpClient(){

        if(httpClient == null){

            //注册访问协议相关的Socket工厂         
            Registry<ConnectionSocketFactory> socketFactoryRegistry = RegistryBuilder.<ConnectionSocketFactory>create()
                    .register("http", PlainConnectionSocketFactory.INSTANCE)
                    .register("https", SSLConnectionSocketFactory.getSystemSocketFactory())
                    .build();

            //HttpConnection 工厂:配置写请求/解析响应处理器
            HttpConnectionFactory<HttpRoute, ManagedHttpClientConnection> connectionFactory
              = new ManagedHttpClientConnectionFactory(DefaultHttpRequestWriterFactory.INSTANCE, 
                    DefaultHttpResponseParserFactory.INSTANCE);

            //DNS 解析器
            DnsResolver dnsResolver = SystemDefaultDnsResolver.INSTANCE;

            //创建池化连接管理器
            manager = new PoolingHttpClientConnectionManager(socketFactoryRegistry,connectionFactory,dnsResolver);

            //默认为Socket配置
            SocketConfig defaultSocketConfig = SocketConfig.custom().setTcpNoDelay(true).build();
            manager.setDefaultSocketConfig(defaultSocketConfig);

            manager.setMaxTotal(300); //设置整个连接池的最大连接数
            //每个路由的默认最大连接，每个路由实际最大连接数由DefaultMaxPerRoute控制，而MaxTotal是整个池子的最大数
            //设置过小无法支持大并发(ConnectionPoolTimeoutException) Timeout waiting for connection from pool
            manager.setDefaultMaxPerRoute(200);//每个路由的最大连接数
            //在从连接池获取连接时，连接不活跃多长时间后需要进行一次验证，默认为2s
            manager.setValidateAfterInactivity(5*1000);

            //默认请求配置
            RequestConfig defaultRequestConfig = RequestConfig.custom()
                    .setConnectTimeout(2*1000) //设置连接超时时间，2s
                    .setSocketTimeout(5*1000) //设置等待数据超时时间，5s
                    .setConnectionRequestTimeout(2000) //设置从连接池获取连接的等待超时时间
                    .build();

            //创建HttpClient
            httpClient = HttpClients.custom()
                    .setConnectionManager(manager)
                    .setConnectionManagerShared(false) //连接池不是共享模式
                    .evictIdleConnections(60, TimeUnit.SECONDS) //定期回收空闲连接
                    .evictExpiredConnections()// 定期回收过期连接
                    .setConnectionTimeToLive(60, TimeUnit.SECONDS) //连接存活时间，如果不设置，则根据长连接信息决定
                    .setDefaultRequestConfig(defaultRequestConfig) //设置默认请求配置
                    .setConnectionReuseStrategy(DefaultConnectionReuseStrategy.INSTANCE) //连接重用策略，即是否能keepAlive
                    .setKeepAliveStrategy(DefaultConnectionKeepAliveStrategy.INSTANCE) //长连接配置，即获取长连接生产多长时间
                    .setRetryHandler(new DefaultHttpRequestRetryHandler(0, false)) //设置重试次数，默认是3次，当前是禁用掉（根据需要开启）
                    .build();

            // 停止或重启时，关闭连接池释放掉连接(跟数据库连接池类似)
            Runtime.getRuntime().addShutdownHook(new Thread(){
                @Override
                public void run() {
                    try{
                        if(httpClient !=null){
                            httpClient.close();
                        }
                    }catch(IOException e){
                    }
                }
            });
        }
        return httpClient;
    }
    /**
     * https的post请求
     * @param url
     * @param jsonstr
     * @param charset
     * @return
     * @throws IOException 
     * @throws ClientProtocolException 
     * @throws KeyStoreException 
     * @throws NoSuchAlgorithmException 
     * @throws KeyManagementException 
     */
    public static String doHttpsPost(String url, String jsonStr, Map<String,String> headerPram) throws ClientProtocolException, IOException, KeyManagementException, NoSuchAlgorithmException, KeyStoreException {
        try {
            httpClient = SSLClient.createSSLClientDefault();
            HttpPost httpPost = new HttpPost(url);
            if(headerPram != null && !headerPram.isEmpty()) {
            	for(Map.Entry<String, String> entry:headerPram.entrySet()){
            		httpPost.setHeader(entry.getKey(), entry.getValue());
                }
            }
            
            StringEntity se = new StringEntity(jsonStr);
            se.setContentType("text/json");
            se.setContentEncoding(new BasicHeader("Content-Type", "application/json"));
            httpPost.setEntity(se);
            
            response = httpClient.execute(httpPost);
            if (response != null) {
                HttpEntity resEntity = response.getEntity();
                if (resEntity != null) {
                    return EntityUtils.toString(resEntity, charSet);
                }
            }
        }finally {
            if(httpClient != null){
                 httpClient.close();
            }
            if(response != null){
                  response.close();
            }
        }
        return null;
    }
    /**
     * http的post请求(用于key-value格式的参数) 
     * @param url
     * @param param
     * @return
     * @throws IOException 
     * @throws ClientProtocolException 
     * @throws KeyStoreException 
     * @throws NoSuchAlgorithmException 
     * @throws KeyManagementException 
     */
    public static String doHttpsPost(String url,Map<String,String> param, Map<String,String> headerPram) throws ClientProtocolException, IOException, KeyManagementException, NoSuchAlgorithmException, KeyStoreException{
        try {
            //请求发起客户端
            httpClient = SSLClient.createSSLClientDefault();
            //参数集合
            List<NameValuePair> postParams = new ArrayList<NameValuePair>();
            //遍历参数并添加到集合
            for(Map.Entry<String, String> entry:param.entrySet()){
                postParams.add(new BasicNameValuePair(entry.getKey(), entry.getValue()));
            }
            
            //通过post方式访问
            HttpPost post = new HttpPost(url);
            if(headerPram != null && !headerPram.isEmpty()) {
            	for(Map.Entry<String, String> entry:headerPram.entrySet()){
            		post.setHeader(entry.getKey(), entry.getValue());
                }
            }
            HttpEntity paramEntity = new UrlEncodedFormEntity(postParams,charSet);
            post.setEntity(paramEntity);
            response = httpClient.execute(post);
            StatusLine status = response.getStatusLine();  
            int state = status.getStatusCode();  
            if (state == HttpStatus.SC_OK) {  
                HttpEntity valueEntity = response.getEntity();
                String content = EntityUtils.toString(valueEntity);
                //jsonObject = JSONObject.fromObject(content);
                return content;
            }
        }finally{
            if(httpClient != null){
                httpClient.close();
            }
            if(response != null){
                response.close();
            }
        }
        return null;
    }
    /**
     * http的post请求(用于key-value格式的参数) 
     * @param url
     * @param param
     * @return
     * @throws IOException 
     * @throws ClientProtocolException 
     */
    public static String doHttpPost(String url,Map<String,String> param, Map<String,String> headerPram) throws ClientProtocolException, IOException{
        try {
            //请求发起客户端
            httpClient = HttpClients.createDefault();
            //参数集合
            List<NameValuePair> postParams = new ArrayList<NameValuePair>();
            //遍历参数并添加到集合
            for(Map.Entry<String, String> entry:param.entrySet()){
                postParams.add(new BasicNameValuePair(entry.getKey(), entry.getValue()));
            }
            
            //通过post方式访问
            HttpPost post = new HttpPost(url);
            if(headerPram != null && !headerPram.isEmpty()) {
            	for(Map.Entry<String, String> entry:headerPram.entrySet()){
            		post.setHeader(entry.getKey(), entry.getValue());
                }
            }
            HttpEntity paramEntity = new UrlEncodedFormEntity(postParams,charSet);
            post.setEntity(paramEntity);
            response = httpClient.execute(post);
            StatusLine status = response.getStatusLine();  
            int state = status.getStatusCode();  
            if (state == HttpStatus.SC_OK) {
                HttpEntity valueEntity = response.getEntity();
                String content = EntityUtils.toString(valueEntity);
                return content;
            }else {
            	return null;
            }
        }finally{
            if(httpClient != null){
                httpClient.close();
            }
            if(response != null){
                response.close();
            }
        }
    }
    
     /** 
     * http的post请求（用于请求json格式的参数） 
     * @param url 
     * @param params 
     * @return 
     * @throws IOException 
     * @throws ClientProtocolException 
     */  
    public static String doHttpPost(String url, String jsonStr, Map<String,String> headerPram) throws ClientProtocolException, IOException {  
        try {
            httpClient = HttpClients.createDefault();
          
            // 创建httpPost
            HttpPost httpPost = new HttpPost(url);     
            if(headerPram != null && !headerPram.isEmpty()) {
            	for(Map.Entry<String, String> entry:headerPram.entrySet()){
            		httpPost.setHeader(entry.getKey(), entry.getValue());
                }
            }
              
            StringEntity entity = new StringEntity(jsonStr, charSet);  
            entity.setContentType("text/json");
            entity.setContentEncoding(new BasicHeader("Content-Type", "application/json"));
            httpPost.setEntity(entity);          
            //发送post请求
            response = httpClient.execute(httpPost);  
            if (response.getStatusLine().getStatusCode() == HttpStatus.SC_OK) {  
                HttpEntity responseEntity = response.getEntity();  
                String jsonString = EntityUtils.toString(responseEntity);  
                return jsonString;  
            }
        }finally {
            if(httpClient != null){
                httpClient.close();
            }
            if(response != null){
                response.close();
            }
        }  
        return null;  
    }  
    
    /**
     * http的Get请求
     * @param url
     * @param param
     * @return
     * @throws IOException 
     * @throws ClientProtocolException 
     */
    public static String doHttpGet(String url, Map<String,String> param, Map<String,String> headerPram) throws ClientProtocolException, IOException {
        CloseableHttpClient httpclient = null;
        CloseableHttpResponse response = null;
        
        httpclient = getHttpClient();//HttpClients.createDefault();
        if(param != null && !param.isEmpty()) {
            //参数集合
            List<NameValuePair> getParams = new ArrayList<NameValuePair>();
            for(Map.Entry<String, String> entry:param.entrySet()){
                getParams.add(new BasicNameValuePair(entry.getKey(), entry.getValue()));
            }
            url +="?"+EntityUtils.toString(new UrlEncodedFormEntity(getParams), "UTF-8");
        }
        //发送gey请求
        HttpGet httpGet = new HttpGet(url);
        RequestConfig rconfig = RequestConfig.custom()
        		.setConnectionRequestTimeout(5000)
        		.setSocketTimeout(10000)
        		.setConnectTimeout(5000)
        		.build();
        httpGet.setConfig(rconfig);
        if(headerPram != null && !headerPram.isEmpty()) {
        	for(Map.Entry<String, String> entry:headerPram.entrySet()){
        		httpGet.setHeader(entry.getKey(), entry.getValue());
            }
        }
        response = httpclient.execute(httpGet);  
        if (response.getStatusLine().getStatusCode() == HttpStatus.SC_OK) {  
            return EntityUtils.toString(response.getEntity());  
        }
        return null;
    }
    /**
     * https的Get请求
     * @param url
     * @param param
     * @return
     * @throws IOException 
     * @throws ClientProtocolException 
     * @throws KeyStoreException 
     * @throws NoSuchAlgorithmException 
     * @throws KeyManagementException 
     */
    public static String doHttpsGet(String url, Map<String,String> param, Map<String,String> headerPram) throws ClientProtocolException, IOException, KeyManagementException, NoSuchAlgorithmException, KeyStoreException {
        httpClient = getHttpClient();//SSLClient.createSSLClientDefault();
        if(param != null && !param.isEmpty()) {
            //参数集合
            List<NameValuePair> getParams = new ArrayList<NameValuePair>();
            for(Map.Entry<String, String> entry:param.entrySet()){
                getParams.add(new BasicNameValuePair(entry.getKey(), entry.getValue()));
            }
            url +="?"+EntityUtils.toString(new UrlEncodedFormEntity(getParams), "UTF-8");
        }
        HttpGet httpGet = new HttpGet(url);
        RequestConfig rconfig = RequestConfig.custom()
        		.setConnectionRequestTimeout(2000)
        		.setSocketTimeout(4000)
        		.setConnectTimeout(3000)
        		.build();
        httpGet.setConfig(rconfig);
        if(headerPram != null && !headerPram.isEmpty()) {
        	for(Map.Entry<String, String> entry:headerPram.entrySet()){
        		httpGet.setHeader(entry.getKey(), entry.getValue());
            }
        }
        response = httpClient.execute(httpGet);
        if (response != null) {
            HttpEntity resEntity = response.getEntity();
            if (resEntity != null) {
                return EntityUtils.toString(resEntity, charSet);
            }
        }
        return null;
    }
}
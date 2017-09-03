<%--
 * The MIT License
 *
 * Copyright 2017 Simon Schmidt.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
--%>
<%@page contentType="text/plain" pageEncoding="UTF-8"%>
<%@page import="java.net.*,com.google.common.base.Strings"%>
<%@page import="com.googlecode.objectify.*,webidee.gaechan.mdl.*,org.apache.commons.fileupload.*,org.apache.commons.fileupload.servlet.*" %>
<%@page import="com.google.appengine.api.images.*,com.google.appengine.api.urlfetch.*,webidee.gaechan.Facade"%>
<%
    //Facade.setRedirect(response, "/user_admin.jsp");
    if(!(Boolean)request.getAttribute("chan.is_login"))return;
    String trapcode = (String)request.getAttribute("chan.trapcode");
    
    String imageUrl = null;
    String type = Strings.nullToEmpty(request.getParameter("type"));
    String email = request.getParameter("email");
    String cat = request.getParameter("cat");
    String text = request.getParameter("text");
    
    {
        if("adorable".equals(type)){
            
            if(Strings.isNullOrEmpty(email)) return;
            imageUrl = "https://api.adorable.io/avatars/128/"+email+".png";
        }
        else{//"lorempixel"
            imageUrl = "http://lorempixel.com/128/128";
            
            if(Strings.isNullOrEmpty(cat)&&!Strings.isNullOrEmpty(text)) cat = "people";
            if(!Strings.isNullOrEmpty(cat)) imageUrl+="/"+cat.replaceAll("[\\/\\s]+", "");
            if(!Strings.isNullOrEmpty(text)) imageUrl+="/"+URLEncoder.encode(text.replaceAll("[\\/\\s]+", "-"),"ISO-8859-1");
            if(!imageUrl.endsWith("/"))imageUrl+="/";
        }
    }
    URLFetchService service = URLFetchServiceFactory.getURLFetchService();
    HTTPResponse imageResp = service.fetch(new URL(imageUrl));
    if(imageResp.getResponseCode()!=200){
        out.println("Text = "+text.replaceAll("\\/+\\s", "-"));
        out.println("GET "+imageUrl);
        out.println(imageResp.getResponseCode());
        out.println(new String(imageResp.getContent(),"ISO-8859-1"));
        return;
    }
    Facade.setRedirect(response, "/user_admin.jsp");
    
    Image image = null;
    byte[] nblob = null;
    image = ImagesServiceFactory.makeImage(imageResp.getContent());
    
    if(image!=null){
        ImagesService imagesService = ImagesServiceFactory.getImagesService();
        
        image = imagesService.applyTransform(ImagesServiceFactory.makeResize(128, 128, true), image, ImagesService.OutputEncoding.JPEG);
        nblob = image.getImageData();
    }
    if(nblob==null){
        return;
    }
    Account account = ObjectifyService.ofy().load().type(Account.class).id(trapcode).now();
    if(account == null){
        account = new Account();
        account.me = trapcode;
        account.owner = trapcode;
    }
    account.picture = nblob;
    ObjectifyService.ofy().save().entity(account).now();
%>
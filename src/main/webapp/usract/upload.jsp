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
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.googlecode.objectify.*,webidee.gaechan.mdl.*,org.apache.commons.fileupload.*,org.apache.commons.fileupload.servlet.*" %>
<%@page import="com.google.appengine.api.images.*,webidee.gaechan.Facade"%>
<%
    Facade.setRedirect(response, "/user_admin.jsp");
    if(!(Boolean)request.getAttribute("chan.is_login"))return;
    if(!ServletFileUpload.isMultipartContent(request)){
        return;
    }
    String trapcode = (String)request.getAttribute("chan.trapcode");
    
    FileItemFactory ff = new webidee.gaechan.machine.util.BAFileItemFactory();
    ServletFileUpload upload = new ServletFileUpload(ff);
    upload.setFileSizeMax(1<<19);
    Image image = null;
    byte[] nblob = null;
    
    for(FileItem item:upload.parseRequest(request)){
        if(item.isFormField())continue;
        image = ImagesServiceFactory.makeImage(item.get());
        break;
    }
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
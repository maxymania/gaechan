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
<%@page import="com.google.appengine.api.users.*,webidee.gaechan.Facade,com.google.common.base.*"%>
<%
    Facade.setRedirect(response, "/chan/"+request.getParameter("key"));
    UserService service = UserServiceFactory.getUserService();
    if(!service.isUserAdmin())return;
    String key = request.getParameter("key");
    String title = request.getParameter("title");
    String description = request.getParameter("description");
    if(key==null)return;
    if(Strings.isNullOrEmpty(title))title = key;
    if(Strings.isNullOrEmpty(description)) description = "[h1]"+title+"[/h1]";
    Key<Chan> chan = Key.create(Chan.class,key);
    Chan nobj =ObjectifyService.ofy().load().key(chan).now();
    if(nobj==null)return;
    nobj.title = title;
    nobj.description = description;
    ObjectifyService.ofy().save().entity(nobj).now();
%>
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
<%@page import="com.googlecode.objectify.*,webidee.gaechan.mdl.*,org.apache.commons.fileupload.*,org.apache.commons.fileupload.servlet.*" %>
<%@page import="com.google.appengine.api.users.*,com.google.appengine.api.taskqueue.*,webidee.gaechan.Facade,com.google.common.base.*"%>
<%
    {
        String redirect = request.getParameter("redirect");
        if(redirect!=null)
            Facade.setRedirect(response, redirect);
    }
    
    UserService service = UserServiceFactory.getUserService();
    if(!service.isUserAdmin())return;
    
    String thread = request.getParameter("thread");
    if(thread==null)return;
    
    Key<Chanthrd> tkey = Key.create(Chanthrd.class,thread);
    ObjectifyService.ofy().delete().key(tkey).now();
    
    Queue queue = QueueFactory.getDefaultQueue();
    queue.add(TaskOptions.Builder.withUrl("/eo/delthrd_task.jsp").param("thread", thread));
    
    //out.println(ObjectifyService.ofy().load().ancestor(tkey).keys().list());
    //ObjectifyService.ofy().load().ancestor(tkey).keys();
    
    //
%>
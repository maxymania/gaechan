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
<%@page import="com.google.appengine.api.images.*,webidee.gaechan.Facade,com.google.common.base.*"%>
<%
    Facade.setRedirect(response, "/user_admin.jsp");
    String trapcode = (String)request.getAttribute("chan.trapcode");
    if(!(Boolean)request.getAttribute("chan.is_login"))return;
    if(request.getParameter("a_username")==null)return;
    if(request.getParameter("a_password")==null)return;
    String childKey = Facade.calcTrapcodeBase64(request.getParameter("a_username")+"#"+request.getParameter("a_password"));
    //com.google.common.escape.Escaper
    
    Result<Key<Account>> store1=null,store2;
    LoadResult<Account> childObjFuture = ObjectifyService.ofy().load().type(Account.class).id(childKey);
    Account account = ObjectifyService.ofy().load().type(Account.class).id(trapcode).now();
    if(account == null){
        account = new Account();
        account.me = trapcode;
        account.owner = trapcode;
        store1 = ObjectifyService.ofy().save().entity(account);
    }
    if(!Objects.equal(account.me, account.owner))return;
    Account childObj = childObjFuture.now();
    if(childObj==null){
        childObj = new Account();
        childObj.me = childKey;
        childObj.owner = trapcode;
    }else{
        if(!Objects.equal(childObj.me, childObj.owner))return;
        childObj.owner = trapcode;
    }
    store2 = ObjectifyService.ofy().save().entity(childObj);
    if(store1!=null)store1.now();
    store2.now();
%>
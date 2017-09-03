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
<%@page import="com.google.appengine.api.users.*,webidee.gaechan.Facade,com.google.common.base.*"%>
<%
    String trapcode = (String)request.getAttribute("chan.trapcode");
    Facade.setRedirect(response, "/chan/" + request.getParameter("chan")+"/"+request.getParameter("thrd"));
    //String chank = Strings.nullToEmpty(request.getParameter("chan")).replaceAll("^\\/+|\\/+$", "");
    String chank = request.getParameter("chan");
    String thrdk = request.getParameter("thrd");
    String title = request.getParameter("title");
    String body = request.getParameter("body");

    if (Strings.isNullOrEmpty(chank)) return;
    if (Strings.isNullOrEmpty(thrdk)) return;
    if (Strings.isNullOrEmpty(title)) return;
    if (Strings.isNullOrEmpty(body)) return;

    
    String ctk = chank+"/"+thrdk;
    Key<Chanthrd> tk = Key.create(Chanthrd.class, ctk);
    Chanthrd thread = ObjectifyService.ofy().load().now(tk);
    if (thread == null) return;
    if(thread.pageCount<1) return;
    
    Key<ChanthrdPage> pk = Key.create(tk,ChanthrdPage.class, thread.pageCount);
    ChanthrdPage pag = ObjectifyService.ofy().load().now(pk);
    if(pag==null){
        pag = new ChanthrdPage();
        pag.parent = tk;
        pag.ident = thread.pageCount;
        ObjectifyService.ofy().save().entity(pag);
    }
    pag.entryCount++;
    if(pag.entryCount>10L){ // TODO: remove hard-coded constant.
        thread.pageCount++;
        pk = Key.create(tk,ChanthrdPage.class, thread.pageCount);
        pag = new ChanthrdPage();
        pag.parent = tk;
        pag.ident = thread.pageCount;
        pag.entryCount++;
        ObjectifyService.ofy().save().entity(thread);
    }
    ObjectifyService.ofy().save().entity(pag);
    ChanthrdPageEntry entry = new ChanthrdPageEntry();
    entry.parent = pk;
    
    entry.ident = pag.entryCount;
    entry.title = title;
    entry.body = body;
    entry.trapcode = trapcode;
    ObjectifyService.ofy().save().entity(entry);
    
    Facade.setRedirect(response, "/chan/" + ctk + "/" + pag.ident);
%>

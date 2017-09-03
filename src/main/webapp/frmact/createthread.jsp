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
    Facade.setRedirect(response, "/chan/" + request.getParameter("chan"));
    //String chank = Strings.nullToEmpty(request.getParameter("chan")).replaceAll("^\\/+|\\/+$", "");
    String chank = request.getParameter("chan");
    String title = request.getParameter("title");
    String body = request.getParameter("body");

    if (Strings.isNullOrEmpty(chank)) return;
    if (Strings.isNullOrEmpty(title)) return;
    if (Strings.isNullOrEmpty(body)) return;

    Chan chan = ObjectifyService.ofy().load().type(Chan.class).id(chank).now();
    if (chan == null) {
        return;
    }
    Chanthrd thread = new Chanthrd();
    ChanthrdPage threadPage = new ChanthrdPage();
    ChanthrdPageEntry threadPageEntry = new ChanthrdPageEntry();

    thread.chan = chank;
    String key;
    java.util.Random random = new java.util.Random();
    boolean used;
    do {
        key = chank + "/" + (("" + random.nextLong()).replaceAll("[^0-9]+", ""));
        used = ObjectifyService.ofy().load().type(Chanthrd.class).id(key).now() != null;
    } while (used);
    
    Key<Chanthrd> tkey = Key.create(Chanthrd.class, key);
    Key<ChanthrdPage> pkey = Key.create(tkey,ChanthrdPage.class, 1L);

    thread.key = key;
    thread.title = title;
    thread.pageCount = 1;
    thread.trapcode = trapcode;
    threadPage.parent = tkey;
    threadPage.ident = 1L;
    threadPage.entryCount = 1;
    threadPageEntry.ident = 1L;
    threadPageEntry.parent = pkey;
    threadPageEntry.title = title;
    threadPageEntry.body  = body;
    threadPageEntry.trapcode = trapcode;
    
    Result<?> results[] = {
        ObjectifyService.ofy().save().entity(thread),
        ObjectifyService.ofy().save().entity(threadPage),
        ObjectifyService.ofy().save().entity(threadPageEntry),
    };
    for(Result<?> result:results) result.now();
    Facade.setRedirect(response, "/chan/" + key);
%>

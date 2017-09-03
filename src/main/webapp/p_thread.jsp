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
<%@page import="webidee.gaechan.BBCodeToHtml"%>
<%@page import="com.google.common.base.Strings"%>
<%@page import="java.util.Locale"%>
<%@page import="org.apache.commons.lang3.time.FastDateFormat"%>
<%@page import="webidee.gaechan.mdl.*,java.util.List,org.apache.commons.text.StringEscapeUtils" %>
<%@page import="com.googlecode.objectify.*" %>
<div style="border: solid 1px #ccc; margin: 0 auto; width: 980px;">
    <%
        String trapcode = (String)request.getAttribute("chan.trapcode");
        String profile = getServletContext().getInitParameter("chan.profile");
        String chank = request.getParameter("chan");
        String thrdk = request.getParameter("thrd");
        String pagek = request.getParameter("page");
        if (chank == null) return;
        if (thrdk == null) return;
        if (pagek == null) return;
        //Long thrdl = Long.parseLong(thrdk);
        Long pagel = Long.parseLong(pagek);
        if (pagel<1) return;
        
        Chan chanF = ObjectifyService.ofy().load().type(Chan.class).id(chank).now();
        
        Key<Chanthrd> threadk = Key.create(Chanthrd.class, chank+"/"+thrdk);
        Key<ChanthrdPage> vtkp = Key.create(threadk, ChanthrdPage.class, pagel);
        Chanthrd thread = ObjectifyService.ofy().load().now(threadk);
        if(thread==null)return;
        
        ChanthrdPage vtpage = ObjectifyService.ofy().load().now(vtkp);
        //boolean hasnext = ObjectifyService.ofy().load().now(Key.create(threadk, ChanthrdPage.class, pagel+1))==null;
        
        List<ChanthrdPageEntry> entries = ObjectifyService.ofy().load().type(ChanthrdPageEntry.class).ancestor(vtkp).list();

        FastDateFormat dtfmt = FastDateFormat.getDateTimeInstance(FastDateFormat.MEDIUM, FastDateFormat.MEDIUM, Locale.GERMAN);

        boolean is_admin = (Boolean)request.getAttribute("google.user.is_admin");
        //List<Chan> channels = ObjectifyService.ofy().load().type(Chan.class).list();

        String cur_url = (String)request.getAttribute("chan.http.uri");
%>
    <h1><%=StringEscapeUtils.escapeHtml4(thread.title)%></h1>
    <a href="/chan/<%=StringEscapeUtils.escapeHtml4(thread.key)%>">/chan/<%=StringEscapeUtils.escapeHtml4(thread.key)%></a>
    <hr/>
    <table style="width: -moz-available; width: -webkit-fill-available;">
        <tbody>
            <tr>
                <th>Chan</th>
                <th style="width: 420px">Author</th>
                <th style="width: 150px">Started</th>
            </tr>
            <tr>
                <td>
                    <%
                        if(chanF!=null){
                    %>
                    <a href="/chan/<%=StringEscapeUtils.escapeHtml4(thread.chan)%>"><%= StringEscapeUtils.escapeHtml4("" + chanF.title)%></a>
                    <%
                        }else{
                    %>
                    /chan/<%=StringEscapeUtils.escapeHtml4(thread.chan)%>
                    <%
                        }
                    %>
                </td>
                <td><a href="<%=profile%>usr/<%=thread.trapcode%>"><%=thread.trapcode%></a></td>
                <td><%=StringEscapeUtils.escapeHtml4(thread.age==null?"<nil>":dtfmt.format(thread.age))%></td>
            </tr>
        </tbody>
    </table>
    <table style="width: -moz-available; width: -webkit-fill-available;">
        <tbody>
            <tr>
                <td>
                    <%
                        if(pagel>1){
                    %>
                    <a href="/chan/<%=StringEscapeUtils.escapeHtml4(thread.key)%>/<%=pagel-1%>">Page <%=pagel-1%> (Back)</a>
                    <%
                        }
                    %>
                </td>
                <td style="text-align: right;">
                    <%
                        if(vtpage!=null){
                    %>
                    <a href="/chan/<%=StringEscapeUtils.escapeHtml4(thread.key)%>/<%=pagel+1%>">Page <%=pagel+1%> (Forward)</a>
                    <%
                        }
                    %>
                </td>
            </tr>
        </tbody>
    </table>
    <hr/>
    <table style="width: -moz-available; width: -webkit-fill-available;">
        <tbody>
            <%
                if(entries!=null)for(ChanthrdPageEntry entry:entries){
            %>
            <tr>
                <td style="width: 150px">
                    <a href="<%=profile%>usr/<%=entry.trapcode%>">
                        <img width="128" height="128" src="<%=profile%>userimg/<%=entry.trapcode%>"/>
                    </a>
                </td>
                <td valign="top">
                    <b id="entry-<%=entry.ident%>"><%=StringEscapeUtils.escapeHtml4(entry.title)%></b><br/>
                    <span style="font-size: 9pt">
                        By:<span style="color: #aaa"><%=entry.trapcode%></span>
                        Time:<span style="color: #aaa"><%=StringEscapeUtils.escapeHtml4(entry.age==null?"<nil>":dtfmt.format(entry.age))%></span><br/>
                    </span>
                    <%=BBCodeToHtml.bb2html(entry.body)%>
                </td>
            </tr>
            <tr>
                <td></td>
                <td style="width: -moz-available; width: -webkit-fill-available;">
                    <%
                        if(is_admin){
                    %>
                    <button>Quote</button>
                    <button>Stuff</button>
                    <form style="display: inline" method="POST" action="/eo/delent.jsp">
                        <input type="hidden" name="redirect" value="<%= StringEscapeUtils.escapeHtml4(cur_url)%>"/>
                        <input type="hidden" name="thread" value="<%= StringEscapeUtils.escapeHtml4(chank+"/"+thrdk) %>"/>
                        <input type="hidden" name="page" value="<%= pagel %>"/>
                        <input type="hidden" name="entry" value="<%= entry.ident %>"/>
                        <button type="submit">Delete</button>
                    </form>
                    <%
                        }
                    %>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <hr/>
                </td>
            </tr>
            <%
                }
            %>
            <tr>
                <td style="width: 150px">
                    <%
                        // trapcode
                        if((Boolean)request.getAttribute("chan.is_login")){
                    %>
                    <a href="<%=profile%>usr/<%=trapcode%>">
                        <img width="128" height="128" src="<%=profile%>userimg/<%=trapcode%>"/>
                    </a>
                    <%
                        }
                    %>
                </td>
                <td>
                    <form action="/frmact/post2thread.jsp" method="POST">
                        <input type="hidden" name="chan" value="<%=chank%>"/>
                        <input type="hidden" name="thrd" value="<%=thrdk%>"/>
                        Title:<br/>
                        <input type="text" name="title" style="width: -moz-available; width: -webkit-fill-available;" autocomplete="off"
                               value="<%=StringEscapeUtils.escapeHtml4(thread.title)%>"/><br/>
                        Text:<br/>
                        <textarea name="body" style="width: -moz-available; width: -webkit-fill-available; height: 200px"></textarea><br/>
                        <button>Post to Thread</button>
                    </form>
                </td>
            </tr>
        </tbody>
    </table>
</div>
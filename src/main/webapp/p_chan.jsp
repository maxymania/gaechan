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
<%@page import="java.net.URLEncoder"%>
<%@page import="webidee.gaechan.BBCodeToHtml"%>
<%@page import="com.google.common.base.Strings"%>
<%@page import="java.util.Locale"%>
<%@page import="org.apache.commons.lang3.time.FastDateFormat"%>
<%@page import="webidee.gaechan.mdl.*,java.util.List,org.apache.commons.text.StringEscapeUtils" %>
<%@page import="com.googlecode.objectify.*" %>
<div style="border: solid 1px #ccc; margin: 0 auto; width: 980px;">
    <%
        String profile = getServletContext().getInitParameter("chan.profile");
        String chank = request.getParameter("chan");
        if (chank == null) {
            return;
        }
        //chank = chank.replaceAll("^\\/+|\\/+$", "");
        Chan chanF = ObjectifyService.ofy().load().type(Chan.class).id(chank).now();
        if(chanF==null) return;
        
        StringBuilder thatUrl = new StringBuilder();
        thatUrl.append(request.getAttribute("chan.http.uri"));
        int range = 100;
        int nskip = 0;
        {
            String skip = request.getParameter("skip");
            if(!Strings.isNullOrEmpty(skip))
                thatUrl.append("?skip=").append(URLEncoder.encode(skip, "UTF-8"));
            try{
                nskip = Integer.parseInt(skip);
            }catch(Exception e){}
            if(nskip<0)nskip = 0;
        }
        String cur_url = thatUrl.toString();
        
        List<Chanthrd> threads = ObjectifyService.ofy().load().type(Chanthrd.class).filter("chan", chank).order("-age").offset(nskip*range).limit(range).list(); // .order("-age")

        FastDateFormat dtfmt = FastDateFormat.getDateTimeInstance(FastDateFormat.MEDIUM, FastDateFormat.MEDIUM, Locale.GERMAN);

        boolean is_admin = (Boolean)request.getAttribute("google.user.is_admin");
        //List<Chan> channels = ObjectifyService.ofy().load().type(Chan.class).list();
%>
    <h1><%=StringEscapeUtils.escapeHtml4(chanF.title)%></h1>
    <p><%=BBCodeToHtml.bb2html(chanF.description)%></p>
    <hr/>
    <%
        if(is_admin){
    %>
    <form action="/eo/change.jsp" method="POST">
        <input type="hidden" name="key" value="<%=chank%>"/>
        Title:<br/>
        <input type="text" name="title" autocomplete="off"
               value="<%=StringEscapeUtils.escapeHtml4(chanF.title)%>"
               style="width: -moz-available; width: -webkit-fill-available;"/><br/>
        Description:<br/>
        <textarea
            style="width: -moz-available; width: -webkit-fill-available;"
            name="description"><%=StringEscapeUtils.escapeHtml4(chanF.description)%></textarea><br/>
        <button type="submit">Change</button>
    </form>
    <hr/>
    <%
        }
    %>
    <table style="width: -moz-available; width: -webkit-fill-available;">
        <tbody>
            <tr>
                <td style="width:100px">Page <%=nskip+1%></td>
                <td>
                    <%
                        if(nskip>0)
                        {
                    %>
                    <a href="<%=request.getAttribute("chan.http.uri")%><%=nskip==1?"":"?skip="+(nskip-1)%>">Older</a>
                    <%  }   %>
                </td>
                <td style="text-align: right;">
                    <%
                        if(threads.size()==range)
                        {
                    %>
                    <a href="<%=request.getAttribute("chan.http.uri")%>?skip=<%=nskip+1%>">Newer</a>
                    <%  }   %>
                </td>
            </tr>
        </tbody>
    </table>
    <hr/>
    <table style="width: -moz-available; width: -webkit-fill-available;">
        <tbody>
            <tr>
                <th>Title</th>
                <th style="width: 270px">Author</th>
                <th style="width: 100px">Date</th>
                <%
                    if(is_admin){
                %>
                <th style="width: 70px"></th>
                <%
                    }
                %>
            </tr>
            <%
                if (threads != null) for (Chanthrd thread : threads) {
                    String age = thread.age == null ? "" : dtfmt.format(thread.age);
            %>
            <tr>
                <td><a href="/chan/<%=StringEscapeUtils.escapeHtml4(thread.key)%>"><%= StringEscapeUtils.escapeHtml4("" + thread.title)%></a></td>

                <td style="font-size: 8pt"><a href="<%=profile%>usr/<%=thread.trapcode%>"><%=thread.trapcode%></a></td>
                <td style="font-size: 8pt"><%=StringEscapeUtils.escapeHtml4(age)%></td>
                <%
                    if(is_admin){
                %>
                <td>
                    <form method="POST" action="/eo/delthrd.jsp">
                        <input type="hidden" name="redirect" value="<%=StringEscapeUtils.escapeHtml4(cur_url)%>"/>
                        <input type="hidden" name="thread" value="<%=StringEscapeUtils.escapeHtml4(thread.key)%>"/>
                        <button type="submit">Delete</button>
                    </form>
                </td>
                <%
                    }
                %>
            </tr>
            <%
                }
            %>
        </tbody>
    </table>
    <hr/>
    <b>Creating a new Thread:</b>
    <form action="/frmact/createthread.jsp" method="POST">
        <input type="hidden" name="chan" value="<%=chank%>"/>
        Title:<br/>
        <input type="text" name="title" autocomplete="off" style="width: -moz-available; width: -webkit-fill-available;"/><br/>
        Text:<br/>
        <textarea name="body"style="width: -moz-available; width: -webkit-fill-available; height: 200px"></textarea><br/>
        <button>Create new Thread</button>
    </form>
</div>
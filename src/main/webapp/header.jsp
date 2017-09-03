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
<%@page import="org.apache.commons.text.StringEscapeUtils"%>
<div style="border-bottom: solid 1px #ccc; margin: 0px; padding: 1px 1px 5px 1px">
    <!-- height: 40px; -->
    <%
        String profile = getServletContext().getInitParameter("chan.profile");
        String trapcode = (String)request.getAttribute("chan.trapcode");
    %>
    <div style="display: inline; margin-left: 2.0em;">
        <%
            if((Boolean)request.getAttribute("chan.security.secure"))
            //if(false)
            {
        %>
        Trapkey:
        <form action="/login" method="POST" style="display: inline;">
            <input type="hidden" name="redirect" value="<%= request.getAttribute("chan.http.uri")%>"/>
            <input type="text" name="user"/>#<input type="password" name="passwd"/>
            <button type="submit">(Re-)Login</button>
        </form>
        Trapcode: <span style="font-size: 9pt"><%=trapcode %></span>
        <%
            }else{
        %>
        <span class="redlink">
        Warning, you are using an <b>Insecure</b> Connection.
        Use <a href="<%=StringEscapeUtils.escapeHtml4(""+request.getAttribute("chan.security.https"))%>"><b>HTTPS</b></a>
        </span>
        <%
            }
        %>
    </div>
    <div style="display: inline; margin-left: 2.0em; font-size: 9pt">
        <%
            if((Boolean)request.getAttribute("chan.is_login")){
        %>
        <a href="<%=profile%>usr/<%= trapcode%>">View User Profile</a>
        <a href="<%=profile%>user_admin.jsp">Manage User Profile</a>
        <%
            }
        %>
        <%
            if((Boolean)request.getAttribute("google.user.is_admin")){
        %>
        <a href="/employees_only.jsp"><b>EO</b>Administration</a>
        <a href="<%=request.getAttribute("google.url.logout")%>"><b>EO</b>Logout</a>
        <%
            }else if((Boolean)request.getAttribute("google.user.is_login")){
        %>
        <a href="<%=request.getAttribute("google.url.logout")%>"><b>Google-</b>Logout</a>
        <%
            }else{
        %>
        <a href="<%=request.getAttribute("google.url.login")%>">Employees Only</a>
        <%
            }
        %>
        <%-- <a href="/_ah/admin">Admin</a> --%>
    </div>
</div>
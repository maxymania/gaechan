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
<%@page import="webidee.gaechan.mdl.*,java.util.List,org.apache.commons.text.StringEscapeUtils" %>
<%@page import="com.googlecode.objectify.ObjectifyService" %>
<div style="border: solid 1px #ccc; margin: 0 auto; width: 980px;">
    <%
        List<Chan> channels = ObjectifyService.ofy().load().type(Chan.class).list();
    %>
    <table>
        <tbody>
            <tr>
                <th>Title</th>
                <th>URL</th>
            </tr>
            <%
                if(channels!=null)for(Chan chan:channels){
            %>
            <tr>
                <td><%= StringEscapeUtils.escapeHtml4(chan.title) %></td>
                <td><a href="/chan/<%= StringEscapeUtils.escapeHtml4(chan.key) %>">/chan/<%= StringEscapeUtils.escapeHtml4(chan.key) %></a></td>
            </tr>
            <%
                }
            %>
        </tbody>
    </table>
</div>